## Source preliminary scripts if needed
if (!("path_src" %in% ls())) source("R/00-setup.R", local = TRUE)


## GS: RUA and MOEF Data treated separately as template differ.


path_rua <- list.files(file.path(path_conf, "data-RUA"), full.names = T) |>
  str_subset("\\~\\$", negate = TRUE)



## 
## Load cluster data ######
##

cluster_init_rua <- map(path_rua, readxl::read_xlsx, sheet = "F1", col_types = "text") |> 
  list_rbind() |>
  select(
    cluster_no            = "1. Cluster number",
    cluster_stratum       = "2. Stratum",
    cluster_soil_sampling = "3. Soil & Litter sampling cluster",
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
## Load plot data ######
##

plot_init_rua <- map(path_rua, readxl::read_xlsx, sheet = "F2-UW-C", col_types = "text") |>
  list_rbind() |>
  select(
    cluster_no = "1. Cluster Number",                                          
    plot_no    =  "2. Plot Number",                                          
    time_day1_date_dmy   = "A. Time record_3_Day1 Date [dd/mm/yy]",
    time_day2_date_dmy   = "3_Day2 Date [dd/mm/yy]",
    time_day1_start_time = "4_Day1 Arrival time (to plot)",
    time_day2_start_time = "4_Day2 Arrival time (to plot) day2",
    time_day1_end_time   = "5_Day1 End time (at plot)",
    time_da2_end_time    = "5_Day2 End time (at plot)",
    GPS_utmx                   = "B. GPS Point reading (UTM48-WGS84 coordinates)_6. UTM-E (x)",
    GPS_utmy                   = "7. UTM (y)",
    GPS_at_startpoint          = "8. GPS Point at Plot starting point?",
    GPS_to_startpoint_distance = "9. Distance from GPS Point to Plot starting point [m]",
    GPS_to_startpoint_azimuth  = "10. Bearing from GPS Point to Plot starting point [deg]",
    accessibility_code        =  "C.Plot accessibility, slope and phot_11. Accessibility Code",
    accessibility_description = "11. Accessibility Description",                             
    plot_slope = "12. Slope (at the center of plot) [%]",
    plot_slope_azimuth =  "13. Slope bearing [deg]",
    plot_photo_upwards = "14_Up Photo no./ID",
    plot_photo_N = "14_N Photo no./ID",
    plot_photo_E = "14_E Photo no./ID",
    plot_photo_S = "14_S Photo no./ID",
    plot_photo_W = "14_W Photo no./ID",
    plot_remarks = "15. Remarks",
    plot_RO1_type = "D. Reference object data_16_R1 Reference Type of object",
    plot_RO1_distance = "17_R1 Reference_Distance [m]",
    plot_RO1_azimuth = "18_R1 Reference_Bearing [deg]",
    plot_RO1_dbh = "19_R1 Reference_DBH [cm]",
    plot_RO1_remarks = "20_R1 Reference_Remarks",
    plot_RO2_type = "16_R2 Reference Type of object",
    plot_RO2_distance = "17_R2 Reference_Distance [m]",
    plot_RO2_azimuth = "18_R2 Reference_Bearing [deg]",
    plot_RO2_dbh = "19_R2 Reference_DBH [cm]",
    plot_RO2_remarks = "20_R2 Reference_Remarks",
    plot_RO3_type = "16_R3 Reference Type of object",                            
    plot_RO3_distance = "17_R3 Reference_Distance [m]",
    plot_RO3_azimuth = "18_R3 Reference_Bearing [deg]",
    plot_RO3_dbh = "19_R3 Reference_DBH [cm]",
    plot_RO3_remarks = "20_R3 Reference_Remarks" 
  ) |>
  rename_with(.fn = ~ paste0("plot_", .x))



##
## Load Land use ######
##

luvs_init_rua <- map(path_rua, readxl::read_xlsx, sheet = "F3", col_types = "text") |> 
  list_rbind() |>
  select(
    cluster_no = "1. Cluster Number",
    plot_no    = "2. Plot Number",                                                    
    TOREMOVE_emptycol =  "...3",
    luvsA_no = "A. Land use/Vegetation type section (LUVS)_3_A Section",
    luvsA_plot_share = "4_A Share of full plot area [%]",
    luvsA_lc_code = "5_A land Cover class Code",
    luvsA_lc_description = "5_A land Cover class Code Desription",
    luvsA_planting_year = "6_A Planting year (only if plantation) [yyyy/Unknown/Blank]",
    luvsB_no = "3_B Section", 
    luvsB_plot_share = "4_B Share of full plot area [%]",
    luvsB_lc_code = "5_B land Cover class Code",
    luvsB_lc_description = "5_B land Cover class Decription",                                  
    luvsB_planting_year = "6_B Planting year (only if plantation) [yyyy/Unknown/Blank]",
    luvsC_no = "3_C Section",
    luvsC_plot_share = "4_C Share of full plot area [%]",
    luvsC_lc_code = "5_C land Cover class Code",
    luvsC_lc_description = "5_C land Cover class Description",
    luvsC_planting_year = "6_C Planting year (only if plantation) [yyyy/Unknown/Blank]",           
    undergrowth_code        = "B. Undergrowth, Land tenure and Management status_7. Under-growth Code",
    undergrowth_description = "7. Under-growth Description",                                           
    ownership_code          = "8. Ownership Code",
    ownership_description   = "8. Ownership Description",                                            
    management_status       = "9. Management Status",
    management_plan         = "10. Presence of formal man. Plan",                                        
    disturbance_code = "C. Environment and biodiversity_11. Disturbances Code",
    disturbance_description = "11. Disturbances Description",
    envir_1_problem_code = "12_1 Environmental problem Code",
    envir_1_problem_description = "12_1 Environmental problem Description",
    envir_1_problem_detail = "12_1 Environmental problem To be specified if 99Other",
    envir_1_intensity_code = "13_1 Intensity Code",
    envir_1_intensity_description = "13_1 Intensity Description",
    envir_2_problem_code = "12_2 Environmental problem Code",
    envir_2_problem_description = "12_2 Environmental problem Description",
    envir_2_problem_detail = "12_2 Environmental problem To be specified if 99Other",
    envir_2_intensity_code = "13_2 Intensity Code",
    envir_2_intensity_description = "13_2 Intensity Description",
    envir_3_problem_code = "12_3 Environmental problem Code",
    envir_3_problem_description = "12_3 Environmental problem Description",
    envir_3_problem_detail = "12_3 Environmental problem To be specified if 99Other",
    envir_3_intensity_code = "13_3 Intensity Code",
    envir_3_intensity_description = "13_3 Intensity Description",                                            
    envir_4_problem_code = "12_4 Environmental problem Code",
    envir_4_problem_description = "12_4 Environmental problem Description",
    envir_4_problem_detail = "12_4 Environmental problem To be specified if 99 Other",
    envir_4_intensity_code = "13_4 Intensity Code",
    envir_4_intensity_description = "13_4 Intensity Description",
    biodiv_1_code               = "14_1 Biodiversity Code",
    biodiv_1_description        = "14_1 Biodiversity Description",
    biodiv_1_status_code        = "15_1 Biodstatus Code",
    biodiv_1_status_description = "15_1 Biodstatus Description",
    biodiv_1_remark             = "16_1 Specify biodiversity (notices on biodiversity)",
    biodiv_2_code               = "14_2 Biodiversity",
    biodiv_2_description        = "14_2 Biodiversity Description",
    biodiv_2_status_code        = "15_2 Biodstatus Code",
    biodiv_2_status_description = "15_2 Biodstatus Description",
    biodiv_2_remark             = "16_2 Specify biodiversity (notices on biodiversity)",
    biodiv_3_code               = "14_3 Biodiversity",
    biodiv_3_description        = "14_3 Biodiversity Description",
    biodiv_3_status_code        = "15_3 Biodstatus Code",
    biodiv_3_status_description = "15_3 Biodstatus Description",
    biodiv_3_remark             = "16_3 Specify biodiversity (notices on biodiversity)",
    biodiv_4_code               = "14_4 Biodiversity",
    biodiv_4_description        = "14_4 Biodiversity Description",
    biodiv_4_status_code        = "15_4 Biodstatus Code",
    biodiv_4_status_description = "15_4 Biodstatus Description",
    biodiv_4_remark             = "16_4 Specify biodiversity (notices on biodiversity)",                  
    product_1_code = "D. Forest and tree products/services_17_1 Product/Service Code",
    product_1_description = "17_1 Product/Service Description",
    product_1_ranking_code = "18_1 Ranking Code",                                                     
    product_1_ranking_description = "18_1 Ranking Desription",                                               
    product_1_remark = "19_1 Remarks/Notice on Forest",
    product_2_code = "17_2 Product/Service Code",
    product_2_description = "17_2 Product/Service Description",
    product_2_ranking_code = "18_2 Ranking Code",                                                     
    product_2_ranking_description = "18_2 Ranking Desription",                                               
    product_2_remark = "19_2 Remarks/Notice on Forest",
    product_3_code = "17_3 Product/Service Code",
    product_3_description = "17_3 Product/Service Description",
    product_3_ranking_code = "18_3 Ranking Code",                                                     
    product_3_ranking_description = "18_3 Ranking Desription",                                               
    product_3_remark = "19_3 Remarks/Notice on Forest",
    product_4_code = "17_4 Product/Service Code",
    product_4_description = "17_4 Product/Service Description",
    product_4_ranking_code = "18_4 Ranking Code",                                                     
    product_4_ranking_description = "18_4 Ranking Desription",                                               
    product_4_remark = "19_4 Remarks/Notice on Forest",     
    cc_center = "E. Canopy cover_Center",                                               
    cc_north = "North",                                                             
    cc_east = "East",                                                               
    cc_south = "South",
    cc_west = "West",
    cc_mean = "Average" 
  )

tree_init_rua    <- map(path_rua, readxl::read_xlsx, sheet = "F5_Circular", col_types = "text") |> list_rbind()
