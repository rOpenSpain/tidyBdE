# Latest API validates required inputs

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

# Series API load validates required inputs

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

---

    Code
      bde_series_api_load(c("a", "b"), c("same", "same"))
    Condition
      Error in `bde_series_api_load()`:
      ! `series_label` must contain unique values.
      i Duplicate value: "same".

# Series API load parses valid and invalid mocked API responses

    Code
      out <- bde_series_api_load(c("BAD", "D_TEST"), series_label = c("bad", "good"),
      language = "en")
    Message
      ! The BdE API returned error "404" for `series_code` "BAD", so the series was omitted from the results.

# Series API load reports all-invalid mocked API responses

    Code
      empty <- bde_series_api_load("BAD", language = "en")
    Message
      ! The BdE API returned error "404" for `series_code` "BAD", so the series was omitted from the results.
      ! The BdE API returned no valid results for `series_code` "BAD".
      i Returning an empty tibble.

# Latest API reports invalid JSON responses

    Code
      bde_series_api_latest("D_TEST")
    Condition
      Error in `bde_series_api_latest()`:
      ! Could not parse the response from the BdE API.
      i Try the request again later.

# Latest API reports unexpected response formats

    Code
      bde_series_api_latest("D_TEST")
    Condition
      Error in `bde_series_api_latest()`:
      ! The BdE API returned an unexpected response format.

# Series API load reports mismatched response counts

    Code
      bde_series_api_load(c("D_ONE", "D_TWO"))
    Condition
      Error in `bde_series_api_load()`:
      ! The BdE API returned an unexpected number of results.
      i Requested 2, but received 1.

# Series API load reports reordered series results

    Code
      bde_series_api_load(c("D_ONE", "D_TWO"))
    Condition
      Error in `bde_series_api_load()`:
      ! The BdE API returned unexpected series codes or order.
      x Requested: "D_ONE" and "D_TWO".
      x Received: "D_TWO" and "D_ONE".

# Latest API reports non-object results

    Code
      bde_series_api_latest("D_TEST")
    Condition
      Error in `bde_series_api_latest()`:
      ! Each result returned by the BdE API must be a JSON object.

# Latest API reports missing required fields

    Code
      bde_series_api_latest("D_TEST")
    Condition
      Error in `bde_series_api_latest()`:
      ! The BdE API returned an incomplete response.
      x Missing field: fechaValor.
      i Affected series code: "D_TEST".

# Series API load reports missing observation fields

    Code
      bde_series_api_load("D_TEST")
    Condition
      Error in `bde_series_api_load()`:
      ! The BdE API returned an incomplete response.
      x Missing field: valores.
      i Affected series code: "D_TEST".

# Series API load reports mismatched dates and values

    Code
      bde_series_api_load("D_TEST")
    Condition
      Error in `bde_series_api_load()`:
      ! The BdE API returned mismatched dates and values.
      i Affected series code: "D_TEST".

# Series API metadata reports missing required fields

    Code
      bde_series_api_load("D_TEST", extract_metadata = TRUE)
    Condition
      Error in `bde_series_api_load()`:
      ! The BdE API returned an incomplete response.
      x Missing field: informacion.
      i Affected series code: "D_TEST".

# Series API load rejects ranges invalid for its frequency

    Code
      bde_series_api_load("D_TEST", time_range = "30M")
    Condition
      Error in `bde_hlp_api_check_range()`:
      ! `time_range` "30M" is not valid for series frequency: "D".
      i Use one of "3M", "12M", or "36M".
      i Invalid series: "D_TEST".

# Smoke: latest API reports unknown series

    Code
      empty <- bde_series_api_latest("XXX")
    Message
      ! The BdE API returned error XXX for `series_code` "XXX", so the series was omitted from the results.
      ! The BdE API returned no valid results for `series_code` "XXX".
      i Returning an empty tibble.

# Latest API handles empty codes and download failures

    Code
      empty <- bde_series_api_latest("XXX")
    Message
      i Returning an empty tibble.

# Latest API parses valid and invalid mocked responses

    Code
      latest <- bde_series_api_latest(c("BAD", "D_TEST"), language = "en")
    Message
      ! The BdE API returned error "404" for `series_code` "BAD", so the series was omitted from the results.

# Latest API reports all-invalid mocked responses

    Code
      empty <- bde_series_api_latest("BAD", language = "en")
    Message
      ! The BdE API returned error "404" for `series_code` "BAD", so the series was omitted from the results.
      ! The BdE API returned no valid results for `series_code` "BAD".
      i Returning an empty tibble.

# Series API load handles download failures and null values

    Code
      empty <- bde_series_api_load("D_TEST")
    Message
      i Returning an empty tibble.

# Smoke: latest API loads multiple series and languages

    Code
      tb_es_invalid <- bde_series_api_latest(sname_invalid, language = "es")
    Message
      ! The BdE API returned error XXX for `series_code` "AN_ERROR", so the series was omitted from the results.
      ! The BdE API returned error XXX for `series_code` "ANOTHER_ERROR", so the series was omitted from the results.

# Smoke: series API loads data and metadata

    Code
      tb_es_invalid <- bde_series_api_load(sname_invalid, language = "es")
    Message
      ! Could not download 'listaSeries'.
      i If this looks like a bug, please open an issue at <https://github.com/rOpenSpain/tidyBdE/issues>.
      i Returning an empty tibble.

# Time range validation rejects invalid documented combinations

    Code
      bde_hlp_api_check_range("D_TEST", "en", "3M", FALSE)
    Condition
      Error in `bde_hlp_api_check_range()`:
      ! `time_range` "3M" is not valid for series frequency: "M".
      i Use one of "30M", "60M", or "MAX".
      i Invalid series: "D_TEST".

---

    Code
      bde_hlp_api_check_range("D_TEST", "en", "12M", FALSE)
    Condition
      Error in `bde_hlp_api_check_range()`:
      ! `time_range` "12M" is not valid for series frequency: "Q".
      i Use one of "30M", "60M", or "MAX".
      i Invalid series: "D_TEST".

---

    Code
      bde_hlp_api_check_range("D_TEST", "en", "30M", FALSE)
    Condition
      Error in `bde_hlp_api_check_range()`:
      ! `time_range` "30M" is not valid for series frequency: "A".
      i Use one of "60M" or "MAX".
      i Invalid series: "D_TEST".

