

##
## Load packages, install if necessary ######
##


load_package <- function(.pkg_name) {
  if (!require(.pkg_name, character.only = TRUE)) install.packages(.pkg_name, dep =TRUE)
  library(.pkg_name, character.only = TRUE, quietly = TRUE)
}

load_package("sf")
load_package("terra")
load_package("readxl")
load_package("tidyverse")


##
## Set paths ######
##

path_res  <- "results"
path_conf <- "data-confidential"
path_src  <- "data-source" 
path_data <- "data"



##
## Load data from Internet ###
##

file_path <- "data-source/E.nc"

if (!(file_path %in% list.files(path_src))) {
  
  utils::download.file(
    url      = "http://chave.ups-tlse.fr/pantropical_allometry/E.nc.zip", 
    destfile = paste0(file_path,".zip")
  )  
  
  utils::unzip(
    zipfile = paste0(file_path,".zip"), 
    exdir = path_src
  )
  
  unlink(paste0(file_path,".zip"))
  
}

## Check
# rs_envir_stress <- terra::rast(file_path)
# plot(rs_envir_stress)