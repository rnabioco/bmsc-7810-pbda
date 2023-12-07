library(here)
data_dir <- here("class_8-10_data")
dir.create(data_dir, showWarnings = FALSE)

files_to_dl <- list(
  "boy_name_counts.csv" = "https://raw.githubusercontent.com/kwells4/pdba_files/main/files/boy_name_counts.csv",
  "girl_name_counts.csv" = "https://raw.githubusercontent.com/kwells4/pdba_files/main/files/girl_name_counts.csv",
  "state_info.csv" = "https://raw.githubusercontent.com/kwells4/pdba_files/main/files/state_information.csv"
)

missing_files <- files_to_dl[!file.exists(file.path(data_dir, names(files_to_dl)))]

tout_setting <- getOption("timeout")
options(timeout = 6000)

for(id in names(missing_files)){
  download.file(missing_files[[id]], file.path(data_dir, id))
}
