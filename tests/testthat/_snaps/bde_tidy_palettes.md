# Test error

    Code
      bde_tidy_palettes(palette = "none")
    Condition
      Error in `match.arg()`:
      ! 'arg' should be one of "bde_vivid_pal", "bde_rose_pal", "bde_qual_pal"

# Max value

    Code
      nmore <- bde_tidy_palettes(n = 23)
    Message
      tidyBdE> bde_vivid_pal has 6, requested 23. Returning 6 colors.

