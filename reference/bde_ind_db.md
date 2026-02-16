# Database of selected macroeconomic indicators

Minimal metadata of the selected macroeconomic indicators included in
helper functions of
[tidyBdE](https://CRAN.R-project.org/package=tidyBdE) (see
[bde_indicators](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)).
Full metadata can be accessed via
[`bde_catalog_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_load.md)

## Format

A [tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) of
9 rows and 7 columns with the following fields:

- tidyBdE_fun:

  Function name, see
  [bde_indicators](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md).

- Numero_secuencial:

  Series code, see
  [`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_load.md).

- Descripcion_de_la_serie:

  Description of the series in Spanish.

- Fecha_de_la_primera_observacion:

  Starting date of the indicator.

- Fecha_de_la_ultima_observacion:

  Most recent date available.

- Fuente:

  Data source.

## Details

|                             |                       |                                                                                                                                                                                                                                               |                            |                                     |                                    |                                                            |
|-----------------------------|-----------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------|-------------------------------------|------------------------------------|------------------------------------------------------------|
| **tidyBdE_fun**             | **Numero_secuencial** | **Descripcion_de_la_serie**                                                                                                                                                                                                                   | **Frecuencia_de_la_serie** | **Fecha_de_la_primera_observacion** | **Fecha_de_la_ultima_observacion** | **Fuente**                                                 |
| bde_ind_cpi_var             | 1489713               | Estadísticas Generales. IPCA. Base 2015. Índice general. Tasa interanual. España                                                                                                                                                              | MENSUAL                    | 1993-01-01                          | 2025-12-01                         | Eurostat                                                   |
| bde_ind_euribor_12m_daily   | 905842                | Tipo de interés. UEM. Mercado monetario. Euríbor. A 12 meses                                                                                                                                                                                  | LABORABLE                  | 2000-01-03                          | 2026-02-13                         | REFINITIV                                                  |
| bde_ind_euribor_12m_monthly | 587853                | Tipo de interés. UEM. Mercado monetario. Euríbor. A 12 meses                                                                                                                                                                                  | MENSUAL                    | 1999-01-01                          | 2026-01-01                         | The European Money Market Institute (EMMI)                 |
| bde_ind_gdp_quarterly       | 4663160               | Estadísticas Generales. Cuentas Nacionales. SEC2010. Año base 2020. Precios corrientes. Producto interior bruto. Economía en su conjunto (Total de la economía) (Saldo). Datos corregidos de efectos estacionales y de calendario. TRIMESTRAL | TRIMESTRAL                 | 1995-03-01                          | 2025-12-01                         | Instituto Nacional de Estadistica                          |
| bde_ind_gdp_var             | 4663788               | Estadísticas Generales. CNTR. Base 2020. PIB. Precios constantes. Datos CVEC. Tasa interanual. España                                                                                                                                         | TRIMESTRAL                 | 1996-03-01                          | 2025-12-01                         | Eurostat                                                   |
| bde_ind_ibex_daily          | 821340                | Cotización y contratación. Acciones. Sociedad de Bolsas y Sociedad Rectora de la Bolsa de Madrid. Índice cotización. Indice IBEX 35                                                                                                           | LABORABLE                  | 1999-01-04                          | 2026-02-13                         | Bolsa de Madrid y Comisión Nacional del Mercado de Valores |
| bde_ind_ibex_monthly        | 254433                | Cotización y contratación. Acciones. Sociedad de Bolsas y Sociedad Rectora de la Bolsa de Madrid. Índice cotización. Indice IBEX 35                                                                                                           | MENSUAL                    | 1987-01-01                          | 2025-12-01                         | SOCIEDAD RECTORA DE LA BOLSA DE MADRID                     |
| bde_ind_population          | 4637737               | Estadísticas generales. INE. EPA. Base 2021. Total Nacional. Ambos sexos. Todas las edades. Personas. Trimestral                                                                                                                              | TRIMESTRAL                 | 2002-03-01                          | 2025-09-01                         | Instituto Nacional de Estadística                          |
| bde_ind_unemployment_rate   | 4635980               | Estadísticas Generales. EPA. Base 2021. Total Nacional. Tasa de paro de la población. Ambos sexos. 16 y más años                                                                                                                              | TRIMESTRAL                 | 2002-03-01                          | 2025-12-01                         | Instituto Nacional de Estadística                          |

## See also

Other indicators:
[`bde_indicators`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)

## Examples

``` r
data("bde_ind_db")
bde_ind_db
#> # A tibble: 9 × 7
#>   tidyBdE_fun    Numero_secuencial Descripcion_de_la_se…¹ Frecuencia_de_la_serie
#>   <chr>          <chr>             <chr>                  <chr>                 
#> 1 bde_ind_cpi_v… 1489713           "Estadísticas General… MENSUAL               
#> 2 bde_ind_eurib… 905842            "Tipo de interés. UEM… LABORABLE             
#> 3 bde_ind_eurib… 587853            "Tipo de interés. UEM… MENSUAL               
#> 4 bde_ind_gdp_q… 4663160           "Estadísticas General… TRIMESTRAL            
#> 5 bde_ind_gdp_v… 4663788           "Estadísticas General… TRIMESTRAL            
#> 6 bde_ind_ibex_… 821340            "Cotización y contrat… LABORABLE             
#> 7 bde_ind_ibex_… 254433            "Cotización y contrat… MENSUAL               
#> 8 bde_ind_popul… 4637737           "Estadísticas general… TRIMESTRAL            
#> 9 bde_ind_unemp… 4635980           "Estadísticas General… TRIMESTRAL            
#> # ℹ abbreviated name: ¹​Descripcion_de_la_serie
#> # ℹ 3 more variables: Fecha_de_la_primera_observacion <date>,
#> #   Fecha_de_la_ultima_observacion <date>, Fuente <chr>
```
