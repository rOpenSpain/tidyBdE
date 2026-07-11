# Errors on download

    Code
      a <- bde_hlp_download("https://example.invalid/file.csv", tmp, TRUE)
    Message
      i Downloading file from <https://example.invalid/file.csv>.
      ! Download failed; trying again.
      ! URL <https://example.invalid/file.csv> is not reachable. If this looks like a bug, please open an issue at <https://github.com/rOpenSpain/tidyBdE/issues>.

---

    Code
      b <- bde_hlp_download("https://example.com/file.csv", tmp2, TRUE)
    Message
      i Downloading file from <https://example.com/file.csv>.

# Messages

    Code
      df <- bde_hlp_return_null()
    Message
      i BdE resources are unavailable. Returning an empty <tbl_df>.

---

    Code
      df2 <- bde_hlp_return_null("An example message.")
    Message
      i An example message.

# Pretty match

    Code
      my_fun("error here")
    Condition
      Error:
      ! `arg_one` must be "10", "1000", "3000", or "5000", not "error here".

---

    Code
      my_fun(c("an", "error"))
    Condition
      Error:
      ! `arg_one` must be "10", "1000", "3000", or "5000", not "an" or "error".

---

    Code
      my_fun("5")
    Condition
      Error:
      ! `arg_one` must be "10", "1000", "3000", or "5000", not "5".
      i Did you mean "5000"?

---

    Code
      my_fun("00")
    Condition
      Error:
      ! `arg_one` must be "10", "1000", "3000", or "5000", not "00".

---

    Code
      my_fun2(c(1, 2))
    Condition
      Error:
      ! `year` must be "20", not "1" or "2".

---

    Code
      my_fun3("3")
    Condition
      Error:
      ! `an_arg` must be "30" or "20", not "3".
      i Did you mean "30"?

---

    Code
      my_fun2(c(1, 2))
    Condition
      Error:
      ! `year` must be "20", not "1" or "2".

# Argument matching reports invalid values

    Code
      match_year(2030)
    Condition
      Error:
      ! `year` must be "2020" or "2024", not "2030".

---

    Code
      match_year(c(2020, 2030))
    Condition
      Error:
      ! `year` must be "2020" or "2024", not "2020" or "2030".

# bde_hlp_abort_if_not

    Code
      bde_hlp_abort_if_not(isFALSE(TRUE))
    Condition
      Error:
      ! Every condition supplied to `gb_abort_if_not()` must be named.

---

    Code
      bde_catalog_load(cache_dir = 1)
    Condition
      Error in `bde_catalog_load()`:
      ! `cache_dir` must be a <character> vector or "NULL".

---

    Code
      bde_catalog_load(verbose = 1)
    Condition
      Error in `bde_catalog_load()`:
      ! `verbose` must be a <logical> vector.

---

    Code
      bde_catalog_load(parse_dates = 1)
    Condition
      Error in `bde_catalog_load()`:
      ! `parse_dates` must be a <logical> vector.

---

    Code
      bde_catalog_load(update_cache = 1)
    Condition
      Error in `bde_catalog_load()`:
      ! `update_cache` must be a <logical> vector.

