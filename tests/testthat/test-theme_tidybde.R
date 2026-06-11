test_that("Test theme", {
  library(ggplot2)
  b1 <- ggplot()
  b2 <- ggplot() +
    theme_tidybde()
  expect_false(identical(b1, b2))
})
