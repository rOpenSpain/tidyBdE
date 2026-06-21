# Test error

    Code
      bde_tidy_palettes(palette = "none")
    Condition
      Error:
      ! `palette` must be "bde_vivid_pal", "bde_rose_pal", or "bde_qual_pal", not "none".

---

    Code
      bde_tidy_palettes(n = "a")
    Condition
      Error in `bde_tidy_palettes()`:
      ! `n` must be a <numeric>.

---

    Code
      bde_tidy_palettes(n = 0)
    Condition
      Error in `bde_tidy_palettes()`:
      ! `n` must be >= 1.

---

    Code
      bde_tidy_palettes(alpha = "3")
    Condition
      Error in `bde_tidy_palettes()`:
      ! `alpha` must be <numeric> or "NULL".

---

    Code
      bde_tidy_palettes(alpha = 3)
    Condition
      Error in `bde_tidy_palettes()`:
      ! `alpha` must be in [0, 1].

---

    Code
      bde_tidy_palettes(rev = 3)
    Condition
      Error in `bde_tidy_palettes()`:
      ! `rev` must be a <logical>.

# Max value

    Code
      nmore <- bde_tidy_palettes(n = 23)
    Message
      ! Palette "bde_vivid_pal" has 6 colors. You requested 23. Returning 6 colors.

