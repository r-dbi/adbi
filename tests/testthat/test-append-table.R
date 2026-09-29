test_that("appending a list fails and leaves the table unchanged", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  withr::defer(dbDisconnect(con))

  dbWriteTable(con, "x", data.frame(a = 1.5))

  expect_error(dbAppendTable(con, "x", list(a = 2.5)), "data frame")
  expect_identical(dbReadTable(con, "x"), data.frame(a = 1.5))
})

test_that("appending a factor warns and appends it as character", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  withr::defer(dbDisconnect(con))

  dbWriteTable(con, "x", data.frame(a = "old"))

  expect_warning(
    dbAppendTable(con, "x", data.frame(a = factor("new"))),
    "factors as character"
  )
  expect_identical(dbReadTable(con, "x"), data.frame(a = c("old", "new")))
})
