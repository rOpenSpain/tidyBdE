# Main macroeconomic indicators

This article shows selected Spanish macroeconomic indicators using Banco
de España data.

Last updated: **11-June-2026**.

``` r

library(tidyBdE)
library(ggplot2)
library(dplyr)
library(tidyr)

# Set plot parameters and the date range.
col <- bde_tidy_palettes(1, "bde_rose_pal")
date <- Sys.Date()
ny <- as.numeric(format(date, format = "%Y")) - 6
nd <- as.Date(paste0(ny, "-12-31"))

br <- seq(nd, Sys.Date(), "6 months")
```

## GDP of Spain

### Aggregated over the last four quarters

![](mainseries_files/figure-html/fig-gdp_agg-1.png)

Figure 1: GDP of Spain — aggregated over the last four quarters

### Year-on-year variation

![](mainseries_files/figure-html/fig-gdpyoy-1.png)

Figure 2: GDP of Spain — year-on-year variation

### GDP per capita

![](mainseries_files/figure-html/fig-gdppercap-1.png)

Figure 3: GDP per capita of Spain

## Unemployment rate

![](mainseries_files/figure-html/fig-unempl-1.png)

Figure 4: Unemployment rate

## Consumer price index

![](mainseries_files/figure-html/fig-cprix-1.png)

Figure 5: Consumer price index

## Monthly Euribor

![](mainseries_files/figure-html/fig-eur-1.png)

Figure 6: 12-month Euribor (monthly)

## Population

![](mainseries_files/figure-html/fig-pop-1.png)

Figure 7: Population (thousands)
