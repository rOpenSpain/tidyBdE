# BdE color palettes

Manually defined palettes based on BdE publications. Each palette
contains at most six colors.

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

  Number of colors (`>= 1`) to return.

- palette:

  A valid palette name.

- alpha:

  Alpha transparency level in the range `[0, 1]`, where `0` is
  transparent and `1` is opaque. If `alpha = NULL`, the function does
  not append opacity codes (`"FF"`) to individual color hex codes. See
  [`ggplot2::alpha()`](https://scales.r-lib.org/reference/alpha.html).

- rev:

  Logical. If `TRUE`, reverse the color order.

## Value

A character vector of hex color codes.

## See also

Plot utilities:
[`scales_bde`](https://ropenspain.github.io/tidyBdE/reference/scales_bde.md),
[`theme_tidybde()`](https://ropenspain.github.io/tidyBdE/reference/theme_tidybde.md)

## Examples

``` r
# Show the BdE vivid palette.
scales::show_col(bde_tidy_palettes(palette = "bde_vivid_pal"),
  labels = FALSE
)


# Show the BdE rose palette.
scales::show_col(bde_tidy_palettes(palette = "bde_rose_pal"),
  labels = FALSE
)


# Show the BdE qualitative palette.
scales::show_col(bde_tidy_palettes(palette = "bde_qual_pal"),
  labels = FALSE
)
```
