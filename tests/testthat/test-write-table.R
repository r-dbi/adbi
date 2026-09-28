test_that("overwriting replaces an existing table", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi("adbcsqlite"), uri = ":memory:")
  withr::defer(dbDisconnect(con))

  dbWriteTable(con, "x", data.frame(a = c(1, 2, 3)))
  dbWriteTable(con, "x", data.frame(b = "new"), overwrite = TRUE)

  expect_identical(dbReadTable(con, "x"), data.frame(b = "new"))
})

test_that("overwriting creates a missing table", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi("adbcsqlite"), uri = ":memory:")
  withr::defer(dbDisconnect(con))

  dbWriteTable(con, "x", data.frame(a = "new"), overwrite = TRUE)

  expect_identical(dbReadTable(con, "x"), data.frame(a = "new"))
})
