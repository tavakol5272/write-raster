library(move2)
library(sf)
library(stars)
library(terra)

###Helper: Rasterize a single track
rasterize_track <- function(track_sf, time_col, crs_proj, raster_grid) {
  
  track_sf <- track_sf[order(track_sf[[time_col]]), , drop = FALSE]  #sort by time
  
  # Linestring
  track_line <- track_sf |>
    st_geometry() |>
    st_combine() |>
    st_cast("LINESTRING")
  
  line_sf  <- st_sf(a = 1, geometry = track_line, crs = crs_proj)
  
  track_raster <- st_rasterize(line_sf, raster_grid, options = "ALL_TOUCHED=TRUE")
  track_raster[is.na(track_raster)] <- 0
  track_raster
}



#### Main Function
rFunction <-  function(data, grid, raster_type = c("raster", "ascii", "CDF", "GTiff")) {
  
  # Handle NULL data
  if (is.null(data) || nrow(data) == 0) {
    logger.info("Input is NULL or has 0 rows — returning NULL.")
    return(NULL)
  }
  
  # if (st_crs(data)$epsg != 4326) {
  #   data <- st_transform(data, 4326)
  # }
  if (!sf::st_is_longlat(data)) data <- sf::st_transform(data, 4326)

  track_col <- mt_track_id_column(data)
  time_col <- mt_time_column(data)
  
  ## AEQD projection
  crs_proj <- mt_aeqd_crs(data, center = "center", units = "m")
  sf_data_proj <- st_transform(data, crs_proj)
  
  
  split_list <- split(sf_data_proj, sf_data_proj[[track_col]])
  
 # keep only tracks with at least 2 points 
  split_list <- split_list[lengths(split_list) >= 2L]
  
  if (length(split_list) == 0L) {
    logger.info("No tracks with at least 2 positions in your data set. No rasterization possible.")
    return(data)
  }
  
  
  
  #blank map grid
  bounds <- st_bbox(sf_data_proj) # bounding box
  raster_grid <- st_as_stars( bounds, dx = grid, dy = grid, values = 0 ) 
  
  #Rasterize all tracks
  track_raster_list <- lapply(
    split_list,
    rasterize_track,
    time_col= time_col,
    crs_proj= crs_proj,
    raster_grid= raster_grid
  )
  
  sum_raster <- Reduce("+", track_raster_list)
  sum_raster[sum_raster == 0] <- NA
  
  # convert stars to terra SpatRaster
  spat_raster <- terra::rast(sum_raster)
  spat_raster[spat_raster == 0] <- NA
  
  if (raster_type=="raster") terra::writeRaster(spat_raster ,filename=appArtifactPath("data_raster.grd"), overwrite = TRUE) 
  if (raster_type=="ascii") terra::writeRaster(spat_raster ,filename=appArtifactPath("data_raster.asc"), overwrite = TRUE) 
  if (raster_type=="GTiff") terra::writeRaster(spat_raster ,filename=appArtifactPath("data_raster.tif"), overwrite = TRUE) 
  if (raster_type=="CDF") terra::writeCDF(spat_raster ,filename=appArtifactPath("data_raster.nc"), overwrite = TRUE) 
  
  logger.info(paste("You request a raster output file of type",raster_type,"with a grid size of",grid,"metres."))
  
  return(data)
}
  
  
  
  
# #run locally  
# res <- rast("./data/output/data_raster.grd")
# res
# plot(res)
  
  
  
