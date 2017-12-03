###############################################################################
## Create a world cities map in Eckert IV projection with labeled graticules using ggplot.
## Repel overlapping text labels with ggrepel.
## Eckert IV is a nice looking equal-area projection :)
## https://upload.wikimedia.org/wikipedia/commons/c/c5/Ecker_IV_projection_SW.jpg
###############################################################################

library(rgdal)      # for spTransform() & project()
library(ggplot2)    # for ggplot()
library(ggrepel)    # for geom_text_repel() - repel overlapping text labels
library(data.table)

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
# Project from long-lat to Eckert IV projection
# =============================================================================

# spTransform() is used for shapefiles and project() in the case of data frame
# for more PROJ.4 strings check the followings
#   http://proj4.org/projections/index.html
#   https://epsg.io/

# __ give the PORJ.4 string for Eckert IV projection
PROJ <- "+proj=eck4 +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs" 
# or use the short form "+proj=eck4"

# __ project the shapefiles
NE_countries.prj  <- spTransform(NE_countries, CRSobj = PROJ)
NE_graticules.prj <- spTransform(NE_graticules, CRSobj = PROJ)
NE_box.prj        <- spTransform(NE_box, CRSobj = PROJ)

# __ project long-lat coordinates columns for data frames 
# (two extra columns with projected XY are created)
prj.coord <- project(cbind(lbl.Y$lon, lbl.Y$lat), proj = PROJ)
lbl.Y.prj <- cbind(prj.coord, lbl.Y)
names(lbl.Y.prj)[1:2] <- c("X.prj","Y.prj")

prj.coord <- project(cbind(lbl.X$lon, lbl.X$lat), proj = PROJ)
lbl.X.prj <- cbind(prj.coord, lbl.X)
names(lbl.X.prj)[1:2] <- c("X.prj","Y.prj")

# before projecting, transform NE_places to data frame to use it inside ggplot()
NE_places.df     <- cbind(NE_places@coords, NE_places@data)
names(NE_places.df)[1:2] <- c("lon", "lat")
prj.coord        <- project(cbind(NE_places.df$lon, NE_places.df$lat), proj = PROJ)
NE_places.df.prj <- cbind(prj.coord, NE_places.df)
names(NE_places.df.prj)[1:2] <- c("X.prj","Y.prj")

# =============================================================================
# Prepare the point-places table for plotting
# =============================================================================

# add some helpful columns

# transform to data.table (easier to work with)
NE_places.dt.prj <- data.table(NE_places.df.prj)

# keep only desired columns (is easier to read)
NE_places.dt.prj <- NE_places.dt.prj[, .(X.prj, Y.prj, NAME, POP_MAX)]

# cities below threshold will not be displayed 
# this will play a role for labeling and coloring
pop.lim <- 3*10^6 # set a population threshold
NE_places.dt.prj[, lbl := ifelse(POP_MAX < pop.lim, "", NAME)]
NE_places.dt.prj[, big.city := ifelse(POP_MAX < pop.lim, 0, 1)]

# split population in desired intervals/classes
# this will act as point size
NE_places.dt.prj[, POP_MAX.cls := cut(POP_MAX,
                                      labels=c(1:5),
                                      breaks=c(min(POP_MAX)-1, 
                                               1*10^6, 
                                               3*10^6, 
                                               5*10^6, 
                                               10*10^6, 
                                               max(POP_MAX)),
                                      include.lowest=FALSE, 
                                      right=TRUE)]
NE_places.dt.prj[, POP_MAX.cls := as.integer(POP_MAX.cls)] # transform to integer

# =============================================================================
# Plot, edit layers and add legend
# =============================================================================

ggplot() +
  # __ add layers and labels
  # add projected countries
  geom_polygon(data = NE_countries.prj, 
               aes(long,lat, group = group), 
               colour = "gray70", fill = "gray90", size = .25) +
  # Note: "Regions defined for each Polygons" warning has to do with fortify transformation. 
  # fortify might get deprecated in future!
  # alternatively, use use map_data(NE_countries) to transform to data frame and then use project() to change to desired projection.
  # add projected bounding box
  geom_polygon(data = NE_box.prj, 
               aes(x = long, y = lat), 
               colour = "black", fill = "transparent", size = .25) +
  # add locations (points); add opacity with "alpha" argument
  geom_point(data = NE_places.dt.prj, 
             aes(x = X.prj, y = Y.prj, size = POP_MAX.cls, colour = factor(big.city)), 
             alpha = .5) +
  # add labels - cities above given threshold (repel overlapping text labels)
  # more adjustments here: https://cran.r-project.org/web/packages/ggrepel/vignettes/ggrepel.html
  geom_text_repel(data = NE_places.dt.prj, 
                  aes(x = X.prj, y = Y.prj, label = lbl, colour = factor(big.city)),
                  # label size
                  size = 2,
                  # color of the line segments
                  segment.colour = "#336699",
                  # line segment transparency
                  segment.alpha = .5,
                  # line segment thickness
                  segment.size = .25,
                  # the force of repulsion between overlapping text labels
                  force = 3,
                  # maximum number of iterations to attempt to resolve overlaps
                  max.iter = 10e3,
                  # turn labels off in the legend (otherwise you get something like https://goo.gl/fW7I7P)
                  show.legend = FALSE) +
  # add graticules
  geom_path(data = NE_graticules.prj, 
            aes(long, lat, group = group), 
            linetype = "dotted", colour = "grey50", size = .25) +
  # add graticule labels - latitude and longitude
  geom_text(data = lbl.Y.prj, # latitude
            aes(x = X.prj, y = Y.prj, label = lbl), 
            colour = "grey50", size = 2) +
  geom_text(data = lbl.X.prj, # longitude
            aes(x = X.prj, y = Y.prj, label = lbl), 
            colour = "grey50", size = 2) +
  # __ Set aspect ratio
  # the default, ratio = 1 in coord_fixed ensures that one unit on the x-axis is the same length as one unit on the y-axis
  coord_fixed(ratio = 1) +
  # __ Set empty theme
  theme_void() + # remove the default background, gridlines & default gray color around legend's symbols
  # __ Set legend & adjust margins
  # for "city size" leged - give title and labels
  # this is related to size = POP_MAX.cls in geom_point() above
  scale_size_continuous(name   = "City size:",
                        labels = c("below 1 M", 
                                   "1 M - 3 M", 
                                   "3 M - 5 M", 
                                   "5 M - 10 M", 
                                   "above 10 M")) +
  # for "Is labeled? legend - set city color
  # this is related to colour = factor(big.city) in geom_point() and geom_text_repel() above
  scale_colour_manual(name   = "Is labeled?",
                      values = c("0"="#666666", "1"="#336699"), # #666666=dove gray & #336699=azure blue
                      labels = c("no (below 3 M)", "yes (above 3 M)")) + 
  # adjust city size point and add corresponding color
  guides(size  = guide_legend(override.aes = list(size=sort(unique(NE_places.dt.prj$POP_MAX.cls)),
                                                  colour=c(rep("#666666",2), rep("#336699",3)))),
         # this will affect the "Is labeled?" legend section (modify size and symbol type)
         color = guide_legend(override.aes = list(size=5, pch=15))) + 
  # final theme tweaks
  theme(legend.title = element_text(colour="black", size=10, face="bold"), # adjust legend title
        legend.position = c(1.01, 0.25), # relative position of legend
        plot.margin = unit(c(t=0, r=2, b=0, l=0), unit="cm")) # adjust margins

# Save as png and pdf file
ggsave("gallery/world cities map in Eckert IV ggplot & ggrepel.png", 
       width=30, height=14, units="cm", dpi=75)
ggsave("gallery/world cities map in Eckert IV ggplot & ggrepel.pdf", 
       width=30, height=14, units="cm")


# =============================================================================
# Some helpful links:
# =============================================================================

# This link was useful for graticule idea
#   http://stackoverflow.com/questions/38532070/how-to-add-lines-of-longitude-and-latitude-on-a-map-using-ggplot2
# Working with ggplot()
#  http://r4ds.had.co.nz/visualize.html
#  http://zevross.com/blog/2014/08/04/beautiful-plotting-in-r-a-ggplot2-cheatsheet-3/#working-with-the-legend