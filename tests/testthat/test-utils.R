test_that("dbDataType for blob", {
  expect_identical(
    db_data_type_blob(
      structure(list(), class = "adbcsqlite_driver_sqlite")
    ),
    "BLOB"
  )

  expect_identical(
    db_data_type_blob(
      structure(list(), class = "adbcpostgresql_driver_postgresql")
    ),
    "bytea"
  )

  expect_error(db_data_type_blob(structure(list(), class = "foo")))
})

test_that("dbDataType for blob falls back to the connection's vendor", {
  blob <- structure(list(), class = "blob")

  con <- dbConnect(adbi())
  withr::defer(dbDisconnect(con))
  expect_error(dbDataType(con, blob), "unknown for type adbc_driver_monkey")

  skip_if_not_installed("adbcsqlite")

  drv <- adbi(sqlite_manifest(withr::local_tempdir()))
  sqlite <- dbConnect(drv, uri = ":memory:")
  withr::defer(dbDisconnect(sqlite))

  expect_identical(dbDataType(sqlite, blob), "BLOB")
  expect_error(dbDataType(drv, blob), "unknown for type adbc_driver")
})
