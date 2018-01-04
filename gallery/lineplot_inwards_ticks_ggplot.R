###############################################################################
# ggplot2: Example of lineplot with inwards ticks.
# Also, using both points and lines as type="b" in base plot()
###############################################################################

# install.packages("ggplot2")
library(ggplot2)

# =============================================================================
# Create fake data
# =============================================================================
set.seed(1)
DF <- data.frame(year = c(2000:2020),
                 mean = rnorm(n=21, mean=100, sd=10))

# =============================================================================
# Function to return a desired sequence breaks along axes
# =============================================================================
my.breaks <- function(my.vector, step){
  my.min <- floor(min(my.vector))
  my.max <- ceiling(max(my.vector))
  my.seq <- seq(from = round(my.min/step)*step, 
                to   = round(my.max/step)*step,
                by   = step)
  return(my.seq)
}

# =============================================================================
# Plot
# =============================================================================
my_plot <- 
  ggplot(data = DF, 
         aes(x = year, 
             y = mean)) +
  # Add two vertical lines
  geom_vline(xintercept = c(2010,2013), 
             linetype = "dashed", 
             color = "gray", 
             lwd = .5) +
  # Add the "mean" lines which will connect the points
  geom_line(lwd = .4) +
  # Add the "mean" points.
  # Use "stroke" to adjust the white border thickness of the points 
  # in order to give the same effect as in base-r plot `type=b`
  geom_point(size   = 2, 
             shape  = 21, 
             fill   = "black", 
             colour = "white", 
             stroke = 1.2) +
  # Set axes titles and labels
  scale_x_continuous(name   = "Year", 
                     breaks = my.breaks(DF$year, step = 5)) +
  scale_y_continuous(name   = "Means", 
                     breaks = my.breaks(DF$mean, step = 10)) +
  # Theme without the default gray ggplot2 backgound
  theme_bw() +
  # Adjust some theme components
  theme(panel.grid = element_blank(), # eliminate default grids
        # Set font family for all text within the plot ("serif" should work as "Times New Roman")
        # note that this can be overridden with other adjustment functions below
        text = element_text(family = "serif"),
        # Adjust X-axis title
        axis.title.x = element_text(size = 10, face = "bold"),
        # Adjust X-axis labels; also adjust their position using margin (acts like a bounding box);
        # Using margin was needed because of the inwards placement of ticks
        # http://stackoverflow.com/questions/26367296/how-do-i-make-my-axis-ticks-face-inwards-in-ggplot2
        axis.text.x = element_text(size = 8, margin = unit(c(t = 2.5, r = 0, b = 0, l = 0), "mm")),
        # Adjust Y-axis title
        axis.title.y = element_text(size = 10, face = "bold"),
        # Adjust Y-axis labels
        axis.text.y = element_text(size = 8, margin = unit(c(t = 0, r = 2.5, b = 0, l = 0), "mm")),
        # Set length of tick marks - negative sign places ticks inwards
        axis.ticks.length = unit(-1.4, "mm"),
        # Set width of tick marks in mm
        axis.ticks = element_line(size = .3))

# Save as png
ggsave(filename = "gallery/lineplot_inwards_ticks_ggplot.png",
       plot = my_plot, 
       width = 10, height = 8, units = "cm", dpi = 150)
# Save as pdf
ggsave(filename = "gallery/lineplot_inwards_ticks_ggplot.pdf",
       plot = my_plot, 
       width = 10, height = 8, units = "cm")