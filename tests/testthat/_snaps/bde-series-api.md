# Latest: test errors

    Code
      bde_series_api_latest()
    Condition
      Error in `bde_series_api_latest()`:
      ! `series_code` cannot be missing.

---

    Code
      bde_series_api_latest("An_example", language = "aaa")
    Condition
      Error:
      ! `language` must be "en" or "es", not "aaa".

# Series API load checks inputs

    Code
      bde_series_api_load()
    Condition
      Error in `bde_series_api_load()`:
      ! `series_code` cannot be missing.

---

    Code
      bde_series_api_load("An_example", language = "aaa")
    Condition
      Error:
      ! `language` must be "en" or "es", not "aaa".

---

    Code
      bde_series_api_load("An_example", time_range = c("30M", "60M"))
    Condition
      Error in `bde_series_api_load()`:
      ! `time_range` must be a non-empty string or `NULL`.

---

    Code
      bde_series_api_load("a", c("A", NA))
    Condition
      Error in `bde_series_api_load()`:
      ! `series_label` must not contain missing values.

---

    Code
      bde_series_api_load("a", c("A", "B"))
    Condition
      Error in `bde_series_api_load()`:
      ! `series_label` and `series_code` must have the same length.
      i `series_label` has length 2 and `series_code` has length 1.

# Series API load validates time range by frequency

    Code
      bde_series_api_load("D_TEST", time_range = "30M")
    Condition
      Error in `bde_hlp_api_check_range()`:
      ! `time_range` "30M" is not valid for series frequency: "D". Use one of "3M", "12M", or "36M".
      i Invalid series: "D_TEST".

# Latest: Empty results

    Code
      empty <- bde_series_api_latest("XXX")
    Message
      ! The query returned error XXX for `series_code` "XXX".
      i This series was omitted from the results.
      ! No valid results for query <https://app.bde.es/bierest/resources/srdatosapp/favoritas?idioma=en&series=XXX>.
      i Returning an empty <tbl_df>.

# Latest handles empty codes and download failures

    Code
      empty <- bde_series_api_latest("XXX")
    Message
      i Returning an empty <tbl_df>.

# Latest parses valid and invalid mocked API responses

    Code
      latest <- bde_series_api_latest(c("BAD", "D_TEST"), language = "en")
    Message
      ! The query returned error "404" for `series_code` "BAD".
      i This series was omitted from the results.

# Latest reports all-invalid mocked API responses

    Code
      empty <- bde_series_api_latest("BAD", language = "en")
    Message
      ! The query returned error "404" for `series_code` "BAD".
      i This series was omitted from the results.
      ! No valid results for query <https://app.bde.es/bierest/resources/srdatosapp/favoritas?idioma=en&series=BAD>.
      i Returning an empty <tbl_df>.

# Series API load handles download failures and null values

    Code
      empty <- bde_series_api_load("D_TEST")
    Message
      i Returning an empty <tbl_df>.

# Latest: Several results

    Code
      tb_es_invalid <- bde_series_api_latest(sname_invalid, language = "es")
    Message
      ! The query returned error XXX for `series_code` "AN_ERROR".
      i This series was omitted from the results.
      ! The query returned error XXX for `series_code` "ANOTHER_ERROR".
      i This series was omitted from the results.

# Series API real test

    Code
      tb_es_invalid <- bde_series_api_load(sname_invalid, language = "es")
    Message
      ! URL <https://app.bde.es/bierest/resources/srdatosapp/listaSeries?idioma=es&series=AN_ERROR,DTCCBCEUSDEUR.B,DTCCBCEJPYEUR.B,ANOTHER_ERROR> is not reachable. If this looks like a bug, please open an issue at <https://github.com/rOpenSpain/tidyBdE/issues>.
      i Returning an empty <tbl_df>.

# Error on time_range

    Code
      bde_hlp_api_check_range(series_code = "DTCCBCEUSDEUR.B", language = "es",
        time_range = "30M", verbose = FALSE)
    Condition
      Error in `bde_hlp_api_check_range()`:
      ! `time_range` "30M" is not valid for series frequency: "D". Use one of "3M", "12M", or "36M".
      i Invalid series: "DTCCBCEUSDEUR.B".

