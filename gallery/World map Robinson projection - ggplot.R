###############################################################################
# Create a simple world map in Robinson projection with labeled graticules using ggplot
###############################################################################

library(rgdal)      # for spTransform() & project()
library(ggplot2)    # for ggplot()

# =============================================================================
# Load ready to use data from GitHub
# =============================================================================
load(url("https://github.com/valentinitnelav/RandomScripts/blob/master/NaturalEarth.RData?raw=true"))
# This will load 6 objects:
#   xbl.X & lbl.Y are two data.frames that contain labels for graticule lines
#       They can be created with the code at this link: 
#       https://gist.github.com/valentinitnelav/8992f09b4c7e206d39d00e813d2bddb1
#   NE_box is a SpatialPolygonsDataFrame object and represents a bounding box for Earth 
#   NE_countries is a SpatialPolygonsDataFrame object representing countries 
#   NE_graticules is a SpatialLinesDataFrame object that represents 10 dg latitude lines and 20 dg longitude lines
#           (for creating graticules check also the graticule package or gridlines fun. from sp package)
#           (or check this gist: https://gist.github.com/valentinitnelav/a7871128d58097e9d227f7a04e00134f)
#   NE_places - SpatialPointsDataFrame with city and town points
#   NOTE: data downloaded from http://www.naturalearthdata.com/
#         here is a sample script how to download, unzip and read such shapefiles:
#         https://gist.github.com/valentinitnelav/a415f3fbfd90f72ea06b5411fb16df16

# =============================================================================
# Project from long-lat (unprojected data) to Robinson projection
# =============================================================================

# spTransform() is used for shapefiles and project() in the case of data frames
# for more PROJ.4 strings check the followings
#   http://proj4.org/projections/index.html
#   https://epsg.io/

PROJ <- "+proj=robin +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs" 
# or use the short form "+proj=robin"
NE_countries_rob  <- spTransform(NE_countries, CRSobj = PROJ)
NE_graticules_rob <- spTransform(NE_graticules, CRSobj = PROJ)
NE_box_rob        <- spTransform(NE_box, CRSobj = PROJ)

# project long-lat coordinates for graticule label data frames 
# (two extra columns with projected XY are created)
prj.coord <- project(cbind(lbl.Y$lon, lbl.Y$lat), proj=PROJ)
lbl.Y.prj <- cbind(prj.coord, lbl.Y)
names(lbl.Y.prj)[1:2] <- c("X.prj","Y.prj")

prj.coord <- project(cbind(lbl.X$lon, lbl.X$lat), proj=PROJ)
lbl.X.prj <- cbind(prj.coord, lbl.X)
names(lbl.X.prj)[1:2] <- c("X.prj","Y.prj")

# =============================================================================
# Plot layers
# =============================================================================

ggplot() +
  # add Natural Earth countries projected to Robinson, give black border and fill with gray
  geom_polygon(data=NE_countries_rob, aes(long,lat, group=group), colour="black", fill="gray80", size = 0.25) +
  # Note: "Regions defined for each Polygons" warning has to do with fortify transformation. Might get deprecated in future!
  # alternatively, use use map_data(NE_countries) to transform to data frame and then use project() to change to desired projection.
  # add Natural Earth box projected to Robinson
  geom_polygon(data=NE_box_rob, aes(x=long, y=lat), colour="black", fill="transparent", size = 0.25) +
  # add graticules projected to Robinson
  geom_path(data=NE_graticules_rob, aes(long, lat, group=group), linetype="dotted", color="grey50", size = 0.25) +
  # add graticule labels - latitude and longitude
  geom_text(data = lbl.Y.prj, aes(x = X.prj, y = Y.prj, label = lbl), color="grey50", size=2) +
  geom_text(data = lbl.X.prj, aes(x = X.prj, y = Y.prj, label = lbl), color="grey50", size=2) +
  # the default, ratio = 1 in coord_fixed ensures that one unit on the x-axis is the same length as one unit on the y-axis
  coord_fixed(ratio = 1) +
  # remove the background and default gridlines
  theme_void()

# Save as png and pdf file
ggsave("gallery/World map Robinson projection - ggplot.png", 
       width=15, height=8, units="cm", dpi=75)

ggsave("gallery/World map Robinson projection - ggplot.pdf", 
       width=15, height=8, units="cm")

# =============================================================================
# REFERENCES:
# =============================================================================

# This link was useful for graticule idea
#   http://stackoverflow.com/questions/38532070/how-to-add-lines-of-longitude-and-latitude-on-a-map-using-ggplot2
# Working with shapefiles, projections and world maps in ggplot
#   http://rpsychologist.com/working-with-shapefiles-projections-and-world-maps-in-ggplot