###############################################################################
# This is an example of plotting a barplot in base R
###############################################################################
# https://gist.github.com/valentinitnelav/d63a60b472f69fbcf713cf91451e6e20#file-create-a-barplot-for-publication-r

# =============================================================================
# create some dummy data
# =============================================================================
df <- structure(list(YEAR = c(2008L, 2008L, 2010L, 2010L, 2011L, 2011L, 2014L, 2014L),
                     SPECIES = c("LUCH", "LUTI", "LUCH", "LUTI", "LUCH", "LUTI", "LUCH", "LUTI"),
                     AVG = c(0.4, 0.8, 0.4, 0.6, 0.7, 0.6, 0.3, 0.4),
                     SE = c(0.06, 0.02, 0.04, 0.05, 0.03, 0.02, 0.04, 0.02)),
                row.names = c(NA, -8L), 
                class = "data.frame")
df

# prepare matrix for using in barplot() function
Means <- xtabs(AVG ~ SPECIES + YEAR, data = df)
# Note: returns xtabs-table , which is a sort of matrix that can be used directly in barplot()
Means

# =============================================================================
# Function to convert from given cm to lines of text (use it as such)
# =============================================================================
cm2line <- function(x) {
  lh <- par('cin')[2] * par('cex') * par('lheight')
  inch <- x/2.54
  inch/lh
}

# =============================================================================
# Plotting barplot
# =============================================================================

# Open a PNG device with desired parameters
png(filename = "gallery/barplot base R (1).png",
    width = 350, height = 250, units = "px",
    family = "Times", pointsize = 8)

# Example of PDF device with desired parameters
# pdf(file = "gallery/barplot base R (1).pdf",
#     width = 9/2.54, height = 7/2.54, 
#     family="Times", pointsize = 8)
# Since "width" and "height" need to be in inches, one can still use cm 
# and divide by 2.54 to make the conversion to inch.
# family="Times" refers to the font family (here: Times New Roman)
# check this link for some family fonts: http://www.statmethods.net/advgraphs/parameters.html
# pointsize = 8 refers to the point size used, here (Times New Roman) 8

# storing default par() for reverting later to default values
par.default <- par()

# Adjust margins of plotting region (Bottom, Left, Top, Right) : X[cm]/2.54 = inch
par(mai = c(0.9/2.54, 1.4/2.54, 0.15/2.54, 0.1/2.54))

bp <- barplot(height = Means, beside = TRUE,
              ylim = c(0, 1), las = 1, font.axis=1, font.lab=2,
              main = "", ylab = "Some proportion", xlab = "", cex.lab=10/8,
              border = "black", xaxt="n",
              legend.text = c("Species 1", "Species 2"),
              args.legend = list(x = "topright", text.font=3))
# color of bars were not adjusted - so R used default grayscale values
# bp object will store the centers of bars as coordinates on OX axis
# las = 1       perpendicular to the axis
#               0: always parallel to the axis [default],
#               1: always horizontal,
#               2: always perpendicular to the axis,
#               3: always vertical.
# font.axis=1   The font to be used for axis annotation (see font.lab below)
# font.lab=2    The font to be used for x and y labels.
#               1: plain text (the default), 
#               2: bold face, 
#               3: italic,
#               4: bold italic
# cex.lab=10/8  Will set the point size for axis labels 1.25 (10/8) bigger than the default given 
#               in the pdf device (pointsize = 8); So, cex.lab=10/8 means acutally point size 10
# xaxt="n"      supress OX axis
# args.legend = list(x = "topright", text.font=3)) passes arguments to legend:
#                  position (x="topright") and
#                  text.font=3 see the comments above for font.axis and font.lab

# Put a box arround the barplot
box()

# Position OX labels
text(x = (bp[1,] + bp[2,])/2, y =-0.02 , 
     labels = colnames(Means), adj = c(0.5,1), xpd = TRUE)
# x & y are graph coordinates (not cm!)
# x coord takes the bp averaged values. Will place the years below each pair of bars
# adj = c(0.5,1) - tweaks the alignment of text
# see a picture at http://nicercode.github.io/guides/plotting/pics/adj.png

# set the title of OX axis at 0.55 cm outwards from the plot edge 
# I refer to the plot edge set with par(mai = c(0.9/2.54, 1.4/2.54, 0.15/2.54, 0.1/2.54)) above
title(xlab="Year", line=cm2line(0.55), font.lab=2, cex.lab=10/8)

# Place letter A on top left corner (useful sometimes for panel graphs named with letters)
mtext("A", side = 1, line = cm2line(-5.7), at=1.05, font=2, cex=14/8, family="ArialMT")

# Function that puts error bars on barplot columns
error.bars <- function(x, y, se) {
  x <- as.vector(x)   # centers of bars on OX axis
  y <- as.vector(y)   # heights of bars (the means) on OY axis
  se <- as.vector(se) # standard errors
  for (i in 1:length(x))
    arrows(x[i], y[i]-se[i], x[i], y[i]+se[i], code=3, angle=90, length=0.1/2.54)
}
# call the function above to place error bars
error.bars(x=bp, y=Means, se=df$SE)

# return par to default values (par.default was saved previously)
# don't mind the warnings
par(par.default)
# close the device
dev.off()