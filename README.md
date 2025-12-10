# Write Raster
MoveApps

Github repository: *github.com/movestore/write-raster*

## Description
This App takes move2 object and creates a track-density raster that can be downloaded in several GIS formats.

## Documentation

This App The App get a move2 object as an input and then:

1-transformed to WGS84 if the data are not in geographic coordinates (long/lat).
2-tracks are split by track_id. Tracks with fewer than 2 positions are removed.
3-The dataset is projected to an azimuthal equidistant (AEQD) CRS centered on the data, with units in metres.
4-A blank grid is created over the AEQD bounding box. The grid resolution is set to the user-specified grid size (in metres).
5-Rasterizes tracks and sums them(first converte to a line, rasterize onto the grid, and sum)
6- The final raster is written in the user-selected file format (raster, ascii, CDF, or GTiff)

The original dataset (possibly transformed to WGS84) is also passed on as output to a possible next App.


### Input data
move2::move2_loc


### Output data
move2::move2_loc


### Artefacts
data_raster.***: Raster file for download in one of four possible formats:

data_raster.grd (raster)
data_raster.asc (ASCII grid)
data_raster.nc (netCDF)
data_raster.tif (GeoTIFF)

### Settings 
**Value of your grid size (`grid`):** This parameter allows the user to decide on the grid cell size (in metres) that the raster shall be calculated in. One numeric value has to be entered. The default is 100000.

**Raster file type (`raster_type`):** The user can select one of four different raster output file formats: `raster`, `ascii`, `netCDF` or `GeoTiff`. The default is "raster".

### Null or error handling:

**Data:** If the input data set is `NULL` or has 0 rows, the app logs this and returns the input unchanged.
**tracks:**If no track has at least 2 positions, the app logs: "No tracks with at least 2 positions in your data set. No rasterization possible."  is shown.
**output:**If everything is successful,logs a summary :"You request a raster output file of type *** with a grid size of **** metres."