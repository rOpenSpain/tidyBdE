# Check access to BdE resources

Checks whether R can access BdE resources at
<https://www.bde.es/webbe/en/estadisticas/recursos/descargas-completas.html>.

## Usage

``` r
bde_check_access()
```

## Value

A [logical](https://rdrr.io/r/base/logical.html) value indicating
whether BdE resources are reachable.

## Examples

``` r
# \donttest{
bde_check_access()
#> [1] TRUE
# }
```
