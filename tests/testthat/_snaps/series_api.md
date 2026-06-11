# Latest: test errors

    Code
      bde_series_api_latest()
    Condition
      Error in `bde_series_api_latest()`:
      ! `series_alias` cannot be missing.

---

    Code
      bde_series_api_latest("An_example", language = "aaa")
    Condition
      Error in `match.arg()`:
      ! 'arg' should be one of "en", "es"

# Latest: Empty results

    Code
      empty <- bde_series_api_latest("XXX")
    Message
      ! The query returned an error XXX for `series_alias` "XXX".
      i Value omitted from the results.
      ! No valid results with query <https://app.bde.es/bierest/resources/srdatosapp/favoritas?idioma=en&series=XXX>.
      i Returning an empty tibble.

