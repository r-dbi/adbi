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
