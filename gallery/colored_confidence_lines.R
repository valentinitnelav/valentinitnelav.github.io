###############################################################################
# ggplot2: confidence lines and set line types manually;
# Also forces representation of CI lines in legend.
###############################################################################

# install.packages("ggplot2")
library(ggplot2)

# =============================================================================
# Create fake data
# =============================================================================
x <- seq(from=0, to=2*pi, by=0.1)
my.data <- data.frame(x        = rep(x,2),
                      sin.cos  = c(sin(x),cos(x)),
                      lowerCI  = c(sin(x),cos(x)) - 0.2,
                      upperCI  = c(sin(x),cos(x)) + 0.2,
                      Function = rep(c("sin","cos"), each=63))

# =============================================================================
# Plot
# =============================================================================
my_plot <- 
  ggplot(my.data, 
         aes(x = x, 
             y = sin.cos)) +
  # add the sin.cos lines
  geom_line(aes(colour = Function)) +
  # add "confidence" lines
  geom_line(aes(y = lowerCI, 
                colour = paste0('CI - ', Function)),
            linetype = 'dotted', 
            lwd=.5) +
  geom_line(aes(y = upperCI, 
                colour = paste0('CI - ', Function)),
            linetype = 'dotted', 
            lwd=.5) +
  # set line color manually; forces also the CI lines to appear in legend
  scale_colour_manual(name = 'Function',
                      breaks = c('cos', 'sin', 'CI - cos', 'CI - sin'),
                      values = c('cos'      = 'red',
                                 'sin'      = 'blue',
                                 'CI - cos' = 'red',
                                 'CI - sin' = 'blue')) +
  # override line type in leged so that CI lines are porperly represented
  guides(colour = guide_legend(override.aes = list(linetype = c(rep('solid', 2), 
                                                                rep('dotted',2))))) +
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
ggsave(filename = "gallery/colored_confidence_lines.png",
       plot = my_plot, 
       width = 10, height = 8, units = "cm", dpi = 75)
# Save as pdf
ggsave(filename = "gallery/colored_confidence_lines.pdf",
       plot = my_plot, 
       width = 10, height = 8, units = "cm")

# addapted from:
# http://stackoverflow.com/questions/41743356/ggplot2-adding-lines-of-same-color-but-different-type-to-legend