# Check BdE access

Check whether **R** can access resources at
<https://www.bde.es/webbe/en/estadisticas/recursos/descargas-completas.html>.

## Usage

``` r
bde_check_access()
```

## Value

A logical value indicating whether BdE resources are reachable.

## Examples

``` r
# \donttest{
bde_check_access()
#> [1] TRUE
# }
```
