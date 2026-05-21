# tidyBdE 0.6.1

- Improve reading of external `.csv` files by detecting file encoding with
  `readr::guess_encoding()`.
- Package documentation was reviewed and updated with AI-assisted editing.

# tidyBdE 0.6.0

- Migrate vignettes to Quarto.
- Update the series code used by `bde_ind_cpi_var()` (see `?bde_ind_db`).

# tidyBdE 0.5.0

- Improve documentation with AI-assisted review.
- Update the minimum required **R** version to `4.1.0`.

# tidyBdE 0.4.0

- `?bde_indicators` is now based on data from the new `?bde_ind_db` database,
  which clarifies the underlying series identifiers and makes maintenance
  easier.

# tidyBdE 0.3.8

- Update `bde_ind_gdp_quarterly()` because the underlying identifier changed.

# tidyBdE 0.3.7

- DOI changed to the **CRAN** URL:
  <https://doi.org/10.32614/CRAN.package.tidyBdE>.
- Native encoding when reading `.csv` files changed to `"latin1"`.
- Update `bde_ind_unemployment_rate()` and `bde_ind_population()` because the
  underlying identifiers changed.

# tidyBdE 0.3.6

- Adapt `scale_color_bde_d()` and related functions to **ggplot2** 3.5.0,
  exposing the `guide` argument instead of hard-coding it.

# tidyBdE 0.3.5

Mainly changes to the color functions:

- Add the new `bde_qual_pal` palette.
- `bde_vivid_pal()` and `bde_rose_pal()` have been superseded. Use
  `bde_tidy_palettes()` instead.
- `scale_color_bde_d()` and related functions now use `bde_tidy_palettes()` and
  gain two new arguments: `alpha` and `rev`.
- Update and review documentation.

# tidyBdE 0.3.4

- Update API entry points.

# tidyBdE 0.3.3

- Update tests and documentation.

# tidyBdE 0.3.2

- Indicators: `bde_ind_ibex()` was renamed to `bde_ind_ibex_monthly()`.
- Indicators: Add the new `bde_ind_ibex_daily()` indicator.
- Remove **tidyverse** from Suggests.

# tidyBdE 0.3.1

- Add **tidyr** as a new dependency.
- Add the `out_format` parameter to `bde_series_load()`.
- Apply best practices and small adjustments to `theme_tidybde()`.

# tidyBdE 0.3.0

- **Breaking change**: `theme_bde()` was renamed to `theme_tidybde()`.
- Improve file downloading by removing empty local CSV files when URLs are not
  reachable, improving the download process, providing more informative user
  messages and making internal performance improvements.

# tidyBdE 0.2.5

- Update HTML5 markup to satisfy the **CRAN** request.

# tidyBdE 0.2.4

- Update the series code used by `bde_ind_cpi_var()`.

# tidyBdE 0.2.3

- Update the package because the **CF** (Financial Accounts of the Spanish
  Economy) and **IE** (Economic Indicators) catalogs were deprecated in the API.

# tidyBdE 0.2.2

- BdE started migrating "Indicadores Económicos" (Economic Indicators) series to
  the Statistical Bulletin. Some series in `?bde_indicators` are likely to break
  during the transition. So far, `bde_ind_euribor_12m_monthly()` has been
  updated to use the new series code `587853`. See
  <https://www.bde.es/wbe/en/estadisticas/>.
- Update documentation and examples.

# tidyBdE 0.2.1

- `bde_series_load()` now tries to coerce characters to numeric values.
- Export `bde_check_access()`.
- Improve messages when inconsistencies occur between the catalog and series.
- Update documentation and vignettes.

# tidyBdE 0.2.0

- Add a series index article.
- Add new series: `bde_ind_gdp_quarterly()` and `bde_ind_population()`.
- Improve package coverage and documentation.
- Move tests to **testthat**.
- Remove the following scales: `bde_scale_colour_vivid()`,
  `bde_scale_color_vivid()`, `bde_scale_fill_vivid()`,
  `bde_scale_colour_rose()`, `bde_scale_color_rose()` and
  `bde_scale_fill_rose()`. Use `scale_color_bde_c()` instead.

# tidyBdE 0.1.2

- Improve error handling according to **CRAN** rules.
- Precompile the vignette.
- Update examples.

# tidyBdE 0.1.1

- Add a DOI: <https://doi.org/10.5281/zenodo.4673496>.
- Add the package vignette.
- Add new palettes for **ggplot2**: `scale_color_bde_c()`,
  `scale_color_bde_d()`, `scale_fill_bde_c()` and `scale_fill_bde_d()`.
- Adjust colors in `bde_rose_pal()`: the HCL spectrum is now more consistent
  between roses and blues according to `colorspace::specplot()`.
- Deprecate scales: `bde_scale_colour_vivid()`, `bde_scale_color_vivid()`,
  `bde_scale_fill_vivid()`, `bde_scale_colour_rose()`, `bde_scale_color_rose()`
  and `bde_scale_fill_rose()`.

# tidyBdE 0.1.0

- Initial release.
