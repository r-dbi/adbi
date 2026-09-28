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

test_that("overwriting a temporary table leaves a permanent one alone", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi("adbcsqlite"), uri = ":memory:")
  withr::defer(dbDisconnect(con))

  dbWriteTable(con, "x", data.frame(a = "permanent"))
  dbWriteTable(con, "x", data.frame(a = "old"), temporary = TRUE)
  dbWriteTable(
    con,
    "x",
    data.frame(b = "new"),
    temporary = TRUE,
    overwrite = TRUE
  )

  expect_identical(
    dbReadTable(con, Id(schema = "temp", table = "x")),
    data.frame(b = "new")
  )
  expect_identical(
    dbReadTable(con, Id(schema = "main", table = "x")),
    data.frame(a = "permanent")
  )
})
