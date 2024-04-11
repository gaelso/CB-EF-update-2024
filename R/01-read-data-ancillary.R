
## Source preliminary scripts if needed
if (!("path_src" %in% ls())) source("R/00-setup.R", local = TRUE)

rs_envir_stress <- terra::rast(file.path(path_src, "E.nc"))

sf_cb <- st_read(file.path(path_src, "gadm41_KHM_0.json"))

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
