test_that("show methods print", {
  expect_output(show(adbi()))

  skip_if_not_installed("adbcsqlite")

  drv <- adbi("adbcsqlite::adbcsqlite")

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
