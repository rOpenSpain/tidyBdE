# Main macroeconomic series

This article shows the evolution of selected economic indicators of
Spain, based on information from [Banco de España](https://www.bde.es/).

Last update: **24-February-2026**.

``` r
library(tidyBdE)
library(ggplot2)
library(dplyr)
library(tidyr)

col <- bde_tidy_palettes(1, "bde_rose_pal")
date <- Sys.Date()
ny <- as.numeric(format(date, format = "%Y")) - 6
nd <- as.Date(paste0(ny, "-12-31"))

br <- seq(nd, Sys.Date(), "6 months")
```

## GDP of Spain

### Aggregated (last 4 quarters)

![](mainseries_files/figure-html/fig-gdp_agg-1.png)

Figure 1: GDP of Spain - Aggregated last 4 quarters

### Year-on-year variation

![](mainseries_files/figure-html/fig-gdpyoy-1.png)

Figure 2: GDP of Spain - Year-on-year variation

### GDP per capita

![](mainseries_files/figure-html/fig-gdppercap-1.png)

Figure 3: GDP per Capita of Spain

## Unemployment Rate

![](mainseries_files/figure-html/fig-unempl-1.png)

Figure 4: Unemployment rate

## Consumer Price Index

![](mainseries_files/figure-html/fig-cprix-1.png)

Figure 5: Consumer Price Index

## Monthly Euribor

![](mainseries_files/figure-html/fig-eur-1.png)

Figure 6: Monthly Euribor

## Population

![](mainseries_files/figure-html/fig-pop-1.png)

Figure 7: Population in thousands
