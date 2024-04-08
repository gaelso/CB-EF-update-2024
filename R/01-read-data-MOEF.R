

## Source preliminary scripts if needed
if (!("path_src" %in% ls())) source("R/00-setup.R", local = TRUE)


## GS: RUA and MOEF Data treated separately as template differ.

## For MOEF, trailing empty columns or first col with a row number 'No' not consistent.
## Created a function to harmonize columns before batch loading and grouping data.
## Column names also no consistent for MOEF data,so names handled during loading


path_moef <- list.files(file.path(path_conf, "data-MOEF"), full.names = T)  |>
  str_subset("\\~\\$", negate = TRUE)

## function to remove number first column and trailing empty columns from XLSX files if any
rm_col <- function(tt){
  if (!str_detect(str_to_lower(names(tt)[1]), "cluster|cluter")) { tt <- tt[-1] }
  if (str_detect(names(tt)[ncol(tt)], "\\.\\.\\.")) { tt <- tt[-ncol(tt)] }
  tt
}

## For testing only
# x = path_moef[1] 
# readxl::excel_sheets(x)



##
## Load cluster data ######
##

cluster_init_moef <- map(path_moef, function(x){
  tt <- readxl::read_xlsx(x, sheet = "F1 ", col_types = "text") |> rm_col()
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
    "TOREMOVE_cluster_organization_role",  ## Not in RUA template
    "cluster_equipment_GPS_model",
    "cluster_equipment_GPS_id",
    "cluster_cluster_access_access_code",
    "cluster_cluster_access_starting_point_utmx",
    "cluster_cluster_access_starting_point_utmy",
    "cluster_cluster_access_day1_date_dmy",
    "cluster_cluster_access_day1_time_start",    
    "cluster_cluster_access_day1_time_stop"
  )
  tt |> select(-starts_with("TOREMOVE"))
}) |> list_rbind()
cluster_init_moef




##
## Load plot data ######
##

plot_init_moef <- map(path_moef, function(x){
  tt <- readxl::read_xlsx(x, sheet = "F2 ", col_types = "text") |> rm_col()
  #print(names(tt))
  
  ## Some templates have species scientific name for Reference Objects
  if (length(str_subset(names(tt), "Scientific")) == 0) {
    names(tt) <- c(
      "plot_cluster_no",
      "plot_plot_no",
      "plot_time_day1_date_dmy",
      "plot_time_day1_start_time",
      "plot_time_day1_end_time",
      "plot_GPS_utmx",
      "plot_GPS_utmy",
      "plot_GPS_at_startpoint",
      "plot_GPS_to_startpoint_distance",
      "plot_GPS_to_startpoint_azimuth",
      "plot_accessibility_code",
      "plot_plot_slope",
      "plot_plot_slope_azimuth",
      "TOREMOVE_plot_photo_no",
      "TOREMOVE_type_of_object",
      "plot_photo_upwards",
      "plot_photo_N",
      "plot_photo_E",
      "plot_photo_S",
      "plot_photo_W",
      "plot_remarks",
      "plot_RO1_type",
      "plot_RO1_distance",
      "plot_RO1_azimuth",
      "plot_RO1_dbh",
      "plot_RO1_remarks",
      "plot_RO2_type",
      "plot_RO2_distance",
      "plot_RO2_azimuth",
      "plot_RO2_dbh",
      "plot_RO2_remarks",
      "plot_RO3_type",
      "plot_RO3_distance",
      "plot_RO3_azimuth",
      "plot_RO3_dbh"
    )
    # tt <- tt |> mutate(
    #   "plot_R01_speciesname" = NA_character_, 
    #   "plot_R02_speciesname" = NA_character_, 
    #   "plot_R03_speciesname" = NA_character_ 
    # )
  } else if (length(str_subset(names(tt), "Scientific")) == 3) {
    names(tt) <- c(
      "plot_cluster_no",
      "plot_plot_no",
      "plot_time_day1_date_dmy",
      "plot_time_day1_start_time",
      "plot_time_day1_end_time",
      "plot_GPS_utmx",
      "plot_GPS_utmy",
      "plot_GPS_at_startpoint",
      "plot_GPS_to_startpoint_distance",
      "plot_GPS_to_startpoint_azimuth",
      "plot_accessibility_code",
      "plot_plot_slope",
      "plot_plot_slope_azimuth",
      "TOREMOVE_plot_photo_no",
      "plot_photo_upwards",
      "plot_photo_N",
      "plot_photo_E",
      "plot_photo_S",
      "plot_photo_W",
      "plot_remarks",
      "plot_RO1_type",
      "plot_R01_speciesname",
      "plot_RO1_distance",
      "plot_RO1_azimuth",
      "plot_RO1_dbh",
      "plot_RO1_remarks",
      "plot_RO2_type",
      "plot_R02_speciesname",
      "plot_RO2_distance",
      "plot_RO2_azimuth",
      "plot_RO2_dbh",
      "plot_RO2_remarks",
      "plot_RO3_type",
      "plot_R03_speciesname",
      "plot_RO3_distance",
      "plot_RO3_azimuth",
      "plot_RO3_dbh"
    )
  }
  tt
}) |> 
  list_rbind() |>
  select(
    plot_cluster_no:plot_remarks,
    plot_RO1_type,
    plot_R01_speciesname,
    plot_RO1_distance,
    plot_RO1_azimuth,
    plot_RO1_dbh,
    plot_RO1_remarks,
    plot_RO2_type,
    plot_R02_speciesname,
    plot_RO2_distance,
    plot_RO2_azimuth,
    plot_RO2_dbh,
    plot_RO2_remarks,
    plot_RO3_type,
    plot_R03_speciesname,
    plot_RO3_distance,
    plot_RO3_azimuth,
    plot_RO3_dbh
  )



##
## Load LUVS data ######
##

luvs_init_moef <- map(path_moef, function(x){
  
  tt <- readxl::read_xlsx(x, sheet = "F3", col_types = "text") |>
    rm_col() |>
    mutate(lc_code = NA_character_) |>
    select(
      cluster_no = "1. Cluter Number",                                 
      plot_no =  "2. Plot Number",                                   
      luvs_no = "3. Section",
      plot_share = "4. Share o Full polt Area (%)",                  
      lc_code,
      lc_description = "5. Land Cover Class"
    ) |>
    rename_with(.fn = ~ paste0("luvs_", .x)) |>
    tidyr::fill(luvs_cluster_no, luvs_plot_no)
  
  
  tt
}) |>
  list_rbind()
  



tree_init_moef    <- map(path_moef, readxl::read_xlsx, sheet = "F5 ", col_types = "text") |> list_rbind()




rs_envir_stress <- terra::rast(file.path(path_src, "E.nc"))

sf_cb <- st_read(file.path(path_src, "gadm41_KHM_0.json"))


