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
