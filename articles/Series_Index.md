# Series Index

The following table shows the series available in the catalog (Last
update: **23-January-2026**).

Use the sequential number below to load a single series (see
[Example](#example)):

## Series index

## Example

For searching and extracting a specific series, see the full workflow:

``` r
library(tidyBdE)
library(tidyverse)

# GDP France
fr <- bde_catalog_search("Francia(.*)PIB")

# Show table on vignette
fr |>
  select(Numero_secuencial, Descripcion_de_la_serie) |>
  knitr::kable()
```

| Numero_secuencial | Descripcion_de_la_serie                                                                                                          |
|:------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| 2563958           | Economía internacional. Francia. AAPP. SEC2010. Capacidad (+) o necesidad (-) de financiación. Acum. 4 últimos trim. En % PIB pm |
| 2563918           | Economía internacional. Francia. PDE (SEC2010). AAPP. Deuda PDE. En % PIB pm                                                     |

``` r

# In this case we want to extract the first serie
# See tidyverse style

fr |>
  # Select id
  select(Numero_secuencial) |>
  # of first obs
  slice(1) |>
  # convert to number
  as.double() |>
  # And load it
  bde_series_load()
#> # A tibble: 119 × 2
#>    Date       `2563958`
#>    <date>         <dbl>
#>  1 1995-12-01      -5.1
#>  2 1996-03-01      NA  
#>  3 1996-06-01      NA  
#>  4 1996-09-01      NA  
#>  5 1996-12-01      -3.9
#>  6 1997-03-01      NA  
#>  7 1997-06-01      NA  
#>  8 1997-09-01      NA  
#>  9 1997-12-01      -3.6
#> 10 1998-03-01      NA  
#> # ℹ 109 more rows

# See the metadata
fr |>
  # Select id
  select(Numero_secuencial) |>
  # of first obs
  slice(1) |>
  # convert to number
  as.double() |>
  # And load the metadata
  bde_series_load(extract_metadata = TRUE) |>
  # To table on the vignette
  knitr::kable()
```

| Date                        | 2563958                                                                                                                          |
|:----------------------------|:---------------------------------------------------------------------------------------------------------------------------------|
| CÓDIGO DE LA SERIE          | DTNSEC2010_S0000P_APU_FR                                                                                                         |
| NÚMERO SECUENCIAL           | 2563958                                                                                                                          |
| ALIAS DE LA SERIE           | BE_1_6.8                                                                                                                         |
| DESCRIPCIÓN DE LA SERIE     | Economía internacional. Francia. AAPP. SEC2010. Capacidad (+) o necesidad (-) de financiación. Acum. 4 últimos trim. En % PIB pm |
| DESCRIPCIÓN DE LAS UNIDADES | Porcentaje                                                                                                                       |
| FRECUENCIA                  | TRIMESTRAL                                                                                                                       |
