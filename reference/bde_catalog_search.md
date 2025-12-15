# Search BdE catalogs

Search for keywords on the time-series catalogs.

## Usage

``` r
bde_catalog_search(pattern, ...)
```

## Arguments

- pattern:

  [`regex`](https://rdrr.io/r/base/regex.html) pattern to search See
  **Details** and **Examples**.

- ...:

  Arguments passed on to
  [`bde_catalog_load`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_load.md)

  `catalog`

  :   A single value indicating the catalogs to be updated or `"ALL"` as
      a shorthand. See **Details**.

  `parse_dates`

  :   Logical. If `TRUE` the dates would be parsed using
      [`bde_parse_dates()`](https://ropenspain.github.io/tidyBdE/reference/bde_parse_dates.md).

  `update_cache`

  :   Logical. If `TRUE` the requested file would be updated on the
      `cache_dir`.

  `cache_dir`

  :   A path to a cache directory. The directory can also be set via
      options with `options(bde_cache_dir = "path/to/dir")`.

  `verbose`

  :   Logical `TRUE` or `FALSE`, display information useful for
      debugging.

## Value

A [`tibble`](https://tibble.tidyverse.org/reference/tibble.html) object
with the results of the query.

## Details

**Note that** BdE files are only provided in Spanish, for the time
being. Therefore search terms should be provided in Spanish as well in
order to get search results.

This function uses [`base::grep()`](https://rdrr.io/r/base/grep.html)
function for finding matches on the catalogs. You can pass [regular
expressions](https://rdrr.io/r/base/regex.html) to broaden the search.

## See also

[`bde_catalog_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_load.md),
[base::regex](https://rdrr.io/r/base/regex.html)

Other catalog:
[`bde_catalog_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_load.md),
[`bde_catalog_update()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_update.md)

## Examples

``` r
# \donttest{
# Simple search (needs to be in Spanish)
# !! PIB [es] == GDP [en]

bde_catalog_search("PIB")
#> # A tibble: 400 × 17
#>    Nombre_de_la_serie Numero_secuencial Alias_de_la_serie Nombre_del_archivo_c…¹
#>    <chr>              <chr>             <chr>             <chr>                 
#>  1 DSPC102020WB11000… 4669410           BE_1_1.7          BE0101.csv            
#>  2 DTNSEC2010_S0000P… 2563971           BE_1_6.1          BE0106.csv            
#>  3 DTNSEC2010_S0000P… 2563952           BE_1_6.2          BE0106.csv            
#>  4 DTNSEC2010_S0000P… 2563953           BE_1_6.3          BE0106.csv            
#>  5 DTNSEC2010_S0000P… 2563954           BE_1_6.4          BE0106.csv            
#>  6 DTNSEC2010_S0000P… 2563955           BE_1_6.5          BE0106.csv            
#>  7 DTNSEC2010_S0000P… 2563956           BE_1_6.6          BE0106.csv            
#>  8 DTNSEC2010_S0000P… 2563957           BE_1_6.7          BE0106.csv            
#>  9 DTNSEC2010_S0000P… 2563958           BE_1_6.8          BE0106.csv            
#> 10 DTNSEC2010_S0000P… 4342489           BE_1_6.9          BE0106.csv            
#> # ℹ 390 more rows
#> # ℹ abbreviated name: ¹​Nombre_del_archivo_con_los_valores_de_la_serie
#> # ℹ 13 more variables: Descripcion_de_la_serie <chr>, Tipo_de_variable <chr>,
#> #   Codigo_de_unidades <chr>, Exponente <dbl>, Numero_de_decimales <dbl>,
#> #   Descripcion_de_unidades_y_exponente <chr>, Frecuencia_de_la_serie <chr>,
#> #   Fecha_de_la_primera_observacion <date>,
#> #   Fecha_de_la_ultima_observacion <date>, Numero_de_observaciones <dbl>, …

# More complex - Single
bde_catalog_search("Francia(.*)PIB")
#> # A tibble: 2 × 17
#>   Nombre_de_la_serie  Numero_secuencial Alias_de_la_serie Nombre_del_archivo_c…¹
#>   <chr>               <chr>             <chr>             <chr>                 
#> 1 DTNSEC2010_S0000P_… 2563958           BE_1_6.8          BE0106.csv            
#> 2 DTNPDE2010_P0000P_… 2563918           BE_1_7.8          BE0107.csv            
#> # ℹ abbreviated name: ¹​Nombre_del_archivo_con_los_valores_de_la_serie
#> # ℹ 13 more variables: Descripcion_de_la_serie <chr>, Tipo_de_variable <chr>,
#> #   Codigo_de_unidades <chr>, Exponente <dbl>, Numero_de_decimales <dbl>,
#> #   Descripcion_de_unidades_y_exponente <chr>, Frecuencia_de_la_serie <chr>,
#> #   Fecha_de_la_primera_observacion <date>,
#> #   Fecha_de_la_ultima_observacion <date>, Numero_de_observaciones <dbl>,
#> #   Titulo_de_la_serie <chr>, Fuente <chr>, Notas <chr>

# Even more complex - Double
bde_catalog_search("Francia(.*)PIB|Italia(.*)PIB|Alemania(.*)PIB")
#> # A tibble: 6 × 17
#>   Nombre_de_la_serie  Numero_secuencial Alias_de_la_serie Nombre_del_archivo_c…¹
#>   <chr>               <chr>             <chr>             <chr>                 
#> 1 DTNSEC2010_S0000P_… 2563953           BE_1_6.3          BE0106.csv            
#> 2 DTNSEC2010_S0000P_… 2563958           BE_1_6.8          BE0106.csv            
#> 3 DTNSEC2010_S0000P_… 2563959           BE_1_6.10         BE0106.csv            
#> 4 DTNPDE2010_P0000P_… 2563913           BE_1_7.3          BE0107.csv            
#> 5 DTNPDE2010_P0000P_… 2563918           BE_1_7.8          BE0107.csv            
#> 6 DTNPDE2010_P0000P_… 2563919           BE_1_7.10         BE0107.csv            
#> # ℹ abbreviated name: ¹​Nombre_del_archivo_con_los_valores_de_la_serie
#> # ℹ 13 more variables: Descripcion_de_la_serie <chr>, Tipo_de_variable <chr>,
#> #   Codigo_de_unidades <chr>, Exponente <dbl>, Numero_de_decimales <dbl>,
#> #   Descripcion_de_unidades_y_exponente <chr>, Frecuencia_de_la_serie <chr>,
#> #   Fecha_de_la_primera_observacion <date>,
#> #   Fecha_de_la_ultima_observacion <date>, Numero_de_observaciones <dbl>,
#> #   Titulo_de_la_serie <chr>, Fuente <chr>, Notas <chr>
# }
```
