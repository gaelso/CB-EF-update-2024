

## Steps:
## 1. rename columns ( handled at data reading step)
## 2. Correct data type
## 3. Correct typos
## 4. Add calculated variables (true coordinates)


## List of names that need to be harmonized
setdiff(names(plot_init_rua), names(plot_init_moef))


## add data
tmp_plot <- bind_rows(plot_init_rua, plot_init_moef)


