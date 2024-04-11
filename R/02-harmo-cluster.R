
if (!("path_src" %in% ls())) source("R/00-setup.R", local = TRUE)
if (!("cluster_init_rua" %in% ls())) source("R/01-read-data-RUA.R", local = TRUE)
if (!("cluster_init_moef" %in% ls())) source("R/01-read-data-MOEF.R", local = TRUE)
if (!("species_list" %in% ls())) source("R/01-read-data-ancillary.R", local = TRUE)

## Steps:
## 1. merge data
## 2. Correct data type
## 3. Correct typos
## 4. Add calculated variables (total collection time)

## TO DO:
## 1. Add OF Arena style guide
## 3. Correct admin names with code lists.



## 
## Merge data ######
##

cluster_init <- bind_rows(cluster_init_rua, cluster_init_moef)

names(cluster_init)



## 
## Correct data type ######
##

## EXCEL STORE TIME AS DECIMAL WHEN LOADED AS TEXT.
conv_time <- function(x){
  t = as.numeric(x) * 24
  h = round(t)
  m = round((t - h) * 60)
  lubridate::hm(paste0(h, ":", m))
}

as.Date("44906", origin = "1899-12-30")
lubridate::as_date(44906, origin = "1899-12-30") ## Convert integers from Excel to date.
lubridate::as_date(as.integer("44906"), origin = "1899-12-30")

if_else(is.na(as.integer("44906")), lubridate::dmy("44906"), lubridate::as_date(as.integer("44906"), origin = "1899-12-30"))

## Correct
cluster_tmp1 <- cluster_init |>
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
    ), ~ if_else(is.na(as.integer(.)), lubridate::dmy(.), lubridate::as_date(as.integer(.), origin = "1899-12-30"))),
    ## Time
    across(c(
      cluster_cluster_access_day1_time_start, cluster_cluster_access_day1_time_stop,
      cluster_cluster_access_day2_time_start, cluster_cluster_access_day2_time_stop
    ), conv_time)
  )

## Check
summary(cluster_tmp1)



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

