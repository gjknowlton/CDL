
# testing FIA data 

# load in packages

library(tidyverse)
library(rFIA)
library(gganimate)
library(sf)

# load in FIA data for MI

fiaMI <- readFIA(dir = '../../../PhD/Chapters/upperGL/inputs/fia/MI_CSV/',
        common = TRUE)
fiaMI_MR <- clipFIA(fiaMI, mostRecent = TRUE) 
tpaMI_MR <- tpa(fiaMI_MR)
head(tpaMI_MR)

tpaMI <- tpa(fiaRI)
head(tpaMI)

# Group estimates by species
tpaMI_species <- tpa(fiaMI_MR, bySpecies = TRUE)
head(tpaMI_species, n = 3)

# Group estimates by size class
# NOTE: Default 2-inch size classes, but you can make your own using makeClasses()
tpaMI_sizeClass <- tpa(fiaMI_MR, bySizeClass = TRUE)
head(tpaMI_sizeClass, n = 3)

# Group by species and size class, and plot the distribution 
# for the most recent inventory year
tpaMI_spsc <- tpa(fiaMI_MR, bySpecies = TRUE, bySizeClass = TRUE)
plotFIA(tpaRI_spsc, BAA, grp = COMMON_NAME, x = sizeClass,
        plot.title = 'Size-class distributions of BAA by species', 
        x.lab = 'Size Class (inches)', text.size = .75,
        n.max = 5) # Only want the top 5 species, try n.max = -5 for bottom 5

# Group estimates by species
tpaMI_species <- tpa(fiaMI_MR, bySpecies = TRUE)
head(tpaMI_species, n = 3)
#> # A tibble: 3 × 11
#>    YEAR  SPCD COMMON_NAME          SCIENTIFIC_NAME      TPA    BAA TPA_SE BAA_SE
#>   <dbl> <dbl> <chr>                <chr>              <dbl>  <dbl>  <dbl>  <dbl>
#> 1  2018    12 balsam fir           Abies balsamea    0.0873 0.0295  114.   114. 
#> 2  2018    43 Atlantic white-cedar Chamaecyparis th… 0.247  0.180    59.1   56.0
#> 3  2018    68 eastern redcedar     Juniperus virgin… 1.14   0.138    64.8   67.5
#> # ℹ 3 more variables: nPlots_TREE <int>, nPlots_AREA <int>, N <int>

# Group estimates by size class
# NOTE: Default 2-inch size classes, but you can make your own using makeClasses()
tpaMI_sizeClass <- tpa(fiaMI_MR, bySizeClass = TRUE)
head(tpaMI_sizeClass, n = 3)
#> # A tibble: 3 × 9
#>    YEAR sizeClass   TPA   BAA TPA_SE BAA_SE nPlots_TREE nPlots_AREA     N
#>   <dbl>     <dbl> <dbl> <dbl>  <dbl>  <dbl>       <int>       <int> <int>
#> 1  2018         1 188.   3.57  13.0   12.8           76         127   199
#> 2  2018         3  68.6  5.76  15.1   15.8           46         127   199
#> 3  2018         5  46.5  9.06   6.51   6.57         115         127   199

# Group by species and size class, and plot the distribution 
# for the most recent inventory year
tpaMI_spsc <- tpa(fiaMI_MR, bySpecies = TRUE, bySizeClass = TRUE)
plotFIA(tpaMI_spsc, BAA, grp = COMMON_NAME, x = sizeClass,
        plot.title = 'Size-class distributions of BAA by species', 
        x.lab = 'Size Class (inches)', text.size = .75,
        n.max = 5) # Only want the top 5 species, try n.max = -5 for bottom 5

# Load the county boundaries for Rhode Island. You can load your own spatial 
# data using functions in sf

#data('countiesRI')

syl <- st_read('gis/ottawa/Sylvania/Sylvania.shp', stringsAsFactors = F) # load in the sylvania boundary

# polys specifies the polygons (zones) where you are interested in producing estimates.
# returnSpatial = TRUE indicates that the resulting estimates will be joined with the 
# polygons we specified, thus allowing us to visualize the estimates across space
tpaMI_syl <- tpa(fiaMI_MR, polys = syl, returnSpatial = TRUE)

plotFIA(tpaMI_syl, BAA) # Plotting method for spatial FIA summaries, also try 'TPA' or 'TPA_PERC'

# Using the full FIA data set, all available inventories
tpaMI_st <- tpa(fiaMI, polys = syl, bySpecies = TRUE, returnSpatial = TRUE)

# Animate the output
library(gganimate)
plotFIA(tpaMI_st, TPA, animate = TRUE, legend.title = 'Abundance (TPA)', 
        legend.height = .8)
