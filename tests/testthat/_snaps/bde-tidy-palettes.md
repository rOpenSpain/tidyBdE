# Test error

    Code
      bde_tidy_palettes(palette = "none")
    Condition
      Error:
      ! `palette` must be "bde_vivid_pal", "bde_rose_pal", or "bde_qual_pal", not "none".

# Max value

    Code
      nmore <- bde_tidy_palettes(n = 23)
    Message
      ! Palette "bde_vivid_pal" has 6 colors. You requested 23. Returning 6 colors.

