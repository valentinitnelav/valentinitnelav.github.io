###############################################################################
## Shift central/prime meridian and plot world map with ggplot
###############################################################################

library(data.table)
library(ggplot2)
library(rgdal)
library(rgeos)
library(maps)
library(maptools)

# =============================================================================
# Get world map in proper format
# =============================================================================
# Load world map as map object
worldmap      <- map("world", fill=TRUE, plot=FALSE)
# Convert map object to SpatialPolygons object (check ?map2SpatialPolygons)
WGS84 <- CRS("+proj=longlat +datum=WGS84")
worldmapPolys <- map2SpatialPolygons(worldmap, 
                                     IDs=sapply(strsplit(worldmap$names, ":"), "[", 1L), 
                                     proj4string=WGS84)

# =============================================================================
# Split world map by "split line"
# =============================================================================
# check "split polygon by line" at:
# https://stat.ethz.ch/pipermail/r-sig-geo/2015-July/023168.html

# shift central/prime meridian towards west - positive values only
shift <- 180+20 

# create "split line" to split worldmap 
split.line = SpatialLines(list(Lines(list(Line(cbind(180-shift,c(-90,90)))), ID="line")), 
                          proj4string=WGS84)

# gBuffer solution to avoid 'TopologyException' when intersecting line with world polys 
# http://gis.stackexchange.com/questions/163445/r-solution-for-topologyexception-input-geom-1-is-invalid-self-intersection-er
worldmapPolys <- gBuffer(worldmapPolys, byid=TRUE, width=0)

# intersecting line with world polys 
line.gInt <- gIntersection(split.line, worldmapPolys)

# create a very thin polygon (buffer) out of the intersecting "split line"
bf <- gBuffer(line.gInt, byid=TRUE, width=0.000001)  

# split world polys using intersecting thin polygon (buffer)
worldmapPolys.split <- gDifference(worldmapPolys, bf, byid=TRUE)
# plot(worldmapPolys.split) # check map

# =============================================================================
# Prepare data for ggplot & plot
# =============================================================================
# transform map in a data table that ggplot can use
XY <- data.table(map_data(as(worldmapPolys.split, "SpatialPolygonsDataFrame")))

# Shift coordinates (data.table way)
XY[, long.new := long + shift]
XY[, long.new := ifelse(long.new > 180, long.new-360, long.new)]

# plot shifted map
ggplot() + 
  geom_polygon(data=XY, 
               aes(x=long.new, y=lat, group=group), 
               colour="black", 
               fill="gray80", 
               size = 0.25) +
  coord_equal()

# -------------------------------------
# Example with projected coordinates - Robinson projection
# -------------------------------------
PROJ <- "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
# assign matrix of projected coordinates as two columns in data table
XY[, c("X","Y") := data.table(project(cbind(long.new, lat), proj=PROJ))]
# plot shifted world map 
ggplot() + 
  geom_polygon(data=XY, 
               aes(x=X, y=Y, group=group), 
               colour="black", 
               fill="gray80", 
               size = 0.25) +
  coord_equal() +
  theme_bw()

ggsave("gallery/Shift central (prime) meridian.png", 
       width=15, height=8, units="cm", dpi=75)