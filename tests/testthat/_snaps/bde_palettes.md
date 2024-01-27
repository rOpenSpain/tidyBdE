# Test error

    Code
      bde_palettes(palette = "none")
    Condition
      Error in `match.arg()`:
      ! 'arg' should be one of "bde_vivid_pal", "bde_rose_pal"

# Max value

    Code
      nmore <- bde_palettes(n = 23)
    Message
      tidyBdE> bde_vivid_pal has 6, requested 23. Returning 6 colors.

