**This document explains how the `Whittaker_biomes` data frame was constructed.**

Table of contents
=================

-   [Original graph](#Original_graph)
-   [Processing PDF](#PDF)
-   [Importing PostScript file in R with `grImport`](#grImport)
    -   [Read in the PostScript file](#ReadPS)
-   [Visualize and clean (subset) the "Picture" object](#picture)
-   [Get the PostScript coordinates from the cleaned "Picture" object](#PScoordinates)
-   [Convert PostScript coordinates into meaningful coordinates](#conversion_1)
    -   [Convert between coordinates systems](#conversion_2)
-   [Prepare Whittaker\_biomes data frame](#prepare)
    -   [Get the colors also](#colors)
-   [Examples](#examples)

<div id='Original_graph'/>
Original graph
--------------

The original graph is Figure 5.5 in *Ricklefs, R. E. (2008), The economy of nature. W. H. Freeman and Company.* (Chapter 5, Biological Communities, The biome concept).

<div id='PDF'/>
Processing PDF
--------------

A PDF page containing the Whittaker biomes graph was imported in [Inkscape](https://inkscape.org/en/). Text and extra graphic layers where removed and the remaining layers were exported as PostScipt file format (`File > Save As > Save as type: > PostScript (*.ps)`). Note that a multi-page PDF document can be split into component pages with [PDFTK Builder](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/) application.

<div id='grImport'/>
Importing PostScript file in R with `grImport`
----------------------------------------------

The main steps of importing PostsScipt in R are described in the [Importing vector graphics](https://cran.r-project.org/web/packages/grImport/vignettes/import.pdf) vignette: *Murrell, P. (2009). Importing vector graphics: The grImport package for R. Journal of Statistical Software, 30(4), 1-37.*

**In addition to installing package `grImport` with the usual `install.packages("grImport")`, [Ghostscript](https://www.ghostscript.com/download/) needs to be installed as well.**

<div id='ReadPS'/>
### Read in the PostScript file

Note: to avoid the ghostscript error 'status 127', the path to ghostscript executable file was given as suggested [here](https://stackoverflow.com/questions/35256501/windows-rgrimport-ghostscript-error-status-127#42393056)

``` r
require(grImport)
# Sys.setenv(R_GSCMD = normalizePath("C:/Program Files/gs/gs9.22/bin/gswin64c.exe"))
# Path to example PostScript file
path <- system.file("extdata", "graph_ps.ps", 
                    package = "plotbiomes", 
                    mustWork = TRUE)
# Path to output xml RGML file
RGML_xml_path <- gsub(pattern = "graph_ps.ps", 
                 replacement = "graph_ps.xml", 
                 x = path, 
                 fixed = TRUE)
# Converts a PostScript file into an RGML file
# PostScriptTrace(file = path,
#                 outfilename = RGML_xml_path,
#                 setflat = 1)
# setflat = 1 assures a visual smooth effect (feel free to experiment)

# Reads in the RGML file and creates a "Picture" object
# my_rgml <- readPicture(rgmlFile = RGML_xml_path)
```
