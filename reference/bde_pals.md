# Superseded BdE palettes

**\[superseded\]**

These palettes are superseded. Use
[`bde_tidy_palettes()`](https://ropenspain.github.io/tidyBdE/reference/bde_tidy_palettes.md)
instead.

## Usage

``` r
bde_vivid_pal(...)

bde_rose_pal(...)
```

## Arguments

- ...:

  Additional arguments.

## Value

A color palette function.

## Examples

``` r
# Show the vivid palette.
scales::show_col(bde_vivid_pal()(6), labels = FALSE)
#> Warning: `bde_vivid_pal()` was deprecated in tidyBdE 0.3.5.
#> ℹ Please use `bde_tidy_palettes()` instead.


# Show the rose palette.
scales::show_col(bde_rose_pal()(6), labels = FALSE)
#> Warning: `bde_rose_pal()` was deprecated in tidyBdE 0.3.5.
#> ℹ Please use `bde_tidy_palettes()` instead.

```
