library(here)
library(readr)
library(stringr)
library(data.table)

convert_num_units <- function(x,
                              units = c("k", "m", "b", "t"),
                              multipliers = c(1e3, 1e6, 1e9, 1e12)){
  n_na <- sum(is.na(x))
  units <- str_to_upper(units)
  units_le <- str_c(units, "$")
  unit_regex <- regex(str_c(units_le, collapse = "|"),
                      ignore_case = TRUE)

  has_unit <- str_detect(x, unit_regex)
  no_unit <- which(!has_unit)
  has_unit <- which(has_unit)
  xx <- rep(NA, length(x))
  xx[no_unit] <- as.numeric(x[no_unit])

  num <- as.numeric(str_remove(x[has_unit], unit_regex))
  unit_matches <- str_match(x[has_unit], unit_regex)
  unit_matches <- str_to_upper(unit_matches)
  ui <- match(unit_matches, units)
  xx[has_unit] <- num * multipliers[ui]
  if(sum(is.na(xx)) > n_na) warning("NAs introducted in coercion, check units")
  xx
}

# gapminder data  FREE DATA FROM WORLD BANK VIA GAPMINDER.ORG, CC-BY LICENSE
# income_per_person_messy.csv, downloaded from http://gapm.io/dgdppc
gdp_data <- read_csv(here("data/class3/income_per_person_messy.csv"))
gdp_data <- as.data.frame(gdp_data)
gdp_data[2:ncol(gdp_data)] <- lapply(gdp_data[2:ncol(gdp_data)], convert_num_units)
gdp_data <- as_tibble(gdp_data)
write_csv(gdp_data, "data/class3/income_per_person.csv")

# population per country downloaded from http://gapm.io/dpop

og_pop_data <- read_csv(here("data/class3/messy_country_pop.csv"))
pop_data <- as.data.frame(og_pop_data)
pop_data[2:ncol(pop_data)] <- lapply(pop_data[2:ncol(pop_data)], convert_num_units)
pop_data <- as_tibble(pop_data)
write_csv(gdp_data, "data/class3/country_population.csv")

# ----------
# fly proteomics data
# ----------

tf <- tempfile(fileext = ".gz")
on.exit(unlink(tf))
download.file("http://ftp.flybase.org/flybase/associated_files/DeJung.2018.2.9.peptides_lifecycle.txt.gz",
              tf)

# note use of read.table rather than read_tsv,
# as read_tsv doesn't handle a default table produced by write.table ...
prot_dat <- fread(tf, data.table = FALSE)
prot_dat <- prot_dat[prot_dat$`Unique..Proteins.` == "yes", ]
cols_to_keep <- c("Sequence",
                  "Proteins",
                  colnames(prot_dat)[grep("Intensity.", colnames(prot_dat))])

prot_dat <- prot_dat[cols_to_keep]
colnames(prot_dat) <- gsub("Intensity.", "", colnames(prot_dat))
prot_dat[, 3:ncol(prot_dat)] <- prot_dat[, 3:ncol(prot_dat)] / 1e6
write_csv(prot_dat, "data/class3/dmel_peptides_lifecycle.csv.gz")

# ---------
# fly gene id to gene symbol
# ---------
library(biomaRt)
mart <- useEnsembl(biomart = "ensembl", dataset = "dmelanogaster_gene_ensembl")
gid_2_info <- getBM(c("external_gene_name",
        "description",
        "chromosome_name",
        "flybase_transcript_id"),
      mart = mart)
gid_2_info <- gid_2_info[gid_2_info$flybase_transcript_id  != " ",]
write_csv(gid_2_info, "data/class3/dmel_tx_info.csv.gz")



