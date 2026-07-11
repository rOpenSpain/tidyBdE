# Series load validates labels offline

    Code
      bde_series_load(c(101, 102), series_label = c("one", NA))
    Condition
      Error in `bde_series_load()`:
      ! `series_label` must not contain missing values.

---

    Code
      bde_series_load(c(101, 102), series_label = c("same", "same"))
    Condition
      Error in `bde_series_load()`:
      ! `series_label` and `series_code` must have the same length.
      i `series_label` has length 1 and `series_code` has length 2.

# Series full load reads cached CSV variants offline

    Code
      data <- bde_series_full_load("tc_1_1", cache_dir = dir, verbose = TRUE)
    Message
      v Using cache directory '<tempdir>'.
      v Reading file 'tc_1_1.csv' from cache.
      i Parsing date columns as <Date>.
      i Parsing numeric fields as <numeric> vectors.

# Series load reshapes mocked catalog and cached data

    Code
      missing <- bde_series_load(999, cache_dir = dir, verbose = TRUE)
    Message
      i Extracting series 999.
      ! `series_code` 999 was not found in catalog metadata.
      i BdE resources are unavailable. Returning an empty <tbl_df>.
      i BdE resources are unavailable. Returning an empty <tbl_df>.

# Series full load handles offline download branches

    Code
      empty <- bde_series_full_load("tc_1_1.csv", cache_dir = dir, update_cache = TRUE)
    Message
      i BdE resources are unavailable. Returning an empty <tbl_df>.

# Series full load creates family subdirectories

    Code
      empty <- bde_series_full_load("tc_1_1.csv", cache_dir = dir)
    Message
      i BdE resources are unavailable. Returning an empty <tbl_df>.

