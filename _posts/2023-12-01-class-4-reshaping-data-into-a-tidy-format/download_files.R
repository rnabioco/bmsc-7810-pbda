
data_dir <- "data"
dir.create(data_dir, showWarnings = FALSE)

files_to_dl <- list(
  "income_per_person.csv" = "https://github.com/rnabioco/bmsc-7810-pbda/raw/main/data/class3/income_per_person.csv",
  "country_population.csv" = "https://github.com/rnabioco/bmsc-7810-pbda/raw/main/data/class3/country_population.csv",
  "dmel_tx_info.csv.gz" = "https://github.com/rnabioco/bmsc-7810-pbda/raw/main/data/class3/dmel_tx_info.csv.gz",
  "dmel_peptides_lifecycle.csv.gz" = "https://github.com/rnabioco/bmsc-7810-pbda/raw/main/data/class3/dmel_peptides_lifecycle.csv.gz"
)

missing_files <- files_to_dl[!file.exists(file.path(data_dir, names(files_to_dl)))]

tout_setting <- getOption("timeout")
options(timeout = 6000)

for(id in names(missing_files)){
  download.file(missing_files[[id]], file.path(data_dir, id))
}

options(timeout = tout_setting)
