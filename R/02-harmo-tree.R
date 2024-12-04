

## List of names that need to be harmonized
setdiff(names(tree_init_rua), names(tree_init_moef))


## add data
tmp_tree <- bind_rows(tree_init_rua, tree_init_moef) |>
  select(-starts_with("tree_TOREMOVE")) |>
  mutate(
    across(c(
      tree_distance, tree_azimuth, tree_dbh, tree_pom, tree_bole_height, tree_top_height
      ), as.numeric)
    )

summary(tmp_tree)


## Anticipate more formatting issues
cluster_org <- cluster |> select(cluster_cluster_no, cluster_filename)

tree <- tmp_tree |>
  mutate(
    tree_unique_id = if_else(
      as.numeric(tree_tree_no) < 10, 
      paste0(tree_cluster_no, "-", tree_plot_no, "-0", tree_tree_no),
      paste0(tree_cluster_no, "-", tree_plot_no, "-", tree_tree_no),
    )
  ) |>
  filter(!is.na(tree_dbh)) |>
  left_join(cluster_org, by = join_by(tree_cluster_no == cluster_cluster_no)) |>
  distinct(tree_cluster_no, tree_plot_no, tree_tree_no, .keep_all = T)

## Check
nrow(tree) == length(unique(tree$tree_unique_id))


check_id <- tree |> 
  summarise(count = n()) |>
  filter(count > 1)

tt <- tree |> filter(tree_unique_id == "105829-1-13") 

tt2 <- tree |> filter(tree_cluster_no == "95257", tree_plot_no == "3")
