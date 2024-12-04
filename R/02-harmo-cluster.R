
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


## Correct
cluster_tmp <- cluster_init |>
  mutate(
    ## Numeric
    # across(c( 
    #   cluster_admin_province_code, cluster_admin_district_code, cluster_admin_commune_code, 
    #   cluster_admin_village_code, cluster_access_starting_point_utmx, cluster_access_starting_point_utmy
    # ), as.numeric),
    ## admin codes should remain as text
    across(c(
      cluster_access_starting_point_utmx, cluster_access_starting_point_utmy
    ), as.numeric),
    ## Dates
    across(c(
      cluster_access_day1_date_dmy, cluster_access_day2_date_dmy
    ), ~if_else(is.na(as.integer(.)), lubridate::dmy(.), lubridate::as_date(as.integer(.), origin = "1899-12-30"))),
    ## Time
    across(c(
      cluster_access_day1_time_start, cluster_access_day1_time_stop,
      cluster_access_day2_time_start, cluster_access_day2_time_stop
    ), conv_time),
    ## Character
    across(where(is.character), ~if_else(. == "NA", NA_character_, .))
  ) |>
  mutate(
    across(c(
      cluster_organization_team_leader, cluster_organization_TL_assistant
    ), str_to_title)
  ) |>
  arrange(cluster_filename, cluster_cluster_no)



##
## Important Checks
##

## Important info from cluster is admin location, stratum and access
summary(cluster_tmp)

cluster_tmp |> filter(is.na(cluster_admin_province_name)) |> select(cluster_filename, cluster_cluster_no)
cluster_tmp |> filter(is.na(cluster_admin_district_name)) |> select(cluster_filename, cluster_cluster_no)
cluster_tmp |> filter(is.na(cluster_admin_commune_name)) |> select(cluster_filename, cluster_cluster_no)
cluster_tmp |> filter(is.na(cluster_admin_village_name)) |> select(cluster_filename, cluster_cluster_no)
unique(cluster_tmp$cluster_admin_province_name)

cluster_tmp |> filter(is.na(cluster_stratum)) |> select(cluster_filename, cluster_cluster_no)
unique(cluster_tmp$cluster_stratum)

cluster_tmp |> filter(is.na(cluster_access_access_code)) |> select(cluster_filename, cluster_cluster_no)
table(cluster_tmp$cluster_access_access_code, useNA = "ifany")
table(cluster_tmp$cluster_access_access_desc, useNA = "ifany")


## GS: Missing admin codes, names not harmonized, can be solved manually with admin table from OF Collect.



##
## Correct admin ####
##

## !!! 
## This code may not work if admin codes are entered as number and province_code is less than 10
## In this case need to check the admin code for NFI data.
## !!!

cluster_tmp1 <- cluster_tmp |> 
  filter(!is.na(cluster_admin_commune_code)) |>
  rename(commune_code = cluster_admin_commune_code) |>
  select(-starts_with("cluster_admin")) |>
  left_join(admin_unit, by = join_by(commune_code))

cluster_tmp2 <- cluster_tmp |>
  filter(is.na(cluster_admin_commune_code), !is.na(cluster_admin_district_code))

if (nrow(cluster_tmp2 > 0)) {
  
  admin_dist <- admin_unit |>
    select(-starts_with("commune")) |>
    distinct()
  
  cluster_tmp2 <- cluster_tmp2 |>
    rename(district_code = cluster_admin_district_code) |>
    select(-starts_with("cluster_admin_province"), -starts_with("cluster_admin_district")) |>
    left_join(admin_dist, by = join_by(district_code))
  
  
  ## test duplicate district
  admin_dist |> summarize(count = n(), .by = district_name) |> filter(count > 1)
  
}

cluster_tmp3 <- cluster_tmp |>
  filter(is.na(cluster_admin_commune_code), is.na(cluster_admin_district_code)) |>
  mutate(commune_code = case_when(
    cluster_admin_district_name %in% c("Kao Nheak", "Kaoh Nheak") & cluster_admin_commune_name %in% c("Royor", "Roya", "Rovek") ~ "110203",
    cluster_admin_district_name == "Koh Nhek" & cluster_admin_commune_name == "A Buon Leu"    ~ "110202",
    cluster_admin_district_name == "Koh Nhek" & cluster_admin_commune_name == "Norng Khi Lek" ~ "110201",
    cluster_admin_district_name == "Koh Nhek" & cluster_admin_commune_name == "R 4 Leu"       ~ "110202",
    cluster_admin_district_name == "Koh Nhek" & cluster_admin_commune_name == "Sokh Sant"     ~ "110204",
    cluster_admin_district_name == "Koh Nhek" & cluster_admin_commune_name == "Sre Huy"       ~ "110205",
    
    cluster_admin_district_name == "Koun Mom" & cluster_admin_commune_name == "Serey Mungkul" ~ "160401",
    cluster_admin_district_name == "Koun Mom" & cluster_admin_commune_name == "Srae Angrorng" ~ "160402",
    cluster_admin_district_name == "Koun Mom" & cluster_admin_commune_name == "Sre Angrorng"  ~ "160402",
    
    cluster_admin_district_name == "Lomphat" & cluster_admin_commune_name == "Chey Oudom"    ~ "160501",
    cluster_admin_district_name == "Lomphat" & cluster_admin_commune_name == "Serey Mungkul" ~ "160401",
    
    cluster_admin_district_name == "Pech Chreada" & cluster_admin_commune_name == "Krong Tes" ~ "110401",
    cluster_admin_district_name == "Pech Chreada" & cluster_admin_commune_name == "Pu Chrey"  ~ "110402",
  
    TRUE ~ NA_character_
  )) 


cluster_tmp3a <- cluster_tmp3 |>
  filter(!is.na(commune_code)) |>
  select(-starts_with("cluster_admin")) |>
  left_join(admin_unit, by = join_by(commune_code))

cluster_tmp3b <- cluster_tmp3 |>
  filter(is.na(commune_code))

cluster_tmp3b |> 
  select(cluster_cluster_no, starts_with("cluster_admin"),  cluster_access_starting_point_utmx, cluster_access_starting_point_utmy) |>
  write_csv("tmp/check_admin.csv")




## !!! ADMIN NAMES NOT MATCHING CODES !!!

## Checks
table(cluster_tmp$cluster_admin_province_name, useNA = "ifany")
table(cluster_tmp$cluster_admin_district_name, useNA = "ifany")
table(cluster_tmp$cluster_admin_commune_name, useNA = "ifany")
table(cluster_tmp$cluster_admin_commune_name, useNA = "ifany")
table(cluster_tmp$cluster_admin_commune_code, useNA = "ifany")

cluster_tmp |> select(cluster_admin_district_code, cluster_admin_district_name) |>
  arrange(cluster_admin_district_code) |>
  distinct()


## Assign table to cluster and remove tmp objects
cluster <- cluster_tmp

rm(cluster_tmp1, cluster_tmp2, cluster_tmp3)

## Tests
table(cluster$cluster_admin_province_code, useNA = "ifany")
table(cluster$cluster_admin_province_name, useNA = "ifany")
table(cluster$cluster_admin_province_code, cluster$cluster_admin_province_name, useNA = "ifany")


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

