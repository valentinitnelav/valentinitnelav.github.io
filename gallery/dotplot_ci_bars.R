###############################################################################
# ggplot2: dotplot with CI/error bars
# see also: http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/
###############################################################################

# install.packages("ggplot2")
library(ggplot2)

# =============================================================================
# Create fake data
# =============================================================================
set.seed(1)
DF <- data.frame(Treatment = rep(c("control", "T1", "T2", "T1&2"), times=2),
                 Species   = rep(c("Sp1", "Sp2"), each=4),
                 means     = c(rnorm(n=4, mean=5), 
                               rnorm(n=4, mean=6)))

# Note that this is fake data, this is not the way to statistically compute CI-s or SE-s
DF$lower.CI  <- DF$means - rnorm(n=8, mean=.5, sd=.1)
DF$upper.CI  <- DF$means + rnorm(n=8, mean=.5, sd=.1)

# =============================================================================
# Plot
# =============================================================================
# The errorbars will overlapp, so use position_dodge to move them horizontally
pd <- position_dodge(width = 0.2) # move them .05 to the left and right

my_plot <- 
  ggplot(data = DF, 
         aes(x = Treatment, 
             y = means, 
             group = Species, 
             shape = Species)) +
  # add the points (means)
  geom_point(size = 1.5, 
             position = pd) +
  # set type of point shape
  scale_shape_manual(name   = 'Species:',
                     breaks = c("Sp1", "Sp2"),
                     values = c("Sp1" = 16, 
                                "Sp2" = 17),
                     labels = c("Species 1", "Species 2")) + 
  # plot CIs
  geom_errorbar(aes(ymax = upper.CI, 
                    ymin = lower.CI), 
                size  = .4, 
                width = .15, 
                linetype = "solid", 
                position = pd) +
  # set order of discrete values on OX axes & adjust the distance (gap) from OY axis
  scale_x_discrete(limits = c("control", "T1", "T2", "T1&2"),
                   labels = c("control", "Treatment 1", "Treatment 2", "Treatment 1 \n and Treatment 2"),
                   expand = c(0, .5)) +
  # set range on OY axes and adjust the distance (gap) from OX axis
  scale_y_continuous(limits = c(0, 10), 
                     expand = c(0, 0)) +
  # set axis labels
  labs(x = "", 
       y = "Means") +
  # theme without the default gray ggplot2 backgound
  theme_bw() +
  # adjust some theme components
  theme(panel.grid = element_blank(), # eliminate default grids
        # set font family for all text within the plot ("serif" should work as "Times New Roman")
        # note that this can be overridden with other adjustment functions below
        text = element_text(family="serif"),
        # adjust X-axis title
        axis.title.x = element_text(size = 10, face = "bold"),
        # adjust X-axis labels
        axis.text.x = element_text(size = 10, face = "bold", color = "black"),
        # adjust Y-axis title
        axis.title.y = element_text(size = 10, face = "bold"),
        # adjust legend title appearance
        legend.title = element_text(size = 8, face = "bold"),
        # adjust legend label appearance
        legend.text = element_text(size = 8, face = "italic"),
        # change spacing between legend items
        legend.key.height = unit(4, "mm"),
        # don't draw legend box (check element_rect() for borders and backgrounds)
        legend.background = element_blank(),
        # Put upper-left corner of legend box in upper-left corner of graph
        # Note that the numeric position in legend.position below is relative to the entire area, 
        # including titles and labels, not just the plotting area
        legend.justification = c(0,1),
        legend.position = c(0,1))

# Save as png
ggsave(filename = "gallery/dotplot_ci_bars.png",
       plot = my_plot, 
       width = 10, height = 8, units = "cm", dpi = 150)
# Save as pdf
ggsave(filename = "gallery/dotplot_ci_bars.pdf",
       plot = my_plot, 
       width = 10, height = 8, units = "cm")