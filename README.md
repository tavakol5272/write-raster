# Write Raster

MoveApps

Github repository: *github.com/movestore/write-raster*

## Description

Transforms input data into a density raster (number of tracks) that can be downloaded in several GIS formats.

## Documentation

The dataset is projected to an azimuthal equidistant (AEQD) CRS centered on the data, with units in metres. For each individual track, the line is rasterized into a grid of user-defined grid size (in meters) and data-related bounding box. Tracks with less than 2 positions are removed. Rasterized tracks are summed resulting in one density raster (number of tracks) that can be downloaded in the user-selected file format (raster, ascii, CDF, or GTiff).

### Application scope

#### Generality of App usability

This App was developed for any taxonomic group.

#### Required data properties

The App should work for any kind of (location) data.

### Input data

move2::move2_loc

### Output data

move2::move2_loc


### Artefacts

`data_raster.***` – Raster output for download in one of the following formats:

-   `data_raster_raster.zip` – R raster (`.grd`) plus its auxiliary files
-   `data_raster_ascii.zip` – ASCII grid (`.asc`) plus its auxiliary files
-   `data_raster.tif` – GeoTIFF
-   `data_raster.nc` – netCDF

### Settings

**Value of your grid size (`grid`):** This parameter allows the user to decide on the grid cell size (in metres) that the raster shall be calculated in. One numeric value has to be entered. The default is 100000.

**Raster file type (`raster_type`):** The user can select one of four different raster output file formats: `raster`, `ascii`, `netCDF` or `GeoTiff`. The default is "raster".

### Changes in output data

The input data remains unchanged.

### Null or error handling:

**tracks:** If no track has at least 2 positions, the app logs: "No tracks with at least 2 positions in your data set. No rasterization possible." is shown.
