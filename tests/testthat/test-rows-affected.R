test_that("statements report the number of rows they change", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  withr::defer(dbDisconnect(con))

  dbWriteTable(con, "x", data.frame(a = 1:10))

  expect_equal(dbExecute(con, "DELETE FROM x WHERE a < 6"), 5)
  expect_equal(dbExecute(con, "UPDATE x SET a = a + 10 WHERE a > 8"), 2)
  expect_equal(
    dbExecute(con, "DELETE FROM x WHERE a < ?", params = list(8L)),
    2
  )
  expect_equal(dbAppendTable(con, "x", data.frame(a = 1:3)), 3)
  expect_equal(sort(dbReadTable(con, "x")$a), c(1:3, 8L, 19L, 20L))
})

test_that("a rebound statement reports the rows changed by each binding", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  withr::defer(dbDisconnect(con))

  dbWriteTable(con, "x", data.frame(a = 1:10))

  res <- dbSendStatement(con, "DELETE FROM x WHERE a > ?", immediate = FALSE)
  withr::defer(dbClearResult(res))

  dbBind(res, list(7L))
  expect_equal(dbGetRowsAffected(res), 3)
  dbBind(res, list(5L))
  expect_equal(dbGetRowsAffected(res), 2)
  expect_equal(dbReadTable(con, "x"), data.frame(a = 1:5))
})
