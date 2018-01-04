###############################################################################
# base R plot: Example of lineplot with inwards ticks.
###############################################################################

# =============================================================================
# Create fake data
# =============================================================================
set.seed(1)
DF <- data.frame(year = c(2000:2020),
                 mean = rnorm(n = 21, mean = 100, sd = 10))

# =============================================================================
# Helper functions
# =============================================================================
# Function to convert from cm to lines units
cm2line <- function(x) {
  lh <- par('cin')[2] * par('cex') * par('lheight')
  inch <- x/2.54
  inch/lh
}

# Function to return a desired sequence breaks along axes
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
# Open graphic device with desired parameters
png(filename = "gallery/lineplot_inwards_ticks_base_R_plot.png",
    width = 590, height = 472, units = "px", 
    family = "serif", pointsize = 8)
# family="serif" refers to the font family (here: Times New Roman).
# Check this link for some family fonts: http://www.statmethods.net/advgraphs/parameters.html
# pointsize = 8 refers to the point size used, here (Times New Roman) 8

# Adjust plotting region
par(mai = c(0.9/2.54, 1.2/2.54, 0.1/2.54, 0.1/2.54))
# mai  - adjust margins of plotting region (Bottom, Left, Top, Right)
# X[cm]/2.54 = inch (or give directly inch values)

# Get min-max values from data
OX.min <- floor(min(DF$year))
OX.max <- ceiling(max(DF$year))
OY.min <- floor(min(DF$mean))
OY.max <- ceiling(max(DF$mean))

# Plot empty frame
plot(x = DF$year, y = DF$mean,
     xlab = "", xlim = c(OX.min, OX.max),
     ylab = "", ylim = c(OY.min, OY.max),
     xaxt = "n", yaxt = "n", type = "n")

# Add two vertical lines
abline(v = c(2010,2013), lty = "dashed", lwd = 2, col = "gray")

# Add the points
points(x = DF$year, y = DF$mean,
       xlab = "", xlim = c(OX.min, OX.max),
       ylab = "", ylim = c(OY.min, OY.max),
       type = "b", lty = "solid", cex = 1, pch = 21, bg = "black",
       las = 1, font.lab = 2, cex.lab = 10/8, xaxt = "n", yaxt = "n")

# Create custom OX axis
labels.X <- my.breaks(DF$year, step = 5)
axis(side = 1, at = labels.X, labels = FALSE, tck = 0.02)

# Position OX labels
text(x = labels.X, y = OY.min-1.5, labels = labels.X, pos = 1, xpd = TRUE)
# x & y are graph coordinates (not cm!)
# x- value : adjusting for labels OX positions

# Set the title of OX axis at x cm outwards from the plot edge - the one set with par(mai=...) above
title(xlab = "Year", line = cm2line(0.55), font.lab = 2, cex.lab = 10/8)

# Create custom OY axis
labels.Y <- my.breaks(DF$mean, step = 10)
axis(side = 2, at = labels.Y, labels = FALSE, tck = 0.02)

# Position OY labels
text(x = OX.min - 1.5, y = labels.Y, labels = labels.Y, xpd = TRUE)
# x & y are graph coordinates (not cm!)
# x- value : adjusting for labels OX positions

# Set the title of OY axis at x cm outwards from the plot edge - the one set with par(mai=...) above
title(ylab = "Means", line = cm2line(0.75), font.lab = 2, cex.lab = 10/8)

# Close the device
dev.off()