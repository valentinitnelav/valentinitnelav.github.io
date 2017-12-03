###############################################################################
# Pacific centered world map with ggplot.
# Enhanced aspect with graticules and labels.
# The central/prime meridian can be shifted with any positive value towards west.
# Can use any project of known PROJ.4 string
###############################################################################

library(data.table)
library(ggplot2)
library(rgdal)
library(rgeos)
library(maps)
library(maptools)
library(raster)

# =============================================================================
# Download shapefile from www.naturalearthdata.com
# =============================================================================

# Download countries data
download.file(url = "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/cultural/ne_110m_admin_0_countries.zip", 
              destfile = "gallery/ne_110m_admin_0_countries.zip")
# unzip the shapefile in the directory mentioned with "exdir" argument
unzip(zipfile="gallery/ne_110m_admin_0_countries.zip", exdir = "gallery/ne_110m_admin_0_countries")
# delete the zip file
file.remove("gallery/ne_110m_admin_0_countries.zip")
# read the shapefile with readOGR from rgdal package
NE_countries <- readOGR(dsn = "gallery/ne_110m_admin_0_countries", layer = "ne_110m_admin_0_countries")
class(NE_countries) # is a SpatialPolygonsDataFrame object

# =============================================================================
# Split world map by "split line"
# =============================================================================

# inspired from:
# https://stat.ethz.ch/pipermail/r-sig-geo/2015-July/023168.html

# shift central/prime meridian towards west - positive values only
shift <- 180+30

# create "split line" to split country polygons
WGS84 <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
split.line = SpatialLines(list(Lines(list(Line(cbind(180-shift,c(-90,90)))), ID="line")), 
                          proj4string=WGS84)

# NOTE - in case of TopologyException' errors when intersecting line with country polygons,
# apply the gBuffer solution suggested at:
# http://gis.stackexchange.com/questions/163445/r-solution-for-topologyexception-input-geom-1-is-invalid-self-intersection-er
# NE_countries <- gBuffer(NE_countries, byid=TRUE, width=0)

# intersecting line with country polygons
line.gInt <- gIntersection(split.line, NE_countries)

# create a very thin polygon (buffer) out of the intersecting "split line"
bf <- gBuffer(line.gInt, byid=TRUE, width=0.000001)  

# split country polygons using intersecting thin polygon (buffer)
NE_countries.split <- gDifference(NE_countries, bf, byid=TRUE)
# plot(NE_countries.split) # check map
class(NE_countries.split) # is a SpatialPolygons object

# =============================================================================
# Create graticules
# =============================================================================

# create a bounding box - world extent
b.box <- as(raster::extent(-180, 180, -90, 90), "SpatialPolygons")
# assign CRS to box
proj4string(b.box) <- WGS84
# create graticules/grid lines from box
grid <- gridlines(b.box, 
                  easts  = seq(from=-180, to=180, by=20),
                  norths = seq(from=-90, to=90, by=10))

# create labels for graticules
grid.lbl <- labels(grid, side = 1:4)

# transform labels from SpatialPointsDataFrame to a data table that ggplot can use
grid.lbl.DT <- data.table(grid.lbl@coords, grid.lbl@data)

# prepare labels with regular expression:
# - delete unwanted labels
grid.lbl.DT[, labels := gsub(pattern="180\\*degree|90\\*degree\\*N|90\\*degree\\*S", replacement="", x=labels)]
# - replace pattern "*degree" with "°" (* needs to be escaped with \\)
grid.lbl.DT[, lbl := gsub(pattern="\\*degree", replacement="°", x=labels)]
# - delete any remaining "*"
grid.lbl.DT[, lbl := gsub(pattern="*\\*", replacement="", x=lbl)]

# adjust coordinates of labels so that they fit inside the globe
grid.lbl.DT[, long := ifelse(coords.x1 %in% c(-180,180), coords.x1*175/180, coords.x1)]
grid.lbl.DT[, lat  := ifelse(coords.x2 %in% c(-90,90), coords.x2*82/90, coords.x2)]

# =============================================================================
# Prepare data for ggplot, shift & project coordinates
# =============================================================================

# give the PORJ.4 string for Eckert IV projection
PROJ <- "+proj=eck4 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs" 

# transform graticules from SpatialLines to a data table that ggplot can use
grid.DT <- data.table(map_data(SpatialLinesDataFrame(sl=grid, 
                                                     data=data.frame(1:length(grid)), 
                                                     match.ID = FALSE)))
# project coordinates
# assign matrix of projected coordinates as two columns in data table
grid.DT[, c("X","Y") := data.table(project(cbind(long, lat), proj=PROJ))]

# project coordinates of labels
grid.lbl.DT[, c("X","Y") := data.table(project(cbind(long, lat), proj=PROJ))]

# transform split country polygons in a data table that ggplot can use
Country.DT <- data.table(map_data(as(NE_countries.split, "SpatialPolygonsDataFrame")))
# Shift coordinates
Country.DT[, long.new := long + shift]
Country.DT[, long.new := ifelse(long.new > 180, long.new-360, long.new)]
# project coordinates 
Country.DT[, c("X","Y") := data.table(project(cbind(long.new, lat), proj=PROJ))]

# =============================================================================
# Plot
# =============================================================================
ggplot() + 
  # add projected countries
  geom_polygon(data = Country.DT, 
               aes(x = X, y = Y, group = group), 
               colour = "gray70", 
               fill = "gray90", 
               size = 0.25) +
  # add graticules
  geom_path(data = grid.DT, 
            aes(x = X, y = Y, group = group), 
            linetype = "dotted", colour = "grey50", size = .25) +
  # add a bounding box (select graticules at edges)
  geom_path(data = grid.DT[(long %in% c(-180,180) & region == "NS")
                           |(long %in% c(-180,180) & lat %in% c(-90,90) & region == "EW")], 
            aes(x = X, y = Y, group = group), 
            linetype = "solid", colour = "black", size = .3) +
  # add graticule labels
  geom_text(data = grid.lbl.DT, # latitude
            aes(x = X, y = Y, label = lbl), 
            colour = "grey50", size = 2) +
  # ensures that one unit on the x-axis is the same length as one unit on the y-axis
  coord_equal() + # same as coord_fixed(ratio = 1)
  # set empty theme
  theme_void()

# Save as png and pdf file
ggsave("gallery/Pacific centered world map with ggplot.png", 
       width=15, height=8, units="cm", dpi=75)

ggsave("gallery/Pacific centered world map with ggplot.pdf", 
       width=15, height=8, units="cm")