test_that("show methods print", {
  expect_output(show(adbi()))

  skip_if_not_installed("adbcsqlite")

  drv <- adbi(pkg = "adbcsqlite")

  expect_output(show(drv))

  con <- dbConnect(drv, uri = ":memory:")
  withr::defer(dbDisconnect(con))

  expect_output(show(con))

  res <- dbSendQuery(con, "SELECT 1 AS a")
  withr::defer(dbClearResult(res))

  expect_output(show(res))

  withr::deferred_clear()

  expect_warning(dbDisconnect(con, force = TRUE))

  expect_output(show(con))
  expect_output(show(res))
})

test_that("printing the connection labels every line", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  withr::defer(dbDisconnect(con))

  out <- capture.output(show(con))

  expect_identical(out[[1L]], "<AdbiConnection>")
  expect_match(out[-1L], "^  (Vendor|Driver) (name|version|arrow version): ")
})
