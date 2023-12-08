library(tidyverse)
library(devtools)
library(here)

url <- "http://varianceexplained.org/files/Brauer2008_DataSet1.tds"

nutrient_names <- c(G = "Glucose", L = "Leucine", P = "Phosphate",
                    S = "Sulfate", N = "Ammonia", U = "Uracil")

brauer_gene_exp <- read_delim(url, delim = "\t") %>%
  separate(NAME, c("name", "BP", "MF", "systematic_name", "number"), sep = "\\|\\|") %>%
  mutate_at(.funs = list(trimws), .vars = vars(name:systematic_name)) %>%
  select(-number, -GID, -YORF, -GWEIGHT) %>%
  gather(sample, expression, G0.05:U0.3) %>%
  separate(sample, c("nutrient", "rate"), sep = 1, convert = TRUE) %>%
  mutate(nutrient = plyr::revalue(nutrient, nutrient_names)) %>%
  filter(!is.na(expression), systematic_name != "")


write_csv(brauer_gene_exp, here("data/class7/brauer_gene_exp.csv.gz"))

url <- 'http://sgd-archive.yeastgenome.org/curation/calculated_protein_info/archive/protein_properties.tab.20210422.gz'
yeast_prot_prop <- read_tsv(url)
write_csv(yeast_prot_prop, here("data/class7/yeast_prot_prop.csv.gz"))
