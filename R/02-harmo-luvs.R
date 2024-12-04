
setdiff(names(luvs_init_rua), names(luvs_init_moef))

tmp_luvs <- bind_rows(luvs_init_rua, luvs_init_moef)

table(tmp_luvs$luvs_luvs_no)
table(tmp_luvs$luvs_lc_description, tmp_luvs$luvs_lc_code, useNA = "ifany")

luvs <- tmp_luvs |>
  mutate(
    luvs_lc_code = as.numeric(luvs_lc_code),
    luvs_lc_code2 = case_when(
      !is.na(luvs_lc_code) ~ luvs_lc_code,
      luvs_lc_description == "B" ~ NA_integer_,
      luvs_lc_description == "BL" ~ 35,
      luvs_lc_description == "D-F" ~ 4,
      luvs_lc_description == "DF" ~ 4,
      luvs_lc_description == "EF" ~ 1,
      luvs_lc_description == "G" ~ 31,
      luvs_lc_description == "Hc" ~ NA_integer_,
      luvs_lc_description == "HC" ~ NA_integer_,
      luvs_lc_description == "Hr" ~ NA_integer_,
      luvs_lc_description == "RF" ~ NA_integer_,
      luvs_lc_description == "Se" ~ 3,
      luvs_lc_description == "SE" ~ 3,
      luvs_lc_description == "W" ~ NA_integer_,
      luvs_lc_description == "Ws" ~ NA_integer_,
      TRUE ~ NA_integer_
    )
  )

table(luvs$luvs_lc_code2, luvs$luvs_lc_code, useNA = "ifany")



