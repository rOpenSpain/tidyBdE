test_that("Discrete scale", {
  d <- data.frame(x = 1:5, y = 1:5, z = 21:25, l = letters[1:5])

  p <- ggplot2::ggplot(d) +
    ggplot2::geom_point(ggplot2::aes(x, y, color = l))

  init <- ggplot2::layer_data(p)$colour
  p2 <- p + scale_color_bde_d()

  mod <- ggplot2::layer_data(p2)$colour
  expect_true(!any(init %in% mod))

  # Renamed
  p3 <- p + scale_colour_bde_d()
  mod3 <- ggplot2::layer_data(p3)$colour
  expect_identical(mod, mod3)

  # Alpha

  p3 <- p + scale_colour_bde_d(alpha = 0.9)

  mod_alpha <- ggplot2::layer_data(p3)$colour

  expect_true(all(ggplot2::alpha(mod, 0.9) == mod_alpha))


  # Another pal
  p4 <- p + scale_color_bde_d(palette = "bde_rose_pal")
  mod4 <- ggplot2::layer_data(p4)$colour

  expect_false(any(mod == mod4))

  # Another aes
  pf <- ggplot2::ggplot(d) +
    ggplot2::geom_point(ggplot2::aes(x, y, fill = l), shape = 21)

  pfill <- pf + scale_fill_bde_d()
  colfill <- ggplot2::layer_data(pfill)$fill

  expect_identical(mod, colfill)

  pfill2 <- pf + scale_fill_bde_d(palette = "bde_rose_pal")
  colfill2 <- ggplot2::layer_data(pfill2)$fill

  expect_identical(mod4, colfill2)
})


test_that("Continous scale", {
  d <- data.frame(x = 1:5, y = 1:5, z = 21:25, l = letters[1:5])

  p <- ggplot2::ggplot(d) +
    ggplot2::geom_point(ggplot2::aes(x, y, colour = z))

  init <- ggplot2::layer_data(p)$colour
  p2 <- p + scale_color_bde_c()

  mod <- ggplot2::layer_data(p2)$colour
  expect_true(!any(init %in% mod))

  # Renamed
  p3 <- p + scale_colour_bde_c()
  mod3 <- ggplot2::layer_data(p3)$colour
  expect_identical(mod, mod3)


  # Alpha

  p3 <- p + scale_colour_bde_c(alpha = 0.9)

  mod_alpha <- ggplot2::layer_data(p3)$colour

  expect_true(all(ggplot2::alpha(mod, 0.9) == mod_alpha))

  # Another pal
  p4 <- p + scale_color_bde_c(palette = "bde_vivid_pal")
  mod4 <- ggplot2::layer_data(p4)$colour

  expect_false(any(mod == mod4))

  # Another aes
  pf <- ggplot2::ggplot(d) +
    ggplot2::geom_point(ggplot2::aes(x, y, fill = z), shape = 21)

  pfill <- pf + scale_fill_bde_c()
  colfill <- ggplot2::layer_data(pfill)$fill

  expect_identical(mod, colfill)

  pfill2 <- pf + scale_fill_bde_c(palette = "bde_vivid_pal")
  colfill2 <- ggplot2::layer_data(pfill2)$fill

  expect_identical(mod4, colfill2)
})
