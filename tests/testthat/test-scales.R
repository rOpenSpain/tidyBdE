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

  # Another pal
  p4 <- p + scale_color_bde_d(palette = "bde_rose_pal")
  mod4 <- ggplot2::layer_data(p4)$colour

  expect_false(any(mod == mod4))

  # Another param
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
  skip("Not ready yet")
  d <- data.frame(x = 1:5, y = 1:5, z = 21:25, l = letters[1:5])

  p <- ggplot2::ggplot(d) +
    ggplot2::geom_point(ggplot2::aes(x, y, colour = z))

  init <- ggplot2::layer_data(p)$colour
  p2 <- p + scale_colour_terrain_c()

  mod <- ggplot2::layer_data(p2)$colour
  expect_true(!any(init %in% mod))

  # Renamed
  p3 <- p + scale_color_terrain_c()
  mod3 <- ggplot2::layer_data(p3)$colour
  expect_identical(mod, mod3)


  # Alpha
  expect_snapshot(p + scale_colour_terrain_c(alpha = -1),
    error = TRUE
  )

  p3 <- p + scale_colour_terrain_c(alpha = 0.9)

  mod_alpha <- ggplot2::layer_data(p3)$colour

  expect_true(all(adjustcolor(mod, alpha.f = 0.9) == mod_alpha))

  # Reverse also with alpha
  expect_snapshot(p + scale_colour_terrain_c(direction = 0.5),
    error = TRUE
  )



  p4 <- p + scale_colour_terrain_c(
    direction = -1,
    alpha = 0.7
  )

  mod_alpha_rev <- ggplot2::layer_data(p4)$colour


  expect_true(
    all(rev(adjustcolor(mod, alpha.f = 0.7)) == mod_alpha_rev)
  )
})
