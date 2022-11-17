library(here)
data_dir <- here("_posts/2022-11-15-class-3-reshaping-data-into-a-tidy-format/data")
dir.create(data_dir, showWarnings = FALSE)

files_to_dl <- list(
  "income_per_person.csv" = "https://github.com/rnabioco/bmsc-7810-pbda/raw/main/data/class3/income_per_person.csv",
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
