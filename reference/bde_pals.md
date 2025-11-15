# BdE superseded palettes

**\[superseded\]**

These functions have been superseded, see
[`bde_tidy_palettes()`](https://ropenspain.github.io/tidyBdE/reference/bde_tidy_palettes.md)
as a replacement.

Custom palettes based on the publications of BdE.

## Usage

``` r
bde_vivid_pal(...)

bde_rose_pal(...)
```

## Arguments

- ...:

  Further arguments of the functions.

## Value

A palette of colors.

## Examples

``` r
# BdE vivid pal
scales::show_col(bde_vivid_pal()(6), labels = FALSE)
#> Warning: `bde_vivid_pal()` was deprecated in tidyBdE 0.3.5.
#> ℹ Please use `bde_tidy_palettes()` instead.


# BdE rose pal
scales::show_col(bde_rose_pal()(6), labels = FALSE)
#> Warning: `bde_rose_pal()` was deprecated in tidyBdE 0.3.5.
#> ℹ Please use `bde_tidy_palettes()` instead.
```
