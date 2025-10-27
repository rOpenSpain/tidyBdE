test_that("Test error", {
  expect_snapshot(bde_tidy_palettes(palette = "none"), error = TRUE)
})


test_that("Max value", {
  ok <- bde_tidy_palettes(n = 6)

  expect_snapshot(nmore <- bde_tidy_palettes(n = 23))

  expect_identical(ok, nmore)
})


test_that("Switch pal", {
  ok <- bde_tidy_palettes(n = 6)
  other <- bde_tidy_palettes(n = 6, palette = "bde_rose_pal")
  expect_false(any(ok == other))

  other2 <- bde_tidy_palettes(n = 6, palette = "bde_qual_pal")
  expect_false(any(ok == other2))
  expect_false(any(other == other2))
})


test_that("test n", {
  ok <- bde_tidy_palettes(n = 6)
  ok3 <- bde_tidy_palettes(n = 3)

  expect_identical(ok[seq_len(3)], ok3)
})


test_that("test rev", {
  ok <- bde_tidy_palettes(n = 6)
  ok3 <- bde_tidy_palettes(n = 3, rev = TRUE)

  expect_identical(ok[rev(seq_len(3))], ok3)
})

test_that("test alpha", {
  ok <- bde_tidy_palettes(n = 6)
  ok3 <- bde_tidy_palettes(n = 6, alpha = 0.2)

  expect_identical(ggplot2::alpha(ok, 0.2), ok3)
})
