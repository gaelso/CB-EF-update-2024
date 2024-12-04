
## Prepare short tables for joins
tmp_cluster_stratum <- cluster |> select(cluster_cluster_no, cluster_stratum)


## Check errors in dist-az
check_dist <- tree |>
  filter(tree_distance > 21.85) |>
  arrange(desc(tree_distance))

check_az <- tree |>
  filter(tree_azimuth > 360) |>
  arrange(desc(tree_azimuth))

## Check error in trees outside nested level
tmp_tree <- tree |>
  left_join(tmp_cluster_stratum, by = join_by(tree_cluster_no == cluster_cluster_no)) |>
  mutate(
    tree_plot_radius = case_when(
      cluster_stratum == "Upland" & tree_dbh < 15 ~ 5.64,
      cluster_stratum == "Upland" & tree_dbh < 30 ~ 11.97,
      cluster_stratum == "Upland" & tree_dbh >= 15 ~ 21.85,
      TRUE ~ NA_real_
    ),
    wrong_distance = if_else(tree_distance > tree_plot_radius, TRUE, FALSE)
  )

table(tmp_tree$wrong_distance)

check_dist2 <- tmp_tree |>
  filter(wrong_distance)


## Check H-D
ggplot(tree, aes(x = tree_dbh, y = tree_bole_height)) +
  geom_point(alpha = 0.1)

 check_dbh <- tree |>
   filter(tree_dbh > 200) |>
   arrange(desc(tree_dbh))
 
 check_h <- tree |>
   filter(tree_bole_height > 40) |>
   arrange(desc(tree_bole_height))
 
 check_hd <- tree |>
   filter(tree_dbh > 200 & tree_bole_height < 20)
 
 ## Check if species code are Ok or not
 check_sp <- tree |> filter(is.na(tree_species_code))
 nrow(check_sp)
 nrow(tree) - nrow(check_sp)
 table(check_sp$tree_filename, useNA = "ifany")
 
 tree_corr <- tree |>
   ## rm outliers
   filter(tree_azimuth <= 360, tree_distance <= 21.85, tree_bole_height <= 50, tree_dbh <= 200) |>
   ## cor species names
   left_join(species_list, by = join_by(tree_species_code == species_code)) |>
   mutate(
     tree_species_scientific_name_corr = case_when(
       !is.na(species_scientific_name) ~ species_scientific_name,
       !is.na(tree_species_scientific_name) ~ tree_species_scientific_name,
       TRUE ~ NA_character_
     ),
     tree_species_genus_corr = word(tree_species_scientific_name_corr)
   ) |>
   ## rm trees measured outside their nested level. 
   left_join(cluster_stratum, by = join_by(tree_cluster_no == cluster_cluster_no)) |>
   mutate(
     tree_plot_radius = case_when(
       cluster_stratum == "Upland" & tree_dbh < 15 ~ 5.64,
       cluster_stratum == "Upland" & tree_dbh < 30 ~ 11.97,
       cluster_stratum == "Upland" & tree_dbh >= 15 ~ 21.85,
       TRUE ~ NA_real_
     ),
     wrong_distance = if_else(tree_distance > tree_plot_radius, TRUE, FALSE)
   ) |>
   filter(!wrong_distance)

 length(unique(tree_corr$tree_species_genus_corr))
 length(unique(tree_corr$tree_species_scientific_name_corr))
 
 tt <- tree_corr |>
   filter(is.na(tree_species_scientific_name_corr))
 nrow(tt)
 
 nrow(tree_corr) - nrow(tt)

 ## Re-check H-D
 ggplot(tree_corr, aes(x = tree_dbh, y = tree_bole_height)) +
   geom_point(alpha = 0.1) +
   facet_wrap(~tree_filename) +
   theme_bw()
 
 