local_parameter_connection <- function(
  metadata = FALSE,
  .env = parent.frame()
) {
  skip_if_not_installed("adbcsqlite")

  calls <- new.env(parent = emptyenv())
  calls$schema <- 0L

  if (!metadata) {
    local_mocked_bindings(
      adbc_statement_get_parameter_schema = function(...) {
        calls$schema <- calls$schema + 1L
        error <- simpleError("Parameter metadata unavailable")
        class(error) <- c("adbc_status_not_implemented", class(error))
        stop(error)
      },
      .package = "adbcdrivermanager",
      .env = .env
    )
  }

  con <- dbConnect(adbi("adbcsqlite"), uri = ":memory:")
  withr::defer({
    clear_results(con)
    dbDisconnect(con)
  }, envir = .env)

  list(con = con, calls = calls)
}

test_that("queries without parameter metadata execute on fetch", {
  driver <- local_parameter_connection()
  con <- driver$con
  dbExecute(con, "CREATE TABLE t (x INTEGER)")

  for (arrow in c(FALSE, TRUE)) {
    send <- if (arrow) dbSendQueryArrow else dbSendQuery
    fetch <- if (arrow) dbFetchArrow else dbFetch
    dbExecute(con, "DELETE FROM t")

    res <- send(con, "INSERT INTO t VALUES (1) RETURNING x")
    expect_false(dbHasCompleted(res))
    expect_identical(dbGetRowCount(res), 0L)
    expect_equal(dbGetQuery(con, "SELECT COUNT(*) AS n FROM t")$n, 0L)
    expect_equal(as.data.frame(fetch(res)), data.frame(x = 1L))
    expect_true(dbHasCompleted(res))
    expect_equal(dbGetQuery(con, "SELECT x FROM t"), data.frame(x = 1L))
    expect_equal(nrow(as.data.frame(fetch(res))), 0L)
    dbClearResult(res)
  }
})

test_that("binding and rebinding work without parameter metadata", {
  driver <- local_parameter_connection()

  for (immediate in list(NULL, FALSE)) {
    schemas <- driver$calls$schema
    res <- dbSendQuery(driver$con, "SELECT ? AS x", immediate = immediate)

    for (values in list(2:3, 4:5)) {
      dbBind(res, list(values))
      expect_false(dbHasCompleted(res))
      expect_identical(dbGetRowCount(res), 0L)
      expect_equal(dbFetch(res)[[1L]], values)
      expect_true(dbHasCompleted(res))
    }

    expect_identical(driver$calls$schema, schemas + 1L)
    dbClearResult(res)
  }
})

test_that("Arrow parameters work without parameter metadata", {
  driver <- local_parameter_connection()
  res <- dbSendQueryArrow(driver$con, "SELECT ? AS x")
  params <- data.frame(x = 2:3)

  dbBindArrow(res, nanoarrow::as_nanoarrow_array_stream(params))
  expect_equal(as.data.frame(dbFetchArrow(res)), params)
})

test_that("convenience methods work without parameter metadata", {
  driver <- local_parameter_connection()
  con <- driver$con

  expect_equal(dbGetQuery(con, "SELECT 1 AS x"), data.frame(x = 1L))
  expect_equal(
    as.data.frame(dbGetQueryArrow(con, "SELECT 1 AS x")),
    data.frame(x = 1L)
  )
  expect_equal(dbGetQuery(con, "SELECT ?", params = list(7L))[[1L]], 7L)
  expect_equal(
    as.data.frame(dbGetQueryArrow(con, "SELECT ?", params = list(7L)))[[1L]],
    7L
  )
  dbExecute(con, "CREATE TABLE t (x INTEGER)")
  dbExecute(con, "INSERT INTO t VALUES (0)")
  dbExecute(con, "UPDATE t SET x = 1")
  expect_equal(dbGetQuery(con, "SELECT x FROM t"), data.frame(x = 1L))
  dbExecute(con, "UPDATE t SET x = ?", params = list(7L))
  expect_equal(dbGetQuery(con, "SELECT x FROM t"), data.frame(x = 7L))
})

test_that("statements with unknown parameters complete after execution", {
  driver <- local_parameter_connection()
  dbExecute(driver$con, "CREATE TABLE t (x INTEGER)")
  dbExecute(driver$con, "INSERT INTO t VALUES (0)")

  for (immediate in list(NULL, FALSE)) {
    res <- dbSendStatement(
      driver$con,
      "UPDATE t SET x = ?",
      immediate = immediate
    )
    expect_false(dbHasCompleted(res))

    if (isFALSE(immediate)) {
      expect_identical(dbGetRowsAffected(res), NA_integer_)
    } else {
      expect_error(dbGetRowsAffected(res), "parameter count mismatch")
    }

    for (value in 1:2) {
      dbBind(res, list(value))
      expect_false(dbHasCompleted(res))
      dbGetRowsAffected(res)
      expect_true(dbHasCompleted(res))
      expect_equal(dbGetQuery(driver$con, "SELECT x FROM t")$x, value)
    }

    dbClearResult(res)
  }
})

test_that("explicit execution modes retain their behavior", {
  driver <- local_parameter_connection()
  con <- driver$con
  dbExecute(con, "CREATE TABLE t (x INTEGER)")
  schemas <- driver$calls$schema
  res <- dbSendQuery(
    con,
    "INSERT INTO t VALUES (1) RETURNING x",
    immediate = TRUE
  )

  expect_identical(driver$calls$schema, schemas)
  expect_equal(
    dbGetQuery(con, "SELECT x FROM t", immediate = TRUE),
    data.frame(x = 1L)
  )
  expect_error(dbBind(res, list(1L)), "immediate = FALSE", fixed = TRUE)
  expect_equal(dbFetch(res), data.frame(x = 1L))
  dbClearResult(res)

  res <- dbSendQuery(driver$con, "SELECT ?", immediate = FALSE)
  expect_error(dbFetch(res), "immediate = FALSE", fixed = TRUE)
  dbClearResult(res)
})

test_that("empty parameter schemas are distinct from unavailable metadata", {
  driver <- local_parameter_connection(metadata = TRUE)
  res <- dbSendQuery(driver$con, "SELECT 1 AS x")

  expect_error(dbBind(res, list(1L)), "immediate = FALSE", fixed = TRUE)
  expect_equal(dbFetch(res), data.frame(x = 1L))
})

test_that("metadata errors other than NOT_IMPLEMENTED propagate", {
  driver <- local_parameter_connection()
  local_mocked_bindings(
    adbc_statement_get_parameter_schema = function(...) {
      stop("NOT_IMPLEMENTED text in an unrelated error")
    },
    .package = "adbcdrivermanager"
  )

  expect_error(dbSendQuery(driver$con, "SELECT 1"), "unrelated error")
  res <- dbSendQuery(driver$con, "SELECT ?", immediate = FALSE)
  expect_error(dbBind(res, list(1L)), "unrelated error")
})

test_that("unsupported preparation is not treated as unavailable metadata", {
  driver <- local_parameter_connection()
  error <- simpleError("Preparation is unsupported")
  class(error) <- c("adbc_status_not_implemented", class(error))
  local_mocked_bindings(
    adbc_statement_prepare = function(...) stop(error),
    .package = "adbcdrivermanager"
  )

  expect_error(
    dbSendQuery(driver$con, "SELECT 1"),
    "Preparation is unsupported"
  )
  res <- dbSendQuery(driver$con, "SELECT ?", immediate = FALSE)
  expect_error(dbBind(res, list(1L)), "Preparation is unsupported")
  expect_identical(driver$calls$schema, 0L)
})

test_that("failed execution leaves the result available for binding", {
  driver <- local_parameter_connection()
  res <- dbSendQuery(driver$con, "SELECT ?")

  expect_error(dbFetch(res), "parameter count mismatch")
  expect_true(dbIsValid(res))
  expect_false(dbHasCompleted(res))
  expect_identical(dbGetRowCount(res), 0L)

  dbBind(res, list(7L))
  expect_equal(dbFetch(res)[[1L]], 7L)
})
