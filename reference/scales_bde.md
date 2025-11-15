# BdE scales for [ggplot2](https://CRAN.R-project.org/package=ggplot2)

Scales to be used with the
[ggplot2](https://CRAN.R-project.org/package=ggplot2) package. Discrete
palettes are named as `scale_*_bde_d` while continuous palettes are
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

  Name of the BdE palette to apply. See
  [`bde_tidy_palettes()`](https://ropenspain.github.io/tidyBdE/reference/bde_tidy_palettes.md)
  for details.

- alpha:

  An alpha-transparency level in the range `[0,1]` (`0` means
  transparent and `1` means opaque). A missing, i.e., `alpha = NULL`,
  does not add opacity codes (`"FF"`) to the individual color hex codes.
  See
  [`ggplot2::alpha()`](https://ggplot2.tidyverse.org/reference/reexports.html).

- rev:

  Logical indicating whether the ordering of the colors should be
  reversed.

- ...:

  Further arguments of
  [`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html)
  or
  [`ggplot2::continuous_scale()`](https://ggplot2.tidyverse.org/reference/continuous_scale.html).

- guide:

  A function used to create a guide or its name. See
  [`guides()`](https://ggplot2.tidyverse.org/reference/guides.html) for
  more information.

## Value

A [ggplot2](https://CRAN.R-project.org/package=ggplot2) color scale.

## See also

[`ggplot2::discrete_scale()`](https://ggplot2.tidyverse.org/reference/discrete_scale.html),
[`ggplot2::continuous_scale()`](https://ggplot2.tidyverse.org/reference/continuous_scale.html)

Other bde_plot:
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
