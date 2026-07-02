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
      ! `n` must be a <numeric> vector.

---

    Code
      bde_tidy_palettes(n = 0)
    Condition
      Error in `bde_tidy_palettes()`:
      ! `n` must be greater than or equal to "1".

---

    Code
      bde_tidy_palettes(alpha = "3")
    Condition
      Error in `bde_tidy_palettes()`:
      ! `alpha` must be a <numeric> vector or "NULL".

---

    Code
      bde_tidy_palettes(alpha = 3)
    Condition
      Error in `bde_tidy_palettes()`:
      ! `alpha` must contain values between "0" and "1".

---

    Code
      bde_tidy_palettes(rev = 3)
    Condition
      Error in `bde_tidy_palettes()`:
      ! `rev` must be a <logical> vector.

# Max value

    Code
      nmore <- bde_tidy_palettes(n = 23)
    Message
      ! Palette "bde_vivid_pal" contains 6 colors; `n` requested 23. Returning all 6 colors.

