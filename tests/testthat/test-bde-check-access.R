test_that("On CRAN", {
  skip_on_cran()
  skip_if_bde_offline()

  env_orig <- Sys.getenv("NOT_CRAN", unset = NA_character_)

  on.exit(
    {
      if (is.na(env_orig)) {
        Sys.unsetenv("NOT_CRAN")
      } else {
        Sys.setenv("NOT_CRAN" = env_orig)
      }
    },
    add = TRUE
  )

  # Imagine we are in CRAN
  Sys.setenv("NOT_CRAN" = "false")
  expect_true(on_cran())
  expect_false(bde_check_access())

  Sys.setenv("NOT_CRAN" = "")
  expect_identical(!interactive(), on_cran())
})

test_that("Check url access", {
  skip_on_cran()
  skip_if_bde_offline()

  expect_true(bde_check_access())
})

test_that("Check url access handles unreachable resources", {
  local_mocked_bindings(bde_check_url = function(...) {
    "http://ropenspain.github.io/tidyBdE/donotexist"
  })
  expect_false(bde_check_access())
})
