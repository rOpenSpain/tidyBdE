test_that("Discrete scales apply BdE palettes to colour and fill", {
  d <- data.frame(x = 1:5, y = 1:5, z = 21:25, l = letters[1:5])

  p <- ggplot2::ggplot(d) +
    ggplot2::geom_point(ggplot2::aes(x, y, color = l))

  p2 <- p + scale_color_bde_d()

  mod <- ggplot2::layer_data(p2)$colour
  expect_identical(
    mod,
    c("#4180C2", "#D86E7B", "#F89E63", "#5FBD6A", "#62C8D0")
  )

  p3 <- p + scale_colour_bde_d()
  mod3 <- ggplot2::layer_data(p3)$colour
  expect_identical(mod, mod3)

  p3 <- p + scale_colour_bde_d(alpha = 0.9)

  mod_alpha <- ggplot2::layer_data(p3)$colour

  expect_identical(
    mod_alpha,
    c("#4180C2E6", "#D86E7BE6", "#F89E63E6", "#5FBD6AE6", "#62C8D0E6")
  )

  p4 <- p + scale_color_bde_d(palette = "bde_rose_pal")
  mod4 <- ggplot2::layer_data(p4)$colour

  expect_identical(
    mod4,
    c("#b7365c", "#cb6e8a", "#db9aad", "#0a50a1", "#5385bd")
  )

  p5 <- p + scale_color_bde_d(palette = "bde_qual_pal")
  mod5 <- ggplot2::layer_data(p5)$colour

  expect_identical(
    mod5,
    c("#b55b4a", "#2e76bc", "#fece64", "#68be57", "#858788")
  )

  pf <- ggplot2::ggplot(d) +
    ggplot2::geom_point(ggplot2::aes(x, y, fill = l), shape = 21)

  pfill <- pf + scale_fill_bde_d()
  colfill <- ggplot2::layer_data(pfill)$fill

  expect_identical(mod, colfill)

  pfill2 <- pf + scale_fill_bde_d(palette = "bde_rose_pal")
  colfill2 <- ggplot2::layer_data(pfill2)$fill

  expect_identical(mod4, colfill2)
})

test_that("Continuous scales apply BdE palettes to colour and fill", {
  d <- data.frame(x = 1:5, y = 1:5, z = 21:25, l = letters[1:5])

  p <- ggplot2::ggplot(d) +
    ggplot2::geom_point(ggplot2::aes(x, y, colour = z))

  default_scale <- scale_color_bde_c()
  expect_identical(
    tolower(default_scale$palette(c(0, 1))),
    c("#b7365c", "#0a50a1")
  )
  p2 <- p + default_scale

  mod <- ggplot2::layer_data(p2)$colour

  p3 <- p + scale_colour_bde_c()
  mod3 <- ggplot2::layer_data(p3)$colour
  expect_identical(mod, mod3)

  p3 <- p + scale_colour_bde_c(alpha = 0.9)

  mod_alpha <- ggplot2::layer_data(p3)$colour

  expect_identical(mod_alpha, ggplot2::alpha(mod, 0.9))

  vivid_scale <- scale_color_bde_c(palette = "bde_vivid_pal")
  expect_identical(
    tolower(vivid_scale$palette(c(0, 1))),
    c("#4180c2", "#ac8771")
  )
  p4 <- p + vivid_scale
  mod4 <- ggplot2::layer_data(p4)$colour

  pf <- ggplot2::ggplot(d) +
    ggplot2::geom_point(ggplot2::aes(x, y, fill = z), shape = 21)

  pfill <- pf + scale_fill_bde_c()
  colfill <- ggplot2::layer_data(pfill)$fill

  expect_identical(mod, colfill)

  pfill2 <- pf + scale_fill_bde_c(palette = "bde_vivid_pal")
  colfill2 <- ggplot2::layer_data(pfill2)$fill

  expect_identical(mod4, colfill2)
})

test_that("Scale helpers report invalid arguments", {
  expect_snapshot(error = TRUE, scale_fill_bde_c(alpha = "a"))
  expect_snapshot(error = TRUE, scale_color_bde_c(guide = TRUE))
  expect_snapshot(error = TRUE, scale_fill_bde_d(alpha = Inf))
  expect_snapshot(error = TRUE, scale_color_bde_d(rev = Inf))
})
