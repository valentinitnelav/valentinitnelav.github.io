###############################################################################
# Barplot with CI/error bars side-by-side in ggplot
# see more at: http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/
###############################################################################

# install.packages("ggplot2")
library(ggplot2)

# =============================================================================
# Create some data
# =============================================================================
# For ggplot, data must be in long format (not wide format)
set.seed(1)
DF <- data.frame(Treatment = rep(c("control", "T1", "T2", "T1&2"), times=2),
                 Species   = rep(c("Sp1", "Sp2"), each=4),
                 means     = c(rnorm(n=4, mean=5), 
                               rnorm(n=4, mean=6)))

# Note that this is fake data, this is not the way to statistically compute CI-s or SE-s
DF$lower.CI  <- DF$means - rnorm(n=8, mean=.5, sd=.1)
DF$upper.CI  <- DF$means + rnorm(n=8, mean=.5, sd=.1)

# =============================================================================
# Plot barplot with ggplot
# =============================================================================
my_barplot <-
  ggplot(data = DF, 
         aes(x    = Treatment, 
             y    = means, 
             fill = Species)) +
  # add the bars (means)
  geom_bar(stat = "identity", 
           position = position_dodge()) +
  # fill the bars manually
  scale_fill_manual(name   = 'Species:',
                    breaks = c("Sp1", "Sp2"),
                    values = c("Sp1" = "gray70", 
                               "Sp2" = "gray40"),
                    labels = c("Species 1", "Species 2")) + 
  # plot CIs (add a point shape as well)
  geom_errorbar(aes(ymax = upper.CI, 
                    ymin = lower.CI), 
                size  = .4, 
                width = .15, 
                linetype = "solid", 
                position = position_dodge(.9)) +
  geom_point(position = position_dodge(width = .9), 
             shape = "-", 
             show.legend = FALSE) +
  # set order of discrete values on OX axes & adjust the distance (gap) from OY axes
  scale_x_discrete(limits = c("control", "T1", "T2", "T1&2"),
                   labels = c("control", "Treatment 1", "Treatment 2", "Treatment 1 \n and Treatment 2"),
                   expand = c(0, .5)) +
  # set range on OY axes and adjust the distance (gap) from OX axes
  scale_y_continuous(limits = c(0, 10), 
                     expand = c(0, 0)) +
  # Final adjustments:
  # set axis labels
  labs(x = "", 
       y = "Means") +
  theme_bw() + # eliminate default background 
  theme(panel.grid = element_blank(), # eliminate grids
        # set font family for all text within the plot ("serif" should work as "Times New Roman")
        # note that this can be overridden with other adjustment functions below
        text = element_text(family = "serif"),
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

# save as png
ggsave(filename = "gallery/barplot_ggplot_dodged_1.png",
       plot = my_barplot, 
       width = 12, height = 8, units = "cm", dpi = 75)
# save as pdf
ggsave(filename = "gallery/barplot_ggplot_dodged_1.pdf",
       plot = my_barplot, 
       width = 12, height = 8, units = "cm")