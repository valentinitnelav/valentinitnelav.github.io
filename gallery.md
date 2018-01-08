---
layout: page
title: Gallery
---

Here, I try to collect scripts from exploring with various graphs and data visualization methods. The coding style might differ from one graph to another depending on how I explored with new features, packages, etc., or on how I forgot to use them ... To access a script, simply click on the desired thumbnail.

[//]: # This is a comment in markdown: `[//]: #` 
[//]: # Each image (thumbnail) acts as a link to the script that generates it.
[//]: # In markdown, this is an image insertion (reference-style): `![img_id]` or `![img_id]{:width="300px"}` for setting the width.
[//]: # In markdown, this is a link that underlines the text/reference placed between []: `[][code_id]` 
[//]: # So, to link the image with its script, one can do: `[![img_id]][code_id]` or `[![img_id]{:width="300px"}][code_id]`


[//]: # ===============================================================================================================
# Maps
[//]: # ===============================================================================================================

[//]: # Table of graphs/images (in 3 columns)
[//]: # Set width or height of images with syntax like `{:width="300px"}`
[//]: # This works with `markdown: kramdown` as dependency in `_config.yml` file in repository.
[//]: # https://stackoverflow.com/questions/14675913/how-to-change-image-size-markdown#30973855

|                                       |                                         |
:-------------------------------------: | :-------------------------------------: | :-------------------------------------:
[![m1]{:width="300px"}][cm1]            | [![m2]{:width="300px"}][cm2]            | [![m3]{:width="300px"}][cm3]
tmap package: choropleth map            | ggplot2 & ggrepel: Eckert IV proj.      | ggplot2: Robinson projection
[![m4]{:width="300px"}][cm4]            | [![m5]{:width="300px"}][cm5]            |
ggplot2: Pacific centered world map     | Shift central (prime) meridian          |


[//]: # -----------------------------------------------------------------------
[//]: # Links to maps (m) and code (cm)
[//]: # -----------------------------------------------------------------------
[//]: # Note: URL-s could be also written with the `site.baseurl` variable: 
[//]: # `{{site.baseurl}}/gallery/Choropleth world map, HPI - tmap.png`
[//]: # but RStudio's will not recognize the variable for local preview.

[m1]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/Choropleth world map, HPI - tmap.png
[cm1]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/Choropleth%20world%20map%2C%20HPI%20-%20tmap.R

[m2]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/world cities map in Eckert IV ggplot & ggrepel.png
[cm2]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/world%20cities%20map%20in%20Eckert%20IV%20ggplot%20%26%20ggrepel.R

[m3]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/World map Robinson projection - ggplot.png
[cm3]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/World%20map%20Robinson%20projection%20-%20ggplot.R

[m4]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/Pacific centered world map with ggplot.png
[cm4]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/Pacific%20centered%20world%20map%20with%20ggplot.R

[m5]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/Shift central (prime) meridian.png
[cm5]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/Shift%20central%20(prime)%20meridian.R


[//]: # ===============================================================================================================
# Line and dot plots
[//]: # ===============================================================================================================

|                                       |                                         |
:-------------------------------------: | :-------------------------------------: | :-------------------------------------:
[![l1]{:width="300px"}][cl1]            | [![l2]{:width="300px"}][cl2]            | [![l3]{:width="300px"}][cl3]
ggplot2: colored confidence bands       | ggplot2: colored confidence bands       | ggplot2: dotplot with CIs
[![l4]{:width="300px"}][cl4]            | [![l5]{:width="300px"}][cl5]            | [![l6]{:width="300px"}][cl6]
ggplot2: simple confidence bands        | ggplot2: simple confidence lines        | ggplot2: lineplot, inwards ticks
[![l7]{:width="300px"}][cl7]            | |
base R: lineplot, inwards ticks         | |

[//]: # -----------------------------------------------------------------------
[//]: # Links to line & dot plots (l) and code (cl)
[//]: # -----------------------------------------------------------------------

[l1]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/colored_confidence_bands.png
[cl1]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/colored_confidence_bands.R

[l2]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/colored_confidence_lines.png
[cl2]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/colored_confidence_lines.R

[l3]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/dotplot_ci_bars.png
[cl3]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/dotplot_ci_bars.R

[l4]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/simple_confidence_bands.png
[cl4]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/simple_confidence_bands.R

[l5]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/simple_confidence_lines.png
[cl5]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/simple_confidence_lines.R

[l6]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/lineplot_inwards_ticks_ggplot.png
[cl6]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/lineplot_inwards_ticks_ggplot.R

[l7]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/lineplot_inwards_ticks_base_R_plot.png
[cl7]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/lineplot_inwards_ticks_base_R_plot.R

[//]: # ===============================================================================================================
# Barplots
[//]: # ===============================================================================================================

|                                       |                                         |
:-------------------------------------: | :-------------------------------------: | :-------------------------------------:
[![b1]{:width="300px"}][cb1]            | [![b2]{:width="300px"}][cb2]            | 
base R                                  | ggplot2                                 |


[//]: # -----------------------------------------------------------------------
[//]: # Links to barplots (b) and code (cb)
[//]: # -----------------------------------------------------------------------

[b1]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/barplot base R (1).png
[cb1]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/barplot_base_r_1.R

[b2]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/gallery/barplot_ggplot_dodged_1.png
[cb2]: https://github.com/valentinitnelav/valentinitnelav.github.io/blob/master/gallery/barplot_ggplot_dodged_1.R


[//]: # ===============================================================================================================
# Other
[//]: # ===============================================================================================================

|                                       |                                         |
:-------------------------------------: | :-------------------------------------: | :-------------------------------------:
[![o1]{:width="300px"}][co1]            | [![o2]{:width="300px"}][co2]            | 
base R                                  | ggplot2                                 |


[//]: # -----------------------------------------------------------------------
[//]: # Links to plots (o) and code (co)
[//]: # -----------------------------------------------------------------------

[b1]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/assets/2018-01-07-ggtree/tree_labeled.png
[cb1]: https://rawgit.com/valentinitnelav/valentinitnelav.github.io/master/assets/2018-01-07-ggtree/2018-01-07-ggtree.html

[b2]: https://raw.githubusercontent.com/valentinitnelav/valentinitnelav.github.io/master/assets/2018-01-07-ggtree/tree_labeled_bars.png
[cb2]: https://rawgit.com/valentinitnelav/valentinitnelav.github.io/master/assets/2018-01-07-ggtree/2018-01-07-ggtree.html