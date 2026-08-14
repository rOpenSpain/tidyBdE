test_that("Theme sets BdE defaults", {
  theme <- theme_tidybde()

  expect_s3_class(theme, "theme")
  expect_identical(theme$legend.position, "bottom")
  expect_identical(theme$axis.title, ggplot2::element_blank())
  expect_s3_class(theme$panel.grid.major.y, "element_line")
  expect_identical(theme$panel.grid.major.y[["colour"]], "grey70")
  expect_identical(theme$panel.grid.major.y[["linetype"]], "dashed")
})
