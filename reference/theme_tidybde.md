# BdE [ggplot2](https://CRAN.R-project.org/package=ggplot2) theme

A custom [ggplot2](https://CRAN.R-project.org/package=ggplot2) theme
based on the publications of BdE.

## Usage

``` r
theme_tidybde(...)
```

## Arguments

- ...:

  Arguments passed on to
  [`ggplot2::theme_classic`](https://ggplot2.tidyverse.org/reference/ggtheme.html)

  `base_size`

  :   base font size, given in pts.

  `base_family`

  :   base font family

  `header_family`

  :   font family for titles and headers. The default, `NULL`, uses
      theme inheritance to set the font. This setting affects axis
      titles, legend titles, the plot title and tag text.

  `base_line_size`

  :   base size for line elements

  `base_rect_size`

  :   base size for rect elements

  `ink,paper,accent`

  :   colour for foreground, background, and accented elements
      respectively.

## Value

A [ggplot2](https://CRAN.R-project.org/package=ggplot2)
[`theme()`](https://ggplot2.tidyverse.org/reference/theme.html).

## Details

Theme based on
[`ggplot2::theme_classic()`](https://ggplot2.tidyverse.org/reference/ggtheme.html).

## See also

[`ggplot2::theme_classic()`](https://ggplot2.tidyverse.org/reference/ggtheme.html)

Other bde_plot:
[`bde_tidy_palettes()`](https://ropenspain.github.io/tidyBdE/reference/bde_tidy_palettes.md),
[`scales_bde`](https://ropenspain.github.io/tidyBdE/reference/scales_bde.md)

## Examples

``` r
# \donttest{
library(ggplot2)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(tidyr)

series_TC <- bde_series_full_load("TC_1_1.csv")

# If download was OK then plot
if (nrow(series_TC) > 0) {
  series_TC <- series_TC[c(1, 2)]

  series_TC_pivot <- series_TC |>
    filter(
      Date >= "2020-01-01" & Date <= "2020-12-31",
      !is.na(series_TC[[2]])
    )

  names(series_TC_pivot) <- c("x", "y")

  ggplot(series_TC_pivot, aes(x = x, y = y)) +
    geom_line(linewidth = 0.8, color = bde_tidy_palettes(n = 1)) +
    labs(
      title = "Title",
      subtitle = "Some metric",
      caption = "Bank of Spain"
    ) +
    theme_tidybde()
}

# }
```
