###############################################################################
## Script to create a choropleth map (world map) with tmap package
###############################################################################

require(tmap)
data(World) # load world map from tmap package
# for more data examples try:
# data(package="tmap")

# make the map
mapWorld  <- tmap::tm_shape(World, projection="eck4") + 
    # Note that the default projection for this world map is Eckhart IV already;
    # so no need to mention projection="eck4"
    # Text annotation example - Inform about the projection
    tm_credits(text = "Eckert IV projection",
               size = 0.3,
               position = c("RIGHT", "BOTTOM")) +
    # add grid of long-lat lines; labels can be canceled with labels.size = 0
    tm_grid(projection  = "longlat", 
            labels.size = .2, 
            labels.col  = "grey50", 
            lwd = 0.5)+
    # color the countries
    tm_polygons(col = "HPI", # this is the name of the column in World@data used for coloring
                style="fixed", breaks  = c(20, 30, 40, 50, 60, 70), # legend breaks;
                # Note that style argument below can also be used to compute legend breaks based
                # on different algorithms/ideas. Comment out with "#" the breaks argument above 
                # if you try one of the style argument options below.
                # Note also that more than 6-7 classes are hard to be distinguished by the human eye.
                # style="jenks",
                # style="pretty",
                # style="fisher",
                textNA  = "NA",     # display "NA" in legend for NA values (change it to other values if desired);
                colorNA = "white",  # color for NA values;
                auto.palette.mapping = FALSE, # if you set breaks manually, then this needs to be FALSE
                palette = "Spectral", # color palette; try tmaptools::palette_explorer() for examples
                title   = "Happy Planet Index", # legend title for this layer
                lwd = 0.5) + # line width of the polygons
    # some layout settings
    tm_layout(inner.margins=c(.02,.025, .01, .01),
              legend.bg.color = "white",
              legend.position = c("left","bottom"),
              legend.title.size = 1,
              legend.text.size  = 0.6,
              earth.boundary = TRUE,
              space.color    = "grey90", # color of space between earth.boundary and graph's margins
              bg.color = "lightblue",    # ocean color
              legend.format = list(scientific = TRUE,
                                   format     = "f"))

# save map as png
save_tmap(tm = mapWorld, 
          filename = "gallery/Choropleth world map, HPI - tmap.png", 
          units = "cm", width = 15, height = 8, dpi = 75)

# save map as html (interactive)
save_tmap(tm = mapWorld, 
          filename = "Choropleth world map, HPI - tmap.html")
# View the html file at:
# https://rawgit.com/valentinitnelav/valentinitnelav.github.io/master/gallery/Choropleth%20world%20map%2C%20HPI%20-%20tmap.html

# =============================================================================
# Some references:
# =============================================================================

# https://cran.r-project.org/web/packages/tmap/vignettes/tmap-nutshell.html
# https://github.com/mtennekes/tmap/tree/master/demo/ClassicMap
# https://cran.r-project.org/web/packages/tmap/vignettes/tmap-modes.html
# https://stackoverflow.com/questions/32890762/how-to-manipulate-tmap-legend
