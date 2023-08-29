if (identical(Sys.getenv("NOT_CRAN"), "true") &&
    packageVersion("DBItest") >= "1.7.2") {

  DBItest::test_all(
    skip = c(
      "package_name",
      "connect_bigint_integer",
      "connect_bigint_numeric",
      "connect_bigint_character",
      "connect_bigint_integer64",
      "send_query_stale_warning",
      "send_query_only_one_result_set",
      # TODO: Understand why test fails in R < 3.6
      if (getRversion() < "3.6") "connect_format",
      # Fails with older DBItest
      if (packageVersion("DBItest") < "1.7.2") "reexport"
    )
  )
}
