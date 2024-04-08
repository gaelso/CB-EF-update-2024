

## Steps:
## 1. rename columns 
## 2. Correct data type
## 3. Correct typos
## 4. Add calculated variables (true coordinates)


##
names(plot_init_rua)

plot_tmp1 <- plot_init_rua |>
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


