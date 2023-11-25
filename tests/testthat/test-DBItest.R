if (identical(Sys.getenv("NOT_CRAN"), "true") &&
  packageVersion("DBItest") >= "1.7.2") {

  DBItest::test_all(
    skip = c(
      "package_name",
      "connect_bigint_integer", # not compliant with silent overflow
      "connect_bigint_numeric", # not compliant with silent rounding
      "connect_bigint_character", # arrow-nanoarrow#324
      "data_logical", # r-dbi/DBItest/issues/308
      "send_query_stale_warning",
      "send_statement_stale_warning",
      "send_query_only_one_result_set",
      "send_statement_only_one_result_set",
      "quote_identifier_string",
      "create_table_visible_in_other_connection",
      "table_visible_in_other_connection", # apache/arrow-adbc#1008
      "fetch_no_return_value",
      "begin_write_commit",
      "begin_write_disconnect",
      "read_table", # apache/arrow-adbc#1008
      "read_table_empty", # apache/arrow-adbc#1008
      "read_table_row_names_true_missing", # apache/arrow-adbc#1008
      "read_table_row_names_na_missing", # apache/arrow-adbc#1008
      "read_table_row_names_string_missing", # apache/arrow-adbc#1008
      "read_table_name",
      "create_roundtrip_keywords",
      "append_roundtrip_64_bit_roundtrip",
      "write_table_overwrite",
      "write_table_append_incompatible",
      "write_table_name",
      "write_table_name_quoted",
      "overwrite_table",
      "overwrite_table_missing",
      "append_table",
      "append_table_new",
      "roundtrip_keywords",
      "roundtrip_integer",
      "roundtrip_logical",
      "roundtrip_64_bit_numeric",
      "roundtrip_64_bit_character",
      "roundtrip_64_bit_roundtrip",
      "roundtrip_character",
      "roundtrip_factor",
      "roundtrip_raw",
      "roundtrip_blob",
      "roundtrip_field_types",
      "write_table_row_names_true_exists",
      "write_table_row_names_true_missing",
      "write_table_row_names_na_exists",
      "write_table_row_names_na_missing",
      "write_table_row_names_string_exists",
      "write_table_row_names_string_missing",
      "exists_table",
      "exists_table_error",
      "exists_table_name",
      "remove_table_return",
      "remove_table_name_quoted",
      "remove_table_name",
      "bind_multi_row_unequal_length",
      "bind_multi_row_statement",
      "column_info",
      "begin_write_rollback",
      "with_transaction_success",
      "with_transaction_failure",
      "with_transaction_break",
      "list_tables", # apache/arrow-adbc#1008
      "list_objects", # apache/arrow-adbc#1008
      "list_fields", # apache/arrow-adbc#1008
      "list_objects_quote", # some issue with table not being dropped before?
      "bind_multi_row_zero_length",
      "bind_repeated",
      "bind_factor",
      "bind_raw",
      "bind_blob",

      if (getRversion() < "4.0") {
        c(
          "column_info_consistent_keywords",
          "column_info_consistent_unnamed",
          "column_info_consistent",
          "column_info_row_names"
        )
      },

      if (packageVersion("DBItest") < "1.7.2") "reexport",

      if (packageVersion("DBItest") > "1.7.2") "arrow_read_table_arrow_name"
    )
  )
}
