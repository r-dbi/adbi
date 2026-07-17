test_that("adbi supports driver-manager inputs", {
  drv <- adbi()
  expect_null(drv@driver)
  expect_true(dbIsValid(drv))

  drv <- adbi("profile://example")
  expect_identical(drv@driver, "profile://example")
  expect_true(dbIsValid(drv))

  drv <- adbi("postgresql://localhost/database")
  expect_identical(drv@driver, "postgresql://localhost/database")
  expect_true(dbIsValid(drv))

  drv <- adbi("driver_name_that_is_not_an_r_package")
  expect_identical(drv@driver, "driver_name_that_is_not_an_r_package")
  expect_true(dbIsValid(drv))
})

test_that("adbi supports adbc_driver objects", {
  driver <- adbcdrivermanager::adbc_driver_monkey()
  drv <- adbi(driver)

  expect_identical(drv@driver, driver)
  expect_true(dbIsValid(drv))
})

test_that("legacy driver specifications are deprecated", {
  driver_function <- adbcdrivermanager::adbc_driver_monkey

  drv <- expect_warning(adbi(driver_function), "deprecated")
  expect_s3_class(drv@driver, "adbc_driver")

  skip_if_not_installed("adbcsqlite")

  drv <- expect_warning(
    adbi("adbcsqlite::adbcsqlite"),
    "deprecated"
  )
  expect_s3_class(drv@driver, "adbc_driver")

  drv <- expect_warning(adbi("adbcsqlite"), "deprecated")
  expect_s3_class(drv@driver, "adbc_driver")
})

test_that("driver functions are evaluated once", {
  calls <- 0L
  driver_function <- function() {
    calls <<- calls + 1L
    adbcdrivermanager::adbc_driver_monkey()
  }

  expect_warning(adbi(driver_function), "deprecated")
  expect_identical(calls, 1L)
})

test_that("legacy driver warnings point to adbi", {
  warning_call <- NULL

  withCallingHandlers(
    adbi(adbcdrivermanager::adbc_driver_monkey),
    warning = function(cnd) {
      warning_call <<- conditionCall(cnd)
      invokeRestart("muffleWarning")
    }
  )

  expect_identical(warning_call[[1L]], quote(adbi))
})

test_that("adbi rejects invalid drivers", {
  msg <- getFromNamespace("INVALID_DRIVER_MESSAGE", "adbi")

  expect_error(adbi(character()), msg, fixed = TRUE)
  expect_error(adbi(c("one", "two")), msg, fixed = TRUE)
  expect_error(adbi(NA_character_), msg, fixed = TRUE)
  expect_error(adbi(1), msg, fixed = TRUE)
  expect_error(
    expect_warning(adbi(function() NULL), "deprecated"),
    "must return an `adbc_driver`"
  )
})

test_that("show supports driver-manager inputs", {
  expect_output(show(adbi()), "Driver: <driver manager>", fixed = TRUE)
  expect_output(
    show(adbi("profile://example")),
    "Driver: profile://example",
    fixed = TRUE
  )
})

test_that("dbDataType works without a concrete driver", {
  expect_identical(dbDataType(adbi(), 1L), "INT")
  expect_identical(dbDataType(adbi("sqlite"), "x"), "TEXT")
  expect_error(
    dbDataType(adbi(), structure(list(as.raw(1)), class = "blob")),
    "requires a connection"
  )
})

test_that("failed connection initialization releases the database", {
  database <- new.env(parent = emptyenv())
  released <- FALSE

  testthat::local_mocked_bindings(
    adbc_database_init = function(...) database,
    adbc_connection_init = function(...) stop("connection failed"),
    .package = "adbcdrivermanager"
  )
  testthat::local_mocked_bindings(
    adbc_release = function(...) {
      released <<- TRUE
    },
    .package = "adbi"
  )

  expect_error(AdbiConnection(adbi()), "connection failed")
  expect_true(released)
})

test_that("failure after connection initialization releases all resources", {
  database <- new.env(parent = emptyenv())
  connection <- new.env(parent = emptyenv())
  released <- character()

  testthat::local_mocked_bindings(
    adbc_database_init = function(...) database,
    adbc_connection_init = function(...) connection,
    .package = "adbcdrivermanager"
  )
  testthat::local_mocked_bindings(
    adbc_release = function(x, type) {
      released <<- c(released, type)
    },
    .package = "adbi"
  )

  expect_error(
    AdbiConnection(adbi(), bigint = "not-a-bigint-mode"),
    "'arg' should be one of"
  )
  expect_identical(released, c("connection", "database"))
})
