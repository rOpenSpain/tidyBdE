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
      ! Palette "bde_vivid_pal" has 6 colors. You requested 23, so only 6 colors are returned.

