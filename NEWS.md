# tidyBdE (development version)

-   Now `bde_indicators` are based on the data of the new data base
    `bde_ind_db`, for more clarity on the underlying series identifiers and
    easier maintenance.

# tidyBdE 0.3.8

-   Update `bde_ind_gdp_quarterly()` since the underlying identifier changed.

# tidyBdE 0.3.7

-   Update `bde_ind_unemployment_rate()` and `bde_ind_population()` since the
    underlying identifier changed.
-   DOI changed to **CRAN** url:
    <https://doi.org/10.32614/CRAN.package.tidyBdE>.
-   Native encoding when reading the `.csv` files changed to `"latin1"`.

# tidyBdE 0.3.6

-   Adapt `scale_color_bde_d()` and friends to **ggplot2** 3.5.0. Also expose
    the `guide` argument instead of hard-coding it.

# tidyBdE 0.3.5

Mostly changes on the color functions:

-   `bde_vivid_pal()` and `bde_rose_pal()` have been superseded. Use the new
    function `bde_tidy_palettes()` instead.
-   `scale_color_bde_d()` and friends leverage now on `bde_tidy_palettes()`, and
    these functions gain two new arguments: `alpha` y `rev`.
-   Update and review documentation.
-   New palette named `bde_qual_pal`.

# tidyBdE 0.3.4

-   Update API entry points.

# tidyBdE 0.3.3

-   Update tests and documentation.

# tidyBdE 0.3.2

-   Remove **tidyverse** from Suggests.
-   On indicators:
    -   `bde_ind_ibex()` renamed to `bde_ind_ibex_monthly()`.
    -   New indicator `bde_ind_ibex_daily()`

# tidyBdE 0.3.1

-   Add new dependency: **tidyr**.
-   New parameter `out_format` on `bde_series_load()`.
-   Use best practices and small adjustments on `theme_tidybde()`.

# tidyBdE 0.3.0

-   Overall improvements on downloading files:
    -   On url not reachable, remove the local csv since it is empty.
    -   Improve download process.
    -   More informative messages for the final user.
    -   Internal performance improvements.
-   **Breaking change**: `theme_bde()` renamed to `theme_tidybde()`.

# tidyBdE 0.2.5

-   Update HTML5 due to **CRAN** request

# tidyBdE 0.2.4

-   Update series code on `bde_ind_cpi_var()`.

# tidyBdE 0.2.3

-   The followings catalogs has been deprecated on the API, package updated
    accordingly:
    -   **CF**: Financial Accounts of the Spanish Economy.
    -   **IE**: Economic Indicators

# tidyBdE 0.2.2

-   BdE starts migrating "Indicadores Económicos" (Economic Indicators) series
    to the Statistical Bulletin (more info
    [here](https://www.bde.es/wbe/en/estadisticas/)). Some series on
    `bde_indicators()` are likely to be broken in the meantime. So far, these
    series has been updated:
    -   `bde_ind_euribor_12m_monthly()`: New series code is `587853`.
-   Update docs and examples.

# tidyBdE 0.2.1

-   Update docs and vignettes.
-   `bde_series_load()` now tries to coerce characters to numeric.
-   Improve messages when inconsistencies between catalog and series.
-   Export `bde_check_access()`.

# tidyBdE 0.2.0

-   Add series index article.
-   Add new series: `bde_ind_gdp_quarterly()`, `bde_ind_population()`.
-   Improve package coverage and docs.
-   Move tests to **testthat**.
-   The following scales have been removed: `bde_scale_colour_vivid()`,
    `bde_scale_color_vivid()`, `bde_scale_fill_vivid()`,
    `bde_scale_colour_rose()`, `bde_scale_color_rose()` `bde_scale_fill_rose()`.
    Use `scale_color_bde_c()` instead.

# tidyBdE 0.1.2

-   Precompile vignette.
-   Better handling of errors, according to **CRAN** rules.
-   Changed some examples.

# tidyBdE 0.1.1

-   Add vignette to package
-   Color adjustment on `bde_rose_pal()`: Now hcl spectrum is more consistent
    between roses and blues according to `colorspace::specplot()`.
-   Add DOI: <https://doi.org/10.5281/zenodo.4673496>
-   New palettes for **ggplot2**: `scale_color_bde_c()`, `scale_color_bde_d()`,
    `scale_fill_bde_c()`, `scale_fill_bde_d()`.
-   Deprecated scales: `bde_scale_colour_vivid()`, `bde_scale_color_vivid()`,
    `bde_scale_fill_vivid()`, `bde_scale_colour_rose()`,
    `bde_scale_color_rose()` `bde_scale_fill_rose()`.

# tidyBdE 0.1.0

-   Initial release.
