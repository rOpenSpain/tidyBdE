# BdE color palettes

Custom palettes based on the publications of BdE. These are manual
palettes with a maximum of 6 colors.

## Usage

``` r
bde_tidy_palettes(
  n = 6,
  palette = c("bde_vivid_pal", "bde_rose_pal", "bde_qual_pal"),
  alpha = NULL,
  rev = FALSE
)
```

## Arguments

- n:

  The number of colors (`>= 1`) in the palette.

- palette:

  A valid palette name.

- alpha:

  An alpha-transparency level in the range `[0,1]` (`0` means
  transparent and `1` means opaque). A missing, i.e., `alpha = NULL`,
  does not add opacity codes (`"FF"`) to the individual color hex codes.
  See
  [`ggplot2::alpha()`](https://ggplot2.tidyverse.org/reference/reexports.html).

- rev:

  Logical indicating whether the ordering of the colors should be
  reversed.

## Value

A vector of colors.

## See also

Other bde_plot:
[`scales_bde`](https://ropenspain.github.io/tidyBdE/reference/scales_bde.md),
[`theme_tidybde()`](https://ropenspain.github.io/tidyBdE/reference/theme_tidybde.md)

## Examples

``` r
# BdE vivid pal
scales::show_col(bde_tidy_palettes(palette = "bde_vivid_pal"),
  labels = FALSE
)


# BdE rose pal
scales::show_col(bde_tidy_palettes(palette = "bde_rose_pal"),
  labels = FALSE
)


# BdE qual pal
scales::show_col(bde_tidy_palettes(palette = "bde_qual_pal"),
  labels = FALSE
)
```
