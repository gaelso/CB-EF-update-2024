


## Steps:
## 1. rename columns 
## 2. Correct data type
## 3. Correct typos
## 4. Add calculated variables (total collection time)

## TO DO:
## 1. Add OF Arena style guide
## 3. Correct admin names with code lists.


## 
## Rename columns ####
##

names(cluster_init)

cluster_tmp1 <- cluster_init |>
  select(
    no            = "1. Cluster number",
    stratum       = "2. Stratum",
    soil_sampling = "3. Soil & Litter sampling cluster",
    admin_province_code = "A. Admin. Area_4. Province code",
    admin_province_name = "4. Province name",
    admin_district_code = "5. District code",
    admin_district_name = "5. District name",
    admin_commune_code  = "6. Commune code",
    admin_commune_name  = "6. Commune name",
    admin_village_code  = "7. Village code",
    admin_village_name  = "7. Village name",
    organization_organization       = "B. Orgnization and Crew list_8. Organization",
    organization_team_leader        = "9. Name TL",
    organization_team_leader_phone  = "9. Phone TL",
    organization_TL_assistant       =  "9. Name Assistant TL",
    organization_TL_assistant_phone =  "9. Phone Assistant TL",
    equipment_GPS_model = "C. Equipment Used_10. GPS (Brand name, type)",
    equipment_GPS_id    = "11. GPS unit ID",
    cluster_access_access_code         = "D. Cluster Access_12. Accessibility code" ,
    cluster_access_access_desc         = "12. Accessibility Description",
    cluster_access_starting_point_utmx =  "Starting position coodinates (leaving vehicle or camp)_13. UTM E (x)",
    cluster_access_starting_point_utmy = "14. UTM N (y)",
    cluster_access_day1_date_dmy       = "Day 1._15. Date [dd/mm/yy]",
    cluster_access_day1_time_start     = "16. Start time",
    cluster_access_day1_time_stop      = "17. Time of return",                                                
    cluster_access_day2_date_dmy       = "Day 2._18. Date [dd/mm/yy]",
    cluster_access_day2_time_start     = "19. Start time",
    cluster_access_day2_time_stop      = "20. Time of return",
    cluster_access_remarks             = "21. Remarks",
    data_control_delivered_by        = "E. Follow up raw data_Raw data delivered by 8name)",
    data_control_delivered_to        = "Raw data delivered to (name)",
    data_control_delivered_date_dmy  = "Raw data delivered on date [dd/mm/yy]",
    data_control_controlled_by       = "F. Follow up raw data_Data controlled by name",
    data_control_controlled_date_dmy = "Data controlled Date" ,
    data_control_entered_by          = "Data entered by name",
    data_control_entered_date_dmy    = "Data entered Date",
    data_control_validated_by        = "Data validated by name",
    data_control_validated_date_dmy = "Data validated Date"                                                 
  ) |>
  rename_with(.fn = ~ paste0("cluster_", .x)) 



## 
## Correct data type ####
##

## EXCEL STORE TIME AS DECIMAL WHEN LOADED AS TEXT.
conv_time <- function(x){
  t = as.numeric(x) * 24
  h = round(t)
  m = round((t - h) * 60)
  lubridate::hm(paste0(h, ":", m))
}

## Checks
summary(cluster_tmp1)

## Correct
cluster_tmp2 <- cluster_tmp1 |>
  mutate(
    ## Numeric
    across(c(
      cluster_admin_province_code, cluster_admin_district_code, cluster_admin_commune_code, 
      cluster_admin_village_code, cluster_cluster_access_starting_point_utmx, cluster_cluster_access_starting_point_utmy
    ), as.numeric),
    ## Dates
    across(c(
      cluster_cluster_access_day1_date_dmy, cluster_cluster_access_day2_date_dmy, 
      cluster_data_control_delivered_date_dmy, cluster_data_control_controlled_date_dmy, 
      cluster_data_control_entered_date_dmy, cluster_data_control_validated_date_dmy
    ), lubridate::dmy),
    ## Time
    across(c(
      cluster_cluster_access_day1_time_start, cluster_cluster_access_day1_time_stop,
      cluster_cluster_access_day2_time_start, cluster_cluster_access_day2_time_stop
    ), conv_time)
  )

## Check
summary(cluster_tmp2)



##
## Correct typos ####
##

## !!! ADMIN NAMES NOT MATCHING CODES !!!

## Checks
table(cluster_tmp$cluster_admin_province_name)
table(cluster_tmp$cluster_admin_district_name)
table(cluster_tmp$cluster_admin_commune_name)

table(cluster_tmp$cluster_organization_team_leader)

cluster_tmp |> select(cluster_admin_district_code, cluster_admin_district_name) |>
  arrange(cluster_admin_district_code) |>
  distinct()

## Correct
cluster_tmp3 <- cluster_tmp2 |>
  mutate(
    across(c(
      cluster_organization_team_leader, cluster_organization_TL_assistant
    ), str_to_title)
  )

## Checks
table(cluster_tmp3$cluster_organization_team_leader)


## Assign table to cluster and remove tmp objects
cluster <- cluster_tmp3

rm(cluster_tmp1, cluster_tmp2, cluster_tmp3)

# 
# ######
# ######
# names(tree_init)
# ggplot(tree_init) +
#   geom_point(aes(x = as.numeric(`7. Distance [m]`), y = as.numeric(`9. DBH [cm]`))) + ylim(0,50)
# 
# tt <- tree_init |>
#   mutate(
#     tree_dbh = as.numeric((`9. DBH [cm]`)),
#     tree_distance = as.numeric(`7. Distance [m]`),
#     tree_azimuth = as.numeric(`8. Bearing [deg]`),
#     tree_class = case_when(
#       is.na(tree_dbh) ~ "0.missing", 
#       tree_dbh <= 5 ~ "0.sap",
#       tree_dbh <= 15 ~ "1.small",
#       tree_dbh <= 30 ~ "2.medium",
#       TRUE ~ "3.big"
#       )
#     )
# 
# table(tt$tree_class)
# 
# 
# ggplot(tt) +
#   geom_point(aes(x = tree_distance, y = tree_azimuth, col= tree_class))
# 
# tt2 <- tt |> slice_head(n = 2)
# 
# ggplot(tt2, aes(x = tree_distance, y = tree_bearing)) +
#   geom_point(aes(col= tree_class)) +
#   ggrepel::geom_label_repel(aes(label = `4. Tree No.`)) +
#   coord_polar(theta = "y", )
# 
# ggplot(tt, aes(x = tree_distance, y = tree_azimuth)) +
#   geom_text(aes(label = tree_azimuth, color = tree_class)) +
#   scale_x_continuous(breaks = c(0, 6, 12, 24), limits = c(0, 25)) +
#   scale_y_continuous(breaks = c(0, 90, 180, 270), labels = c("N", "E", "S", "W"), limits = c(0, 360)) +
#   coord_polar(theta = "y")
# 
# max(tt$tree_distance, na.rm = T)
# 

