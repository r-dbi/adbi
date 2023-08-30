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
      "send_statement_stale_warning",
      "send_query_only_one_result_set",
      "send_statement_only_one_result_set",
      "data_raw", # apache/arrow-adbc#1004
      "data_64_bit_numeric_warning", # apache/arrow-adbc#1005
      "data_64_bit_lossless", # apache/arrow-adbc#1005
      "quote_identifier_string",
      "create_table_visible_in_other_connection",
      "table_visible_in_other_connection",
      "bind_return_value",
      "bind_too_many",
      "bind_not_enough",
      "bind_wrong_name",
      "bind_named_param_unnamed_placeholders",
      "bind_named_param_empty_placeholders",
      "bind_named_param_na_placeholders",
      "bind_unnamed_param_named_placeholders",
      "bind_multi_row",
      "bind_multi_row_zero_length",
      "bind_repeated",
      "bind_repeated_untouched",
      "bind_named_param_shuffle",
      "bind_integer",
      "bind_numeric",
      "bind_logical",
      "bind_character",
      "bind_character_escape",
      "bind_factor",
      "bind_raw",
      "bind_blob",
      "fetch_no_return_value",
      "begin_write_commit",
      "begin_write_disconnect",
      # TODO: Understand why test fails in R < 3.6
      if (getRversion() < "3.6") "connect_format",
      # Fails with older DBItest
      if (packageVersion("DBItest") < "1.7.2") "reexport"
    )
  )
}
