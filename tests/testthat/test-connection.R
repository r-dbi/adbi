test_that("failed connection initialization releases the database", {
  database <- NULL
  released <- list()
  database_init <- adbcdrivermanager::adbc_database_init
  release <- getFromNamespace("adbc_release", "adbi")

  testthat::local_mocked_bindings(
    adbc_database_init = function(...) {
      database <<- database_init(...)
      database
    },
    adbc_connection_init = function(...) stop("connection failed"),
    .package = "adbcdrivermanager"
  )
  testthat::local_mocked_bindings(
    adbc_release = function(x, type) {
      released[[length(released) + 1L]] <<- list(handle = x, type = type)
      release(x, type)
    },
    .package = "adbi"
  )

  expect_error(AdbiConnection(adbi()), "connection failed")
  expect_identical(vapply(released, `[[`, character(1), "type"), "database")
  expect_identical(released[[1L]]$handle, database)
  expect_false(adbcdrivermanager::adbc_xptr_is_valid(database))
})

test_that("failure after connection initialization releases all resources", {
  database <- NULL
  connection <- NULL
  released <- list()
  database_init <- adbcdrivermanager::adbc_database_init
  connection_init <- adbcdrivermanager::adbc_connection_init
  release <- getFromNamespace("adbc_release", "adbi")

  testthat::local_mocked_bindings(
    adbc_database_init = function(...) {
      database <<- database_init(...)
      database
    },
    adbc_connection_init = function(...) {
      connection <<- connection_init(...)
      connection
    },
    .package = "adbcdrivermanager"
  )
  testthat::local_mocked_bindings(
    adbc_release = function(x, type) {
      released[[length(released) + 1L]] <<- list(handle = x, type = type)
      release(x, type)
    },
    .package = "adbi"
  )

  expect_error(
    AdbiConnection(adbi(), bigint = "not-a-bigint-mode"),
    "'arg' should be one of"
  )
  expect_identical(
    vapply(released, `[[`, character(1), "type"),
    c("connection", "database")
  )
  expect_identical(released[[1L]]$handle, connection)
  expect_identical(released[[2L]]$handle, database)
  expect_false(adbcdrivermanager::adbc_xptr_is_valid(connection))
  expect_false(adbcdrivermanager::adbc_xptr_is_valid(database))
})
