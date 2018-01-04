###############################################################################
# ggplot2: draw gray confidence bands and set line type manually
###############################################################################

# install.packages("ggplot2")
library(ggplot2)

# =============================================================================
# Create fake data
# =============================================================================
my.data <- data.frame(time     = rep(1:10,2),
                      means    = 2:21,
                      lowerCI  = 1:20,
                      upperCI  = 3:22,
                      scenario = rep(c("A","Z"), each=10))

# =============================================================================
# Plot
# =============================================================================
my_plot <- 
  ggplot(my.data, 
         aes(x = time, 
             y = means)) +
  # plot CI-s as a ribbon arround each line;
  # initiate the filling (fill) with color/gray differently for each scenario and
  # also adjust alpha parameter for - opacity/transparency
  geom_ribbon(aes(ymin = lowerCI, 
                  ymax = upperCI, 
                  fill = scenario), 
              alpha = 0.6) +
  # set manually the fill color for ribbons
  scale_fill_manual(name = 'Scenario',
                    breaks = c("Z", "A"),
                    values = c("A" = "gray70",
                               "Z" = "gray70")) +
  # add the average lines on top of CI ribbons
  geom_line(aes(linetype = scenario), 
            lwd = .8) +
  # set manually the type of line
  scale_linetype_manual(name = 'Scenario',
                        breaks = c("Z", "A"),
                        values = c("Z"  = "solid",
                                   "A"  = "twodash")) +
  # NOTE: to set the order in legend as desired one needs to mention that in breaks=()
  # set axis labels
  labs(x = "Time", 
       y = "Population growth") +
  # set number of axis ticks
  scale_x_continuous(breaks = pretty(my.data$time, 10)) +
  # theme without the default gray ggplot2 backgound
  theme_bw() + 
  # adjust some theme components
  theme(panel.grid = element_blank(), # eliminate default grids
        # set font family for all text within the plot ("serif" should work as "Times New Roman")
        # note that this can be overridden with other adjustment functions below
        text = element_text(family = "serif"),
        # adjust text in X-axis title
        axis.title.x = element_text(size = 12, face = "bold"),
        # adjust text in Y-axis title
        axis.title.y = element_text(size = 12, face = "bold"),
        # adjust legend title appearance
        legend.title = element_text(size = 10, face = "bold"),
        # adjust legend label appearance
        legend.text = element_text(size = 10),
        # don't draw legend box (check element_rect() for borders and backgrounds)
        legend.background = element_blank(),
        # Put lower-right corner of legend box in lower-right corner of graph
        # Note that the numeric position in legend.position below is relative to the entire area, 
        # including titles and labels, not just the plotting area
        legend.justification = c(1,0),
        legend.position = c(1,0))

# Save as png
ggsave(filename = "gallery/simple_confidence_bands.png",
       plot = my_plot, 
       width = 10, height = 8, units = "cm", dpi = 150)
# Save as pdf
ggsave(filename = "gallery/simple_confidence_bands.pdf",
       plot = my_plot, 
       width = 10, height = 8, units = "cm")