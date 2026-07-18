# Database of selected Spanish macroeconomic indicators

Minimal metadata for the selected Spanish macroeconomic indicators
available through the convenience functions in this package. See
[indicator
wrappers](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md).
Full catalog metadata is available with
[`bde_catalog_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalogs.md).

## Format

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) of 9 rows
and 8 columns with the following fields:

- tidyBdE_fun:

  Function name. See [indicator
  wrappers](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md).

- Numero_secuencial:

  Sequential number. See
  [`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series.md).

- Nombre_de_la_serie:

  API series code. See [API series
  functions](https://ropenspain.github.io/tidyBdE/reference/bde_series_api.md).

- Descripcion_de_la_serie:

  Description of the series in Spanish.

- Fecha_de_la_primera_observacion:

  First observation date of the indicator.

- Fecha_de_la_ultima_observacion:

  Most recent date available.

- Fuente:

  Data source.

## Details

|  |  |  |  |  |  |  |  |
|----|----|----|----|----|----|----|----|
| **tidyBdE_fun** | **Numero_secuencial** | **Nombre_de_la_serie** | **Descripcion_de_la_serie** | **Frecuencia_de_la_serie** | **Fecha_de_la_primera_observacion** | **Fecha_de_la_ultima_observacion** | **Fuente** |
| bde_ind_cpi_var | 1489713 | DPU1NEAC920 | Estadísticas Generales. IPCA. Base 2015. Índice general. Tasa interanual. España | MENSUAL | 1997-01-01 | 2026-05-01 | Eurostat |
| bde_ind_euribor_12m_daily | 905842 | DPUDNBAF172 | Tipo de interés. UEM. Mercado monetario. Euríbor. A 12 meses | LABORABLE | 2000-01-03 | 2026-06-18 | REFINITIV |
| bde_ind_euribor_12m_monthly | 587853 | D_1NBAF472 | Tipo de interés. UEM. Mercado monetario. Euríbor. A 12 meses | MENSUAL | 1999-01-01 | 2026-05-01 | The European Money Market Institute (EMMI) |
| bde_ind_gdp_quarterly | 4663160 | DSPC102020CB1QB00_SS1_TSC.T | Estadísticas Generales. Cuentas Nacionales. SEC2010. Año base 2020. Precios corrientes. Producto interior bruto. Economía en su conjunto (Total de la economía) (Saldo). Datos corregidos de efectos estacionales y de calendario. TRIMESTRAL | TRIMESTRAL | 1995-03-01 | 2026-03-01 | Instituto Nacional de Estadistica |
| bde_ind_gdp_var | 4663788 | DSPC102020VB1QB00_SS1_TSCTVA.T | Estadísticas Generales. CNTR. Base 2020. PIB. Precios constantes. Datos CVEC. Tasa interanual. España | TRIMESTRAL | 1996-03-01 | 2026-03-01 | Eurostat |
| bde_ind_ibex_daily | 821340 | DBLEESI100000000IBDI.B | Cotización y contratación. Acciones. Sociedad de Bolsas y Sociedad Rectora de la Bolsa de Madrid. Índice cotización. Indice IBEX 35 | LABORABLE | 1999-01-04 | 2026-06-18 | Bolsa de Madrid y Comisión Nacional del Mercado de Valores |
| bde_ind_ibex_monthly | 254433 | D_1TGC000A | Cotización y contratación. Acciones. Sociedad de Bolsas y Sociedad Rectora de la Bolsa de Madrid. Índice cotización. Indice IBEX 35 | MENSUAL | 1987-01-01 | 2026-04-01 | SOCIEDAD RECTORA DE LA BOLSA DE MADRID |
| bde_ind_population | 4637737 | DEPA202110.T | Estadísticas generales. INE. EPA. Base 2021. Total Nacional. Ambos sexos. Todas las edades. Personas. Trimestral | TRIMESTRAL | 2002-03-01 | 2025-12-01 | Instituto Nacional de Estadística |
| bde_ind_unemployment_rate | 4635980 | DEPA202140_TSPA.T | Estadísticas Generales. EPA. Base 2021. Total Nacional. Tasa de paro de la población. Ambos sexos. 16 y más años | TRIMESTRAL | 2002-03-01 | 2026-03-01 | Instituto Nacional de Estadística |

## See also

[`vignette("csv_manual", package = "tidyBdE")`](https://ropenspain.github.io/tidyBdE/articles/csv_manual.md).

Selected indicators and metadata:
[`bde_indicators`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)

## Examples

``` r
data("bde_ind_db")
bde_ind_db
#> # A tibble: 9 × 8
#>   tidyBdE_fun        Numero_secuencial Nombre_de_la_serie Descripcion_de_la_se…¹
#>   <chr>              <chr>             <chr>              <chr>                 
#> 1 bde_ind_cpi_var    1489713           DPU1NEAC920        "Estadísticas General…
#> 2 bde_ind_euribor_1… 905842            DPUDNBAF172        "Tipo de interés. UEM…
#> 3 bde_ind_euribor_1… 587853            D_1NBAF472         "Tipo de interés. UEM…
#> 4 bde_ind_gdp_quart… 4663160           DSPC102020CB1QB00… "Estadísticas General…
#> 5 bde_ind_gdp_var    4663788           DSPC102020VB1QB00… "Estadísticas General…
#> 6 bde_ind_ibex_daily 821340            DBLEESI100000000I… "Cotización y contrat…
#> 7 bde_ind_ibex_mont… 254433            D_1TGC000A         "Cotización y contrat…
#> 8 bde_ind_population 4637737           DEPA202110.T       "Estadísticas general…
#> 9 bde_ind_unemploym… 4635980           DEPA202140_TSPA.T  "Estadísticas General…
#> # ℹ abbreviated name: ¹​Descripcion_de_la_serie
#> # ℹ 4 more variables: Frecuencia_de_la_serie <chr>,
#> #   Fecha_de_la_primera_observacion <date>,
#> #   Fecha_de_la_ultima_observacion <date>, Fuente <chr>
```
