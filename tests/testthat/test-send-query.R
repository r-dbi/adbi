test_that("queries that fail to bind or run do not keep the connection open", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")

  expect_error(
    dbGetQuery(con, "SELECT ?", params = list(1L, 2L)),
    "equally many"
  )
  expect_error(
    dbGetQueryArrow(con, "SELECT ?", params = list(1L, 2L)),
    "equally many"
  )
  expect_error(
    dbSendQuery(con, "SELECT * FROM missing", immediate = TRUE),
    "no such table"
  )
  expect_error(
    dbSendQueryArrow(con, "SELECT * FROM missing", immediate = TRUE),
    "no such table"
  )
  expect_true(dbDisconnect(con))
})

test_that("result ids stay distinct past 2^31 and 1e15 on one connection", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")

  for (last in list(.Machine$integer.max - 1L, 1e15 - 1)) {
    meta(con, "last_result_id") <- last

    results <- lapply(1:3, function(i) dbSendQuery(con, "SELECT 1"))
    expect_length(meta(con, "results"), 3L)

    for (res in results) {
      dbClearResult(res)
    }
  }

  expect_true(dbDisconnect(con))
})

test_that("a connection sends no more results than it can count", {
  skip_if_not_installed("adbcsqlite")

  con <- dbConnect(adbi(pkg = "adbcsqlite"), uri = ":memory:")
  meta(con, "last_result_id") <- 2^53 - 1

  res <- dbSendQuery(con, "SELECT 1")
  expect_identical(meta(res, "id"), "9007199254740992")
  expect_error(dbSendQuery(con, "SELECT 2"), "more than 2\\^53 results")

  dbClearResult(res)
  expect_true(dbDisconnect(con))
})
