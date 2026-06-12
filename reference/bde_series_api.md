# Load BdE time series from the Statistics web service (API)

**\[experimental\]**

These functions query BdE time series through the [Statistics web
service
(API)](https://www.bde.es/webbe/en/estadisticas/recursos/api-estadisticas-bde.html).

The API is a JSON web service that provides access through URL requests
to information available in the Statistics section of the Banco de
España and the BIEST application.

The API defines two request types. `bde_series_api_latest()` uses the
Latest Data request to obtain the latest published observation for one
or more series. `bde_series_api_load()` uses the Series List request to
obtain the details of one or more complete series and their metadata.

The API uses BdE series codes as identifiers. In this package, pass
those codes through `series_code`. They are available in the
`Nombre_de_la_serie` field of
[`bde_catalog_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_load.md)
and correspond to the API `series_list` parameter. This is different
from the numeric sequential number (`Número secuencial`) used by
[`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_load.md)
for bulk CSV files.

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

  Character string or vector with BdE API series codes, taken from the
  `Nombre_de_la_serie` field of the corresponding catalog. This is the
  value passed to the API `series_list` parameter, not the numeric
  sequential number used by
  [`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_load.md).

- language:

  Character string. It can take the values `"es"` or `"en"` to obtain
  results in Spanish or English, respectively.

- verbose:

  Logical. If `TRUE`, display information useful for debugging.

- series_label:

  Optional character string or vector of labels to assign to the
  extracted series.

- out_format:

  The format to return, either `"wide"` or `"long"`. See **Value** for
  details and the **Examples** section.

- time_range:

  Character string. Optional annual range or API range code. It can be a
  year, such as `"2024"`, or a range code such as `"3M"`, `"12M"`,
  `"30M"`, `"36M"`, `"60M"` or `"MAX"`. If `NULL`, the API returns the
  smallest range for the series frequency. Range codes are validated
  against the frequency returned by `bde_series_api_latest()`. See
  **Details**.

- extract_metadata:

  Logical. If `TRUE`, the output is the metadata of the requested
  series.

## Value

`bde_series_api_latest()` returns a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html) with
the latest published observation for each valid series, with fields
returned by the Latest Data request such as `serie`, `descripcionCorta`,
`codFrecuencia`, `decimales`, `simbolo`, `tendencia`, `fechaValor` and
`valor`.

`bde_series_api_load()` returns a
[tibble](https://tibble.tidyverse.org/reference/tbl_df-class.html). When
`extract_metadata = FALSE`, API dates are parsed as
[`Date`](https://rdrr.io/r/base/as.Date.html) values and observations
are returned in wide or long format according to `out_format`. When
`extract_metadata = TRUE`, it returns one row per valid series with
fields returned by the Series List request, including `fechaInicio`,
`fechaFin` and metadata fields derived from `informacion`.

## Details

`time_range` allowed values based on the frequency of the series are:

- Daily frequency (`D`): `"3M"` (last 3 months), `"12M"` and `"36M"`.

- Monthly frequency (`M`): `"30M"`, `"60M"` and `"MAX"` (entire series).

- Quarterly frequency (`Q`): `"30M"`, `"60M"` and `"MAX"`.

- Annual frequency (`A`): `"60M"` and `"MAX"`.

If `time_range` is not specified, the request returns the smallest range
for the series frequency. For example, monthly series return `"30M"`.

## See also

[`bde_catalog_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_load.md),
[`bde_catalog_search()`](https://ropenspain.github.io/tidyBdE/reference/bde_catalog_search.md),
[`bde_indicators()`](https://ropenspain.github.io/tidyBdE/reference/bde_indicators.md)

Other series:
[`bde_series_full_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_full_load.md),
[`bde_series_load()`](https://ropenspain.github.io/tidyBdE/reference/bde_series_load.md)

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
#> $ fechaValor       <date> 2026-06-10, 2026-06-10, 2026-06-10
#> $ valor            <dbl> 1.1539, 185.1900, 0.9222

# Extract the latest months.
xr |>
  slice_head(n = 1) |>
  pull(Nombre_de_la_serie) |>
  bde_series_api_load(language = "en", time_range = "12M") |>
  glimpse()
#> Rows: 262
#> Columns: 2
#> $ Date            <date> 2026-06-10, 2026-06-09, 2026-06-08, 2026-06-05, 2026-…
#> $ DTCCBCEUSDEUR.B <dbl> 1.1539, 1.1573, 1.1540, 1.1640, 1.1640, 1.1614, 1.1649…

# Extract metadata.
xr |>
  slice_head(n = 1) |>
  pull(Nombre_de_la_serie) |>
  bde_series_api_load(language = "en", time_range = "12M",
                      extract_metadata = TRUE) |>
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
#> $ fechaFin                 <date> 2026-06-10
#> $ Name                     <chr> "Exchange rate. US dollars per euro (USD/EUR)…
#> $ Description              <chr> "Currency exchange rates. European Central Ba…
#> $ Units                    <chr> "Dólares de Estados Unidos por Euro"
#> $ Decimals                 <chr> "4"
#> $ `Number of observations` <chr> "7.158"
#> $ `First value`            <chr> "[04/01/1999] 1.1539 USD"
#> $ `Last value`             <chr> "[10/06/2026] 1.1539 USD"
#> $ `Min value`              <chr> "[26/10/2000] 0.8252 USD"
#> $ `Max value`              <chr> "[15/07/2008] 1.5990 USD"
#> $ Source                   <chr> "BANCO CENTRAL EUROPEO"
# }
```
