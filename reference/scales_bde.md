# BdE color scales

Color scales for [ggplot2](https://CRAN.R-project.org/package=ggplot2).
Discrete scales are named `scale_*_bde_d`, while continuous scales are
named `scale_*_bde_c`.

## Usage

``` r
scale_color_bde_d(
  palette = c("bde_vivid_pal", "bde_rose_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE,
  ...
)

scale_fill_bde_d(
  palette = c("bde_vivid_pal", "bde_rose_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE,
  ...
)

scale_color_bde_c(
  palette = c("bde_rose_pal", "bde_vivid_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE,
  guide = "colorbar",
  ...
)

scale_fill_bde_c(
  palette = c("bde_rose_pal", "bde_vivid_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE,
  guide = "colorbar",
  ...
)
```

## Arguments

- palette:

  BdE palette to apply. See
  [`bde_tidy_palettes()`](https://ropenspain.github.io/tidyBdE/reference/bde_tidy_palettes.md)
  for details.

- alpha:

  Alpha transparency level in the range `[0, 1]`, where `0` is
  transparent and `1` is opaque. If `alpha = NULL`, the function does
  not append opacity codes (`"FF"`) to individual color hex codes. See
  [`ggplot2::alpha()`](https://scales.r-lib.org/reference/alpha.html).

- rev:

  Logical. If `TRUE`, reverse the color order.

- ...:

  Additional arguments passed to
  [`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html)
  or
  [`ggplot2::continuous_scale()`](https://ggplot2.tidyverse.org/reference/continuous_scale.html).

- guide:

  A function used to create a guide or its name. See
  [`guides()`](https://ggplot2.tidyverse.org/reference/guides.html) for
  more information.

## Value

A [ggplot2](https://CRAN.R-project.org/package=ggplot2) scale object.

## See also

[`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html)
and
[`ggplot2::continuous_scale()`](https://ggplot2.tidyverse.org/reference/continuous_scale.html)
for the underlying scale constructors.

Plotting functions:
[`bde_tidy_palettes()`](https://ropenspain.github.io/tidyBdE/reference/bde_tidy_palettes.md),
[`theme_tidybde()`](https://ropenspain.github.io/tidyBdE/reference/theme_tidybde.md)

## Examples

``` r
library(ggplot2)

set.seed(596)
txsamp <- subset(
  txhousing,
  city %in% c(
    "Houston", "Fort Worth",
    "San Antonio", "Dallas", "Austin"
  )
)

ggplot(txsamp, aes(x = sales, y = median)) +
  geom_point(aes(colour = city)) +
  scale_color_bde_d() +
  theme_minimal()


ggplot(txsamp, aes(x = sales, y = median)) +
  geom_point(aes(colour = city)) +
  scale_color_bde_d("bde_qual_pal") +
  theme_minimal()
```
