test_that("bde_vivid_pal", {
  skip_if_not_installed("lifecycle")
  expect_snapshot(vpal <- bde_vivid_pal()(3))

  expect_identical(
    bde_tidy_palettes(n = 3, "bde_vivid_pal"),
    vpal
  )
})

test_that("bde_rose_pal", {
  skip_if_not_installed("lifecycle")
  expect_snapshot(vpal <- bde_rose_pal()(4))

  expect_identical(
    bde_tidy_palettes(n = 4, "bde_rose_pal"),
    vpal
  )
})
