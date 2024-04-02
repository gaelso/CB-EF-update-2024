

## Source preliminary scripts if needed
if (!("path_src" %in% ls())) source("R/00-setup.R", local = TRUE)

##
## LOAD NFI DATA ####
##

## GS: RUA and MOEF Data treated separately as template differ.
## For MOEF, trailing empty columns or first col with 'No" not consistent.
## Created a function to harmonized ciolumns before batch loading and grouping data.


## Data RUA
path_rua <- list.files(file.path(path_conf, "data-RUA"), full.names = T)

cluster_init <- readxl::read_xlsx(path_rua, sheet = "F1", col_types = "text")
plot_init    <- readxl::read_xlsx(path_rua, sheet = "F2-UW-C")
luvs_init    <- readxl::read_xlsx(path_rua, sheet = "F3")
tree_init    <- readxl::read_xlsx(path_rua, sheet = "F5_Circular")
} else {
  
}

## Data MOEF 
path_moef <- list.files(file.path(path_conf, "data-MOEF"), full.names = T)


## For testing only
x = path_moef[1] 
readxl::excel_sheets(x)

cluster_init_moef <- map(path_moef, function(x){
  
  tt <- readxl::read_xlsx(x, sheet = "F1 ", col_types = "text")
  
  if (!str_detect(str_to_lower(names(tt)[1]), "cluster")) { tt <- tt[-1] }
  
  names(tt) <- c(
    "cluster_no",
    "cluster_stratum",
    "cluster_soil_sampling",          
    "cluster_admin_province_name",
    "cluster_admin_district_name",
    "cluster_admin_commune_name",
    "cluster_admin_village_name",
    "cluster_organization_organization",      
    "cluster_organization_team_leader",
    "cluster_organization_team_leader_phone",
    "TOREMOVE_cluster_organization_role",
    "cluster_equipment_GPS_model",
    "cluster_equipment_GPS_id",
    "cluster_cluster_access_access_code",
    "cluster_cluster_access_starting_point_utmx",
    "cluster_cluster_access_starting_point_utmy",
    "cluster_cluster_access_day1_date_dmy",
    "cluster_cluster_access_day1_time_start",    
    "cluster_cluster_access_day1_time_stop",
    "TOREMOVE"
  )
  tt |> select(-starts_with("TOREMOVE"))
  
}) |> list_rbind()
cluster_init_moef

plot_init_moef    <- map(path_moef, readxl::read_xlsx, sheet = "F2 ", col_types = "text") |> list_rbind()
luvs_init_moef    <- map(path_moef, readxl::read_xlsx, sheet = "F3", col_types = "text") |> list_rbind()
tree_init_moef    <- map(path_moef, readxl::read_xlsx, sheet = "F5 ", col_types = "text") |> list_rbind()

cluster_init_moef <- map(path_moef, function(x){
  
  readxl::read_xlsx(x, sheet = "F1 ", col_types = "text")

}) 


rs_envir_stress <- terra::rast(file.path(path_src, "E.nc"))

sf_cb <- st_read(file.path(path_src, "gadm41_KHM_0.json"))


