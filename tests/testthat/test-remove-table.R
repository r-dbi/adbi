test_that("removing a temporary table leaves a permanent one alone", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  withr::defer(dbDisconnect(con))

  dbWriteTable(con, "x", data.frame(a = "permanent"))
  dbWriteTable(con, "x", data.frame(a = "temporary"), temporary = TRUE)

  expect_true(dbRemoveTable(con, "x", temporary = TRUE))
  expect_error(dbRemoveTable(con, "x", temporary = TRUE), "no such table")
  expect_identical(dbReadTable(con, "x"), data.frame(a = "permanent"))
})

test_that("removing a missing temporary table leaves a permanent one alone", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  withr::defer(dbDisconnect(con))

  dbWriteTable(con, "x", data.frame(a = "permanent"))

  expect_error(dbRemoveTable(con, "x", temporary = TRUE), "no such table")
  expect_true(
    dbRemoveTable(con, "x", temporary = TRUE, fail_if_missing = FALSE)
  )
  expect_identical(dbReadTable(con, "x"), data.frame(a = "permanent"))
})
