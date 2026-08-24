test_that("Palette inputs are validated", {
  expect_snapshot(bde_tidy_palettes(palette = "none"), error = TRUE)
  expect_snapshot(bde_tidy_palettes(n = "a"), error = TRUE)
  expect_snapshot(bde_tidy_palettes(n = 0), error = TRUE)
  expect_snapshot(bde_tidy_palettes(alpha = "3"), error = TRUE)
  expect_snapshot(bde_tidy_palettes(alpha = 3), error = TRUE)
  expect_snapshot(bde_tidy_palettes(rev = 3), error = TRUE)
})

test_that("Palettes return expected colors", {
  expect_identical(bde_tidy_palettes(n = 3), c("#4180C2", "#D86E7B", "#F89E63"))
  expect_identical(
    bde_tidy_palettes(n = 3, palette = "bde_rose_pal"),
    c("#b7365c", "#cb6e8a", "#db9aad")
  )
  expect_identical(
    bde_tidy_palettes(n = 3, palette = "bde_qual_pal"),
    c("#b55b4a", "#2e76bc", "#fece64")
  )
})

test_that("Palette requests above the maximum return all colors", {
  all_colors <- bde_tidy_palettes(n = 6)

  expect_snapshot(nmore <- bde_tidy_palettes(n = 23))

  expect_identical(all_colors, nmore)
})

test_that("Palettes are distinct", {
  ok <- bde_tidy_palettes(n = 6)
  other <- bde_tidy_palettes(n = 6, palette = "bde_rose_pal")
  expect_length(intersect(ok, other), 0)

  other2 <- bde_tidy_palettes(n = 6, palette = "bde_qual_pal")
  expect_length(intersect(ok, other2), 0)
  expect_length(intersect(other, other2), 0)
})

test_that("Palette size controls the returned prefix", {
  ok <- bde_tidy_palettes(n = 6)
  ok3 <- bde_tidy_palettes(n = 3)

  expect_identical(ok[seq_len(3)], ok3)
})

test_that("Palettes can be reversed", {
  ok <- bde_tidy_palettes(n = 6)
  ok3 <- bde_tidy_palettes(n = 3, rev = TRUE)

  expect_identical(ok[rev(seq_len(3))], ok3)
})

test_that("Palettes can apply alpha transparency", {
  ok <- bde_tidy_palettes(n = 6)
  ok3 <- bde_tidy_palettes(n = 6, alpha = 0.2)

  expect_identical(ggplot2::alpha(ok, 0.2), ok3)
})
