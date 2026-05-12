# Series index

This table lists the available series in the catalog (last updated:
**12-May-2026**).

Use the sequential number to load a single series, as shown in the
example.

## Summary

## Example

Workflow for searching and extracting a specific series:

``` r

library(tidyBdE)
library(tidyverse)

# Search for French GDP.
fr <- bde_catalog_search("Francia(.*)PIB")

# Display the table in the vignette.
fr |>
  select(Numero_secuencial, Descripcion_de_la_serie) |>
  knitr::kable()
```

| Numero_secuencial | Descripcion_de_la_serie |
|:---|:---|
| 2563958 | Economía internacional. Francia. AAPP. SEC2010. Capacidad (+) o necesidad (-) de financiación. Acum. 4 últimos trim. En % PIB pm |
| 2563918 | Economía internacional. Francia. PDE (SEC2010). AAPP. Deuda PDE. En % PIB pm |

Table 1: Search results

``` r

# Extract the first series.
# Use tidyverse style.
fr |>
  # Select the ID.
  select(Numero_secuencial) |>
  # Select the first observation.
  slice(1) |>
  # Convert to numeric.
  as.double() |>
  # Load the series.
  bde_series_load()
#> # A tibble: 121 × 2
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
#> # ℹ 111 more rows

# Show the metadata.
fr |>
  # Select the ID.
  select(Numero_secuencial) |>
  # Select the first observation.
  slice(1) |>
  # Convert to numeric.
  as.double() |>
  # Load its metadata.
  bde_series_load(extract_metadata = TRUE) |>
  # Display the table in the vignette.
  knitr::kable()
```

| Date | 2563958 |
|:---|:---|
| CÓDIGO DE LA SERIE | DTNSEC2010_S0000P_APU_FR |
| NÚMERO SECUENCIAL | 2563958 |
| ALIAS DE LA SERIE | BE_1_6.8 |
| DESCRIPCIÓN DE LA SERIE | Economía internacional. Francia. AAPP. SEC2010. Capacidad (+) o necesidad (-) de financiación. Acum. 4 últimos trim. En % PIB pm |
| DESCRIPCIÓN DE LAS UNIDADES | Porcentaje |
| FRECUENCIA | TRIMESTRAL |

Table 2: Metadata of the indicator
