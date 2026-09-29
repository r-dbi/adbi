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

test_that("looking up the vendor leaves the connection free to close", {
  skip_if_not_installed("adbcsqlite")

  drv <- adbi(sqlite_manifest(withr::local_tempdir()))
  con <- dbConnect(drv, uri = ":memory:")

  dbWriteTable(con, "x", data.frame(a = 1), temporary = TRUE)
  expect_true(dbRemoveTable(con, "x", temporary = TRUE))

  dbDisconnect(con)
  expect_false(dbIsValid(con))
})

test_that("other databases get the `TEMPORARY` keyword", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  withr::defer(dbDisconnect(con))
  local_mocked_bindings(db_vendor_name = function(...) NA_character_)

  dbWriteTable(con, "x", data.frame(a = "permanent"))

  expect_error(dbRemoveTable(con, "x", temporary = TRUE), "TEMPORARY")
  expect_identical(dbReadTable(con, "x"), data.frame(a = "permanent"))
})
