data_dir <- "data"
dir.create(data_dir, showWarnings = FALSE)

files_to_dl <- list(
  "brauer_gene_exp.csv.gz" = "https://github.com/rnabioco/bmsc-7810-pbda/raw/main/data/class11/brauer_gene_exp.csv.gz",
  "yeast_prot_prop.csv.gz" = "https://github.com/rnabioco/bmsc-7810-pbda/raw/main/data/class11/yeast_prot_prop.csv.gz"
)

missing_files <- files_to_dl[!file.exists(file.path(data_dir, names(files_to_dl)))]

tout_setting <- getOption("timeout")
options(timeout = 6000)

for(id in names(missing_files)){
  download.file(missing_files[[id]], file.path(data_dir, id))
}

options(timeout = tout_setting)
