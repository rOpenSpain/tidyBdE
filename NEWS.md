# tidyBdE 0.2.2

-   BdE starts migrating "Indicadores Económicos" (Economic Indicators) series
    to the Statistical Bulletin (more info
    [here](https://www.bde.es/bde/en/areas/estadis/otras-clasificac/estadisticas-por/junio-2021-0c825dfde7d3a71.html)).
    Some series on `bde_indicators()` are likely to be broken in the meantime.
    So far, these series has been updated:

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
-   Move tests to `testthat`.
-   The following scales have been removed: `bde_scale_colour_vivid()`,
    `bde_scale_color_vivid()`, `bde_scale_fill_vivid()`,
    `bde_scale_colour_rose()`, `bde_scale_color_rose()` `bde_scale_fill_rose()`.
    Use `scale_color_bde_c()` instead.

# tidyBdE 0.1.2

-   Precompile vignette.
-   Better handling of errors, according to CRAN rules.
-   Changed some examples.

# tidyBdE 0.1.1

-   Add vignette to package
-   Color adjustment on `bde_rose_pal()`: Now hcl spectrum is more consistent
    between roses and blues according to `colorspace::specplot()`.
-   Add DOI: <https://doi.org/10.5281/zenodo.4673496>
-   New palettes for `ggplot2`: `scale_color_bde_c()`, `scale_color_bde_d()`,
    `scale_fill_bde_c()`, `scale_fill_bde_d()`.
-   Deprecated scales: `bde_scale_colour_vivid()`, `bde_scale_color_vivid()`,
    `bde_scale_fill_vivid()`, `bde_scale_colour_rose()`,
    `bde_scale_color_rose()` `bde_scale_fill_rose()`.

# tidyBdE 0.1.0

-   Initial release.
