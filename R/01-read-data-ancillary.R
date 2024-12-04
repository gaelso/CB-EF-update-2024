

rs_envir_stress <- terra::rast(file.path(path_src, "E.nc"))

# sf_admin <- st_read(file.path(path_src, "gadm41_KHM_0.json"), quiet = T)
# sf_prov  <- st_read(file.path(path_src, "gadm41_KHM_1.json"), quiet = T)
# sf_dist  <- st_read(file.path(path_src, "gadm41_KHM_2.json"), quiet = T)
# sf_comm  <- st_read(file.path(path_src, "gadm41_KHM_3.json"), quiet = T)

species_list <- read_csv(file.path(path_conf, "ancillary/species-list.csv"), show_col_types = F) |>
  select(
    species_code = "CODE...1",
    species_no = "No.",
    species_life_form = "Life_Form",
    species_scientific_name = "Scientific Name",
    species_vernacular_name = "K_Name",
    species_vernacular_name2 = "Other_K_Name"
    ) |>
  mutate(
    species_vernacular_name = if_else(
      is.na(species_vernacular_name2),
      species_vernacular_name,
      paste(species_vernacular_name, species_vernacular_name2, sep = ", ")
    )
  ) |>
  select(-species_vernacular_name2)
species_list

admin_unit <- read_csv(file.path(path_conf, "ancillary/code_list_admin_unit.csv"), show_col_types = F) |>
  filter(!is.na(commune_code)) |>
  purrr::discard(~all(is.na(.)))
admin_unit

names(admin_unit) <- str_replace(names(admin_unit), "label_en", "name")
admin_unit

## WOOD DENSITY DATABASE
wood_densities <- read_csv(file.path(path_src, "wdData.csv"))

