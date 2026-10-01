test_that("results cleared oldest first leave the connection free to close", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  res1 <- dbSendQuery(con, "SELECT 1")
  res2 <- dbSendQuery(con, "SELECT 2")

  dbClearResult(res1)
  dbClearResult(res2)

  expect_true(dbDisconnect(con))
  expect_false(dbIsValid(con))
})

test_that("a forced close clears exactly the results still open", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  res1 <- dbSendQuery(con, "SELECT 1")
  res2 <- dbSendQuery(con, "SELECT 2")
  res3 <- dbSendQuery(con, "SELECT 3")

  dbClearResult(res1)
  dbClearResult(res2)

  expect_warning(
    expect_true(dbDisconnect(con, force = TRUE)),
    "There are 1 open result"
  )
  expect_false(dbIsValid(res3))
  expect_false(dbIsValid(con))
})

test_that("a deferred close runs once the last open result is cleared", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  res1 <- dbSendQuery(con, "SELECT 1")
  res2 <- dbSendQuery(con, "SELECT 2")

  expect_message(expect_false(dbDisconnect(con)), "There are 2 result")

  dbClearResult(res1)
  expect_true(dbIsValid(con))

  dbClearResult(res2)
  expect_false(dbIsValid(con))
})
