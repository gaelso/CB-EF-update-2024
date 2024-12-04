
set.seed(10)
tt <- cluster_init_moef |> slice_sample(n = 1)

tt |> select(cluster_access_starting_point_utmx, cluster_access_starting_point_utmy)


sf_tt <- cluster_init_moef |> st_as_sf(
  coords = c("cluster_access_starting_point_utmx", "cluster_access_starting_point_utmy"),
  crs = 32648
  )

ggplot(sf_tt) + geom_sf()


sf_tt <- tt |> st_as_sf(
  coords = c("cluster_access_starting_point_utmx", "cluster_access_starting_point_utmy"),
  crs = 32648
  )
sf_tt

ggplot(sf_tt) + geom_sf()

plot_init_moef



