

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
## Functions ######
##

## EXCEL STORE TIME AS DECIMAL WHEN LOADED AS TEXT.
conv_time <- function(x){
  t = as.numeric(x) * 24
  h = round(t)
  m = round((t - h) * 60)
  lubridate::hm(paste0(h, ":", m))
}

## function to remove number first column and trailing empty columns from XLSX files if any
rm_col <- function(tt){
  if (!str_detect(str_to_lower(names(tt)[1]), "cluster|cluter")) { tt <- tt[-1] }
  if (str_detect(names(tt)[ncol(tt)], "\\.\\.\\.")) { tt <- tt[-ncol(tt)] }
  tt
}



##
## Download data from Internet ######
##


## Chave et al. 2014 E
path_check <- "data-source/E.nc"
if (!(path_check %in% list.files(path_src, full.names = T))) {
  
  utils::download.file(
    url      = "https://github.com/umr-amap/BIOMASS/blob/master/data-raw/climate_variable/E.zip", ## NOT WORKING ANYMORE: "http://chave.ups-tlse.fr/pantropical_allometry/E.nc.zip", 
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


## GWD 
path_check <- "data-source/wdData.csv"
if (!(path_check %in% list.files(path_src, full.names = T))) {
  utils::download.file(
    url      = "https://raw.githubusercontent.com/umr-amap/BIOMASS/refs/heads/master/data-raw/wdData.csv", 
    destfile = path_check
  )  
}

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

path_check <- "data-source/gadm41_KHM_2.json"
if (!(path_check %in% list.files(path_src, full.names = T))) {
  utils::download.file(
    url      = "https://geodata.ucdavis.edu/gadm/gadm4.1/json/gadm41_KHM_2.json", 
    destfile = path_check
  )  
}

path_check <- "data-source/gadm41_KHM_3.json"
if (!(path_check %in% list.files(path_src, full.names = T))) {
  utils::download.file(
    url      = "https://geodata.ucdavis.edu/gadm/gadm4.1/json/gadm41_KHM_3.json", 
    destfile = path_check
  )  
}

rm(path_check)