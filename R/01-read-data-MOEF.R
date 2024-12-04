

## GS: RUA and MOEF Data treated separately as template differ.

## For MOEF, trailing empty columns or first col with a row number 'No' not consistent.
## Created a function to harmonize columns before batch loading and grouping data.
## Column names also no consistent for MOEF data,so names handled during loading


path_moef <- list.files(file.path(path_conf, "data-MOEF"), full.names = T)  |>
  str_subset("\\~\\$", negate = TRUE)



## For testing only
# x = path_moef[1] 
# readxl::excel_sheets(x)



##
## Load cluster data ######
##

cluster_init_moef <- map(path_moef, function(x){
  
  file_name <- str_remove(x, pattern = ".*/")
  tt <- readxl::read_xlsx(x, sheet = "F1 ", col_types = "text", na = "NA") |> rm_col()
  names(tt) <- c(
    "cluster_cluster_no",
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
    "cluster_access_access_code",
    "cluster_access_starting_point_utmx",
    "cluster_access_starting_point_utmy",
    "cluster_access_day1_date_dmy",
    "cluster_access_day1_time_start",    
    "cluster_access_day1_time_stop"
  )
  tt |> 
    select(-starts_with("TOREMOVE")) |>
    mutate(
      cluster_filename = file_name,
      cluster_org = "MOEF"
      )
  
}) |> 
  list_rbind() |>
  select(cluster_org, cluster_filename, everything())



##
## Load plot data ######
##

plot_init_moef <- map(path_moef, function(x){
  
  ## FOR TESTING ONLY
  x = path_moef[2]
  
  file_name <- str_remove(x, pattern = ".*/")
  
  tt <- readxl::read_xlsx(x, sheet = "F2 ", col_types = "text") |> rm_col()
  
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
      "plot_access_code",
      "plot_slope",
      "plot_slope_azimuth",
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
      "plot_access_code",
      "plot_plot_slope",
      "plot_plot_slope_azimuth",
      "TOREMOVE_plot_photo_no",
      "plot_photo_upwards",
      "plot_photo_N",
      "plot_photo_E",
      "plot_photo_S",
      "plot_photo_W",
      "plot_remarks",
      "TOREMOVE_plot_RO_type",
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
  
  tt |>
    mutate(
      plot_org = "MOEF",
      plot_filename = file_name
      )
  
}) |> 
  list_rbind() |>
  select(
    plot_org,
    plot_filename,
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
  ) |> 
  select(-starts_with("TOREMOVE"))


##
## Load LUVS data ######
##

luvs_init_moef <- map(path_moef, function(x){
  
  file_name <- str_remove(x, pattern = ".*/")
  
  readxl::read_xlsx(x, sheet = "F3", col_types = "text") |>
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
    tidyr::fill(luvs_cluster_no, luvs_plot_no) |>
    mutate(
      luvs_org = "MOEF",
      luvs_filename = file_name
    )
  
}) |>
  list_rbind() |>
  select(luvs_org, luvs_filename, everything())
luvs_init_moef

##
## Load tree data ######
##

tree_init_moef <- map(path_moef, function(x){
  
  file_name <- str_remove(x, pattern = ".*/")
  
  tt <- readxl::read_xlsx(x, sheet = "F5 ", col_types = "text") |> rm_col()
  
  names(tt) <- c(
    "tree_cluster_no",
    "tree_plot_no",
    "tree_luvs_no",
    "tree_tree_no",
    "tree_species_scientific_name",
    "tree_species_code",
    "tree_species_vernacular_name",
    "tree_distance",
    "tree_azimuth",
    "tree_dbh",
    "tree_pom",
    "tree_bole_height",
    "tree_health_code",
    "tree_quality_code",
    "tree_origin_code",
    "tree_top_height",
    "tree_stump_diam",
    "tree_stump_height"     
  )
  
  tt |>
    tidyr::fill(tree_cluster_no, tree_plot_no, tree_luvs_no) |>
    mutate(
      tree_org = "MOEF",
      tree_filename = file_name
    )
  
}) |> 
  list_rbind() |>
  select(tree_org, tree_filename, everything())
  
tree_init_moef

## Check
test <- tree_init_moef |>
  group_by(tree_cluster_no, tree_plot_no, tree_tree_no) |>
  summarise(count = n(), .groups = "drop")

table(test$count)

tt <- test |> 
  filter(count > 1 ) |> 
  select(tree_cluster_no, tree_plot_no, tree_tree_no) |>
  arrange(tree_cluster_no)

test2 <- tree_init_moef |>
  filter(tree_cluster_no == "105829", tree_plot_no == "1", tree_tree_no == "13")

test3 <- tree_init_moef |>
  filter(tree_cluster_no == "88249", tree_plot_no == "3")
