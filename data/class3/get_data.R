library(here)
library(readr)
library(stringr)
library(data.table)

convert_num_units <- function(x,
                              units = c("k", "m", "b", "t"),
                              multipliers = c(1e3, 1e6, 1e9, 1e12)){
  has_unit <- str_detect(x, str_c(units, collapse = "|"))
  xx <- vector("numeric", length(x))
  xx[!has_unit] <- as.numeric(x[!has_unit])

  num <- as.numeric(str_remove(x[has_unit], str_c(units, collapse = "|")))
  ui <- match(str_match(x[has_unit], str_c(units, collapse = "|")), units)

  xx[has_unit] <- num * multipliers[ui]
  if(any(is.na(xx))) warning("NAs introducted in coercion, check units")
  xx
}

# gapminder data  FREE DATA FROM WORLD BANK VIA GAPMINDER.ORG, CC-BY LICENSE
# income_per_person_messy.csv, downloaded from http://gapm.io/dgdppc
gdp_data <- read_csv(here("data/class3/income_per_person_messy.csv"))
gdp_data <- as.data.frame(gdp_data)
gdp_data[2:ncol(gdp_data)] <- lapply(gdp_data[2:ncol(gdp_data)], convert_num_units)
gdp_data <- as_tibble(gdp_data)
write_csv(gdp_data, "data/class3/income_per_person.csv")


# ----------
# fly proteomics data
# ----------

tf <- tempfile(fileext = ".gz")
on.exit(unlink(tf))
download.file("http://ftp.flybase.org/flybase/associated_files/DeJung.2018.2.9.peptides_lifecycle.txt.gz",
              tf)

# note use of read.table rather than read_tsv,
# as read_tsv doesn't handle a default table produce by write.table ...
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



