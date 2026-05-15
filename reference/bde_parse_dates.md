# Parse dates from strings

This function is tailored for date formats used in this package and may
fail with other datasets. See **Examples** for formats that are
supported.

### Date formats

|  |  |  |
|----|----|----|
| **FREQUENCY** | **FORMAT** | **EXAMPLES** |
| **Daily / Business day** | DD MMMMYYYY | *02 FEB2019* |
| **Monthly** | MMM YYYY | *MAR 2020* |
| **Quarterly** | MMM YYYY, where MMM is the first or the last month of the quarter, depending on the value of its variable OBSERVED. | For the first quarter of 2020: *ENE 2020, MAR 2020* |
| **Half-yearly** | MMM YYYY, where MMM is the first or the last month of the half-year period, depending on the value of its variable OBSERVED. | For the first half of 2020: *ENE 2020, JUN 2020* |
| **Annual** | YYYY | *2020* |

## Usage

``` r
bde_parse_dates(dates_to_parse)
```

## Arguments

- dates_to_parse:

  Character vector of dates to parse.

## Value

A vector of [`Date`](https://rdrr.io/r/base/as.Date.html) values.

## Details

Parse strings representing dates using
[`as.Date()`](https://rdrr.io/r/base/as.Date.html).

## See also

[`as.Date()`](https://rdrr.io/r/base/as.Date.html)

## Examples

``` r
# Supported formats.
would_parse <- c(
  "02 FEB2019", "15 ABR 1890", "MAR 2020", "ENE2020",
  "2020", "12-1993", "01-02-2014", "01/02/1990"
)

parsed_ok <- bde_parse_dates(would_parse)

class(parsed_ok)
#> [1] "Date"

tibble::tibble(raw = would_parse, parsed = parsed_ok)
#> # A tibble: 8 × 2
#>   raw         parsed    
#>   <chr>       <date>    
#> 1 02 FEB2019  2019-02-02
#> 2 15 ABR 1890 1890-04-15
#> 3 MAR 2020    2020-03-01
#> 4 ENE2020     2020-01-01
#> 5 2020        2020-12-31
#> 6 12-1993     1993-12-01
#> 7 01-02-2014  2014-02-01
#> 8 01/02/1990  1990-02-01

#-----------------------------------

# Unsupported formats.
wont_parse <- c("JAN2001", "2010-01-12", "01 APR 2017", "01/31/1990")

parsed_fail <- bde_parse_dates(wont_parse)

class(parsed_fail)
#> [1] "Date"

tibble::tibble(raw = wont_parse, parsed = parsed_fail)
#> # A tibble: 4 × 2
#>   raw         parsed   
#>   <chr>       <date>   
#> 1 JAN2001     NA       
#> 2 2010-01-12  112-10-20
#> 3 01 APR 2017 NA       
#> 4 01/31/1990  NA       
```
