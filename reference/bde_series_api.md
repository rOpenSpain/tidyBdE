# Load BdE time series from the Statistics web service (API)

**\[experimental\]**

These functions retrieve BdE time series using the[Statistics web
service
(API)](https://www.bde.es/webbe/en/estadisticas/recursos/api-estadisticas-bde.html).

The API is a JSON web service that provides URL-based access to
information available in the Statistics section of Banco de España and
the BIEST application.

The API defines two request types. `bde_series_api_latest()` uses the
Latest Data request to obtain the latest published observation for one
or more series. `bde_series_api_load()` uses the Series List request to
obtain the details of one or more complete series and their metadata.

## Usage

``` r
bde_series_api_latest(series_code, language = c("en", "es"), verbose = FALSE)

bde_series_api_load(
  series_code,
  series_label = NULL,
  out_format = "wide",
  language = c("en", "es"),
  time_range = NULL,
  verbose = FALSE,
  extract_metadata = FALSE
)
```

## Arguments

- series_code:

  A character vector of API series codes from the `Nombre_de_la_serie`
  field of the corresponding catalog. These values are passed to the API
  `series_list` parameter; they are not the stable sequential numbers
  used by
  [`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series.md).

- language:

  A string specifying the output language: `"es"` for Spanish or `"en"`
  for English.

- verbose:

  Logical. If `TRUE`, display informative messages.

- series_label:

  An optional character vector of labels to assign to the extracted
  series.

- out_format:

  The output format, either `"wide"` or `"long"`. See **Value** for
  details and the **Examples** section.

- time_range:

  An optional string specifying a year or API range code. It can be a
  year, such as `"2024"`, or one of `"3M"`, `"12M"`, `"30M"`, `"36M"`,
  `"60M"` or `"MAX"`. If `NULL`, the API returns the smallest range for
  the series frequency. Range codes are validated against the frequency
  returned by `bde_series_api_latest()`. See **Details**.

- extract_metadata:

  Logical. If `TRUE`, return the metadata associated with the requested
  series.

## Value

`bde_series_api_latest()` returns a
[tibble](https://tibble.tidyverse.org/reference/tibble.html) with the
latest published observation for each valid series. It includes fields
returned by the Latest Data request such as `serie`, `descripcionCorta`,
`codFrecuencia`, `decimales`, `simbolo`, `tendencia`, `fechaValor` and
`valor`.

`bde_series_api_load()` returns a
[tibble](https://tibble.tidyverse.org/reference/tibble.html). When
`extract_metadata = FALSE`, API dates are parsed as
[`Date`](https://rdrr.io/r/base/as.Date.html) values and observations
are returned in wide or long format according to `out_format`. When
`extract_metadata = TRUE`, it returns one row per valid series with
fields returned by the Series List request, including `fechaInicio`,
`fechaFin` and metadata fields derived from `informacion`.

## Details

Allowed `time_range` values depend on the series frequency:

- Daily frequency (`D`): `"3M"` (last 3 months), `"12M"` and `"36M"`.

- Monthly frequency (`M`): `"30M"`, `"60M"` and `"MAX"` (entire series).

- Quarterly frequency (`Q`): `"30M"`, `"60M"` and `"MAX"`.

- Annual frequency (`A`): `"60M"` and `"MAX"`.

If `time_range` is not specified, the request returns the smallest range
for the series frequency. For example, monthly series return `"30M"`.

## Series identifiers

BdE identifies each series with a stable sequential number
(`Numero_secuencial`) in bulk CSV files and an API series code
(`Nombre_de_la_serie`) in the Statistics web service.
[`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series.md)
accepts stable sequential numbers in `series_code`.
`bde_series_api_latest()` and `bde_series_api_load()` use the same
argument for API series codes. Use
[`bde_catalog_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalogs.md)
or
[`bde_catalog_search()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalogs.md)
to find both identifiers.

## See also

- [`bde_catalog_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalogs.md)
  and
  [`bde_catalog_search()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalogs.md)
  help find API series codes.

- [`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series.md)
  loads time series from bulk CSV files.

Time series functions:
[`bde_series`](https://ropenspain.github.io/tidyBdE/reference/bde_series.md)

## Examples

``` r
# \donttest{
xr <- bde_catalog_load(catalog = "TC")

# Extract the latest value.
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
xr |>
  slice_head(n = 3) |>
  pull(Nombre_de_la_serie) |>
  bde_series_api_latest(language = "en") |>
  glimpse()
#> Rows: 3
#> Columns: 8
#> $ serie            <chr> "DTCCBCEUSDEUR.B", "DTCCBCEJPYEUR.B", "DTCCBCECHFEUR.…
#> $ descripcionCorta <chr> "Exchange rate. US dollars per euro (USD/EUR). Daily …
#> $ codFrecuencia    <chr> "D", "D", "D"
#> $ decimales        <int> 4, 4, 4
#> $ simbolo          <chr> "USD", "JPY", "CHF"
#> $ tendencia        <chr> "-", "-", "+"
#> $ fechaValor       <date> 2026-07-14, 2026-07-14, 2026-07-14
#> $ valor            <dbl> 1.1405, 185.0100, 0.9257

# Extract the latest months.
xr |>
  slice_head(n = 1) |>
  pull(Nombre_de_la_serie) |>
  bde_series_api_load(language = "en", time_range = "12M") |>
  glimpse()
#> Rows: 262
#> Columns: 2
#> $ Date            <date> 2026-07-14, 2026-07-13, 2026-07-10, 2026-07-09, 2026-…
#> $ DTCCBCEUSDEUR.B <dbl> 1.1405, 1.1424, 1.1430, 1.1435, 1.1404, 1.1433, 1.1415…

# Extract metadata.
xr |>
  slice_head(n = 1) |>
  pull(Nombre_de_la_serie) |>
  bde_series_api_load(
    language = "en", time_range = "12M",
    extract_metadata = TRUE
  ) |>
  glimpse()
#> Rows: 1
#> Columns: 18
#> $ serie                    <chr> "DTCCBCEUSDEUR.B"
#> $ descripcion              <chr> "Currency exchange rates. European Central Ba…
#> $ descripcionCorta         <chr> "Exchange rate. US dollars per euro (USD/EUR)…
#> $ codFrecuencia            <chr> "D"
#> $ decimales                <int> 4
#> $ simbolo                  <chr> "USD"
#> $ fechaInicio              <date> 1999-01-04
#> $ fechaFin                 <date> 2026-07-14
#> $ Name                     <chr> "Exchange rate. US dollars per euro (USD/EUR)…
#> $ Description              <chr> "Currency exchange rates. European Central Ba…
#> $ Units                    <chr> "Dólares de Estados Unidos por Euro"
#> $ Decimals                 <chr> "4"
#> $ `Number of observations` <chr> "7.182"
#> $ `First value`            <chr> "[04/01/1999] 1.1405 USD"
#> $ `Last value`             <chr> "[14/07/2026] 1.1405 USD"
#> $ `Min value`              <chr> "[26/10/2000] 0.8252 USD"
#> $ `Max value`              <chr> "[15/07/2008] 1.5990 USD"
#> $ Source                   <chr> "BANCO CENTRAL EUROPEO"
# }
```
