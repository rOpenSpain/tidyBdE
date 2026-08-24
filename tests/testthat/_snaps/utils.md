# Download helper retries warnings and cleans failed files

    Code
      a <- bde_hlp_download("https://example.invalid/file.csv", tmp, TRUE)
    Message
      i Downloading 'file.csv'.
      ! Download failed, trying once more.
      ! Could not download 'file.csv'.
      i If this looks like a bug, please open an issue at <https://github.com/rOpenSpain/tidyBdE/issues>.

# Download helper reports successful downloads

    Code
      b <- bde_hlp_download("https://example.com/file.csv", tmp2, TRUE)
    Message
      i Downloading 'file.csv'.

# Empty result helper reports optional messages

    Code
      df <- bde_hlp_return_null()

---

    Code
      df2 <- bde_hlp_return_null("An example message.")
    Message
      i An example message.

# Argument matching reports invalid and partial values

    Code
      my_fun("error here")
    Condition
      Error in `my_fun()`:
      ! `arg_one` must be "10", "1000", "3000", or "5000", not "error here".

---

    Code
      my_fun(c("an", "error"))
    Condition
      Error in `my_fun()`:
      ! `arg_one` must be "10", "1000", "3000", or "5000", not "an" or "error".

---

    Code
      my_fun("5")
    Condition
      Error in `my_fun()`:
      ! `arg_one` must be "10", "1000", "3000", or "5000", not "5".
      i Did you mean "5000"?

---

    Code
      my_fun("00")
    Condition
      Error in `my_fun()`:
      ! `arg_one` must be "10", "1000", "3000", or "5000", not "00".

---

    Code
      my_fun2(c(1, 2))
    Condition
      Error in `my_fun2()`:
      ! `year` must be "20", not "1" or "2".

---

    Code
      my_fun3("3")
    Condition
      Error in `my_fun3()`:
      ! `an_arg` must be "30" or "20", not "3".
      i Did you mean "30"?

# Validation helper reports the first failed condition

    Code
      bde_hlp_abort_if_not(isFALSE(TRUE))
    Condition
      Error:
      ! Every condition supplied to `bde_hlp_abort_if_not()` must be named.

---

    Code
      bde_catalog_load(cache_dir = 1)
    Condition
      Error in `bde_catalog_load()`:
      ! `cache_dir` must be <character> or `NULL`.

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

