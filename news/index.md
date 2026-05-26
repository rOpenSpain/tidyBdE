# Changelog

## tidyBdE (development version)

- Internal code was refactored with AI assistance to reduce duplication
  in indicator wrappers and **ggplot2** scale helpers.
- Messages and package errors now use **cli**, with AI-assisted wording
  updates and without the former `tidyBdE>` prefix.
- Roxygen2 documentation was reviewed with AI assistance and tag order
  was made consistent across source files.
- Tests were refactored and expanded with local fixtures, mocks and
  snapshot updates, reaching 100% line coverage in
  `devtools:::test_coverage()`.

## tidyBdE 0.6.1

CRAN release: 2026-05-21

- Improve reading of external `.csv` files by detecting file encoding
  with
  [`readr::guess_encoding()`](https://readr.tidyverse.org/reference/encoding.html).
- Package documentation was reviewed and updated with AI-assisted
  editing.

## tidyBdE 0.6.0

CRAN release: 2026-03-23

- Migrate vignettes to Quarto.
- Update the series code used by
  [`bde_ind_cpi_var()`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)
  (see
  [`?bde_ind_db`](https://ropenspain.github.io/tidyBdE/reference/bde_ind_db.md)).

## tidyBdE 0.5.0

CRAN release: 2026-01-13

- Improve documentation with AI-assisted review.
- Update the minimum required **R** version to `4.1.0`.

## tidyBdE 0.4.0

CRAN release: 2025-06-22

- [`?bde_indicators`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)
  is now based on data from the new
  [`?bde_ind_db`](https://ropenspain.github.io/tidyBdE/reference/bde_ind_db.md)
  database, which clarifies the underlying series codes and makes
  maintenance easier.

## tidyBdE 0.3.8

CRAN release: 2024-12-20

- Update
  [`bde_ind_gdp_quarterly()`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)
  because the underlying identifier changed.

## tidyBdE 0.3.7

CRAN release: 2024-08-26

- DOI changed to the **CRAN** URL:
  <https://doi.org/10.32614/CRAN.package.tidyBdE>.
- Native encoding when reading `.csv` files changed to `"latin1"`.
- Update
  [`bde_ind_unemployment_rate()`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)
  and
  [`bde_ind_population()`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)
  because the underlying identifiers changed.

## tidyBdE 0.3.6

CRAN release: 2024-04-22

- Adapt
  [`scale_color_bde_d()`](https://ropenspain.github.io/tidyBdE/reference/scales_bde.md)
  and related functions to **ggplot2** 3.5.0, exposing the `guide`
  argument instead of hard-coding it.

## tidyBdE 0.3.5

CRAN release: 2024-01-29

Mainly changes to the color functions:

- Add the new `bde_qual_pal` palette.
- [`bde_vivid_pal()`](https://ropenspain.github.io/tidyBdE/reference/bde_pals.md)
  and
  [`bde_rose_pal()`](https://ropenspain.github.io/tidyBdE/reference/bde_pals.md)
  have been superseded. Use
  [`bde_tidy_palettes()`](https://ropenspain.github.io/tidyBdE/reference/bde_tidy_palettes.md)
  instead.
- [`scale_color_bde_d()`](https://ropenspain.github.io/tidyBdE/reference/scales_bde.md)
  and related functions now use
  [`bde_tidy_palettes()`](https://ropenspain.github.io/tidyBdE/reference/bde_tidy_palettes.md)
  and gain two new arguments: `alpha` and `rev`.
- Update and review documentation.

## tidyBdE 0.3.4

CRAN release: 2023-06-13

- Update API entry points.

## tidyBdE 0.3.3

CRAN release: 2023-05-25

- Update tests and documentation.

## tidyBdE 0.3.2

CRAN release: 2023-04-01

- Indicators:
  [`bde_ind_ibex()`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)
  was renamed to
  [`bde_ind_ibex_monthly()`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md).
- Indicators: Add the new
  [`bde_ind_ibex_daily()`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)
  indicator.
- Remove **tidyverse** from Suggests.

## tidyBdE 0.3.1

CRAN release: 2022-11-16

- Add **tidyr** as a new dependency.
- Add the `out_format` parameter to
  [`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_load.md).
- Apply best practices and small adjustments to
  [`theme_tidybde()`](https://ropenspain.github.io/tidyBdE/reference/theme_tidybde.md).

## tidyBdE 0.3.0

CRAN release: 2022-10-07

- **Breaking change**: `theme_bde()` was renamed to
  [`theme_tidybde()`](https://ropenspain.github.io/tidyBdE/reference/theme_tidybde.md).
- Improve file downloading by removing empty local CSV files when URLs
  are not reachable, improving the download process, providing more
  informative user messages and making internal performance
  improvements.

## tidyBdE 0.2.5

CRAN release: 2022-08-13

- Update HTML5 markup to satisfy the **CRAN** request.

## tidyBdE 0.2.4

CRAN release: 2022-02-23

- Update the series code used by
  [`bde_ind_cpi_var()`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md).

## tidyBdE 0.2.3

CRAN release: 2022-01-19

- Update the package because the **CF** (Financial Accounts of the
  Spanish Economy) and **IE** (Economic Indicators) catalogs were
  deprecated in the API.

## tidyBdE 0.2.2

CRAN release: 2021-10-29

- BdE started migrating “Indicadores Económicos” (Economic Indicators)
  series to the Statistical Bulletin. Some series in
  [`?bde_indicators`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)
  are likely to break during the transition. So far,
  [`bde_ind_euribor_12m_monthly()`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)
  has been updated to use the new series code `587853`. See
  <https://www.bde.es/wbe/en/estadisticas/>.
- Update documentation and examples.

## tidyBdE 0.2.1

CRAN release: 2021-10-07

- [`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_load.md)
  now tries to coerce characters to numeric values.
- Export
  [`bde_check_access()`](https://ropenspain.github.io/tidyBdE/reference/bde_check_access.md).
- Improve messages when inconsistencies occur between the catalog and
  series.
- Update documentation and vignettes.

## tidyBdE 0.2.0

CRAN release: 2021-08-04

- Add a series index article.
- Add new series:
  [`bde_ind_gdp_quarterly()`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)
  and
  [`bde_ind_population()`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md).
- Improve package coverage and documentation.
- Move tests to **testthat**.
- Remove the following scales: `bde_scale_colour_vivid()`,
  `bde_scale_color_vivid()`, `bde_scale_fill_vivid()`,
  `bde_scale_colour_rose()`, `bde_scale_color_rose()` and
  `bde_scale_fill_rose()`. Use
  [`scale_color_bde_c()`](https://ropenspain.github.io/tidyBdE/reference/scales_bde.md)
  instead.

## tidyBdE 0.1.2

CRAN release: 2021-07-07

- Improve error handling according to **CRAN** rules.
- Precompile the vignette.
- Update examples.

## tidyBdE 0.1.1

CRAN release: 2021-06-05

- Add a DOI: <https://doi.org/10.5281/zenodo.4673496>.
- Add the package vignette.
- Add new palettes for **ggplot2**:
  [`scale_color_bde_c()`](https://ropenspain.github.io/tidyBdE/reference/scales_bde.md),
  [`scale_color_bde_d()`](https://ropenspain.github.io/tidyBdE/reference/scales_bde.md),
  [`scale_fill_bde_c()`](https://ropenspain.github.io/tidyBdE/reference/scales_bde.md)
  and
  [`scale_fill_bde_d()`](https://ropenspain.github.io/tidyBdE/reference/scales_bde.md).
- Adjust colors in
  [`bde_rose_pal()`](https://ropenspain.github.io/tidyBdE/reference/bde_pals.md):
  the HCL spectrum is now more consistent between roses and blues
  according to `colorspace::specplot()`.
- Deprecate scales: `bde_scale_colour_vivid()`,
  `bde_scale_color_vivid()`, `bde_scale_fill_vivid()`,
  `bde_scale_colour_rose()`, `bde_scale_color_rose()` and
  `bde_scale_fill_rose()`.

## tidyBdE 0.1.0

CRAN release: 2021-04-08

- Initial release.
