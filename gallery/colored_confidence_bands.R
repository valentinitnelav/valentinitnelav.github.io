###############################################################################
# ggplot2: draw confidence bands and set color manually
###############################################################################

# install.packages("ggplot2")
library(ggplot2)

# =============================================================================
# Create fake data
# =============================================================================
# Note that this is fake data,
# this is not the way to statistically compute confidence intervals.
x <- seq(from = 0, to = 2*pi, by = 0.1)
my.data <- data.frame(x        = rep(x,2),
                      sin.cos  = c(sin(x),cos(x)),
                      lowerCI  = c(sin(x),cos(x)) - 0.2,
                      upperCI  = c(sin(x),cos(x)) + 0.2,
                      Function = rep(c("sin","cos"), each = 63))

# =============================================================================
# Plot
# =============================================================================
my_plot <- 
  ggplot(my.data, 
         aes(x = x, 
             y = sin.cos)) +
  # plot CI-s as a ribbon arround each line
  geom_ribbon(aes(ymin = lowerCI, 
                  ymax = upperCI, 
                  fill = Function), 
              alpha = 0.4) +
  # set manually the fill color for ribbons
  scale_fill_manual(name = 'Function',
                    breaks = c('cos', 'sin'),
                    values = c('cos' = 'red',
                               'sin' = 'blue')) +
  # add the lines on top of CI ribbons
  geom_line(aes(color = Function), 
            lwd = .8, 
            linetype = 'solid') +
  # set manually the color of the lines
  scale_color_manual(name = 'Function',
                     breaks = c('cos', 'sin'),
                     values = c('cos' = 'red',
                                'sin' = 'blue')) +
  # NOTE: to set the order in legend as desired one needs to mention that in breaks=c()
  # set axis labels
  labs(x = "x", 
       y = "sin & cos") +
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
        # Put lower-left corner of legend box in lower-left corner of graph
        # Note that the numeric position in legend.position below is relative to the entire area, 
        # including titles and labels, not just the plotting area
        legend.justification = c(0,0),
        legend.position = c(0,0))

# Save as png
ggsave(filename = "gallery/colored_confidence_bands.png",
       plot = my_plot, 
       width = 10, height = 8, units = "cm", dpi = 75)
# Save as pdf
ggsave(filename = "gallery/colored_confidence_bands.pdf",
       plot = my_plot, 
       width = 10, height = 8, units = "cm")