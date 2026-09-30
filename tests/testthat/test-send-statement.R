test_that("statements run without a call to `dbGetRowsAffected()`", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  withr::defer(dbDisconnect(con))

  dbExecute(con, "CREATE TABLE x (a INTEGER)")

  res <- dbSendStatement(con, "INSERT INTO x VALUES (1)")
  dbClearResult(res)

  res <- dbSendStatement(con, "INSERT INTO x VALUES (?)", params = list(2L))
  dbClearResult(res)

  res <- dbSendStatement(con, "INSERT INTO x VALUES (?)")
  dbBind(res, list(3L))
  expect_true(dbHasCompleted(res))
  dbBind(res, list(4L))
  expect_equal(dbGetRowsAffected(res), 1)
  dbClearResult(res)

  expect_equal(dbReadTable(con, "x"), data.frame(a = 1:4))
})

test_that("statements that fail to run do not keep the connection open", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")

  dbExecute(con, "CREATE TABLE x (a INTEGER PRIMARY KEY)")
  dbExecute(con, "INSERT INTO x VALUES (1)")

  expect_error(dbExecute(con, "INSERT INTO x VALUES (1)"), "UNIQUE")
  expect_error(
    dbExecute(con, "INSERT INTO x VALUES (?)", params = list(1L)),
    "UNIQUE"
  )
  expect_error(
    dbSendStatement(con, "INSERT INTO x VALUES (1)", immediate = TRUE),
    "UNIQUE"
  )
  expect_true(dbDisconnect(con))
})
