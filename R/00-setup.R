

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
# path_data <- "data"



##
## Load data from Internet ###
##


## Chave et al. 2014 E
path_check <- "data-source/E.nc"
if (!(path_check %in% list.files(path_src, full.names = T))) {
  
  utils::download.file(
    url      = "http://chave.ups-tlse.fr/pantropical_allometry/E.nc.zip", 
    destfile = paste0(path_check,".zip")
  )  
  
  utils::unzip(
    zipfile = paste0(path_check,".zip"), 
    exdir = path_src
  )
  
  unlink(paste0(path_check,".zip"))
  
}

## Check
# rs_envir_stress <- terra::rast(path_check)
# plot(rs_envir_stress)


## Country GADM
path_check <- "data-source/gadm41_KHM_0.json"
if (!(path_check %in% list.files(path_src, full.names = T))) {
  utils::download.file(
    url      = "https://geodata.ucdavis.edu/gadm/gadm4.1/json/gadm41_KHM_0.json", 
    destfile = path_check
  )  
}

path_check <- "data-source/gadm41_KHM_1.json"
if (!(path_check %in% list.files(path_src, full.names = T))) {
  utils::download.file(
    url      = "https://geodata.ucdavis.edu/gadm/gadm4.1/json/gadm41_KHM_1.json", 
    destfile = path_check
  )  
}


rm(path_check)