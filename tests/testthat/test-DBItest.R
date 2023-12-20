if (identical(Sys.getenv("NOT_CRAN"), "true") &&
  packageVersion("DBItest") >= "1.7.2") {

  DBItest::test_all(
    skip = c(
      "package_name",
      "connect_bigint_integer",
      "connect_bigint_character",
      "data_logical",
      "send_query_stale_warning",
      "send_statement_stale_warning",
      "send_query_only_one_result_set",
      "send_statement_only_one_result_set",
      "quote_identifier_string",
      "create_table_visible_in_other_connection",
      "table_visible_in_other_connection",
      "begin_write_commit",
      "begin_write_disconnect",
      "read_table",
      "read_table_empty",
      "read_table_row_names_na_missing",
      "read_table_name",
      "append_roundtrip_64_bit_roundtrip",
      "write_table_overwrite",
      "write_table_append_incompatible",
      "overwrite_table",
      "overwrite_table_missing",
      "append_table",
      "append_table_new",
      "roundtrip_integer",
      "roundtrip_64_bit_numeric",
      "roundtrip_64_bit_character",
      "roundtrip_64_bit_roundtrip",
      "roundtrip_character",
      "roundtrip_raw",
      "roundtrip_blob",
      "roundtrip_field_types",
      "write_table_row_names_true_missing",
      "write_table_row_names_na_missing",
      "write_table_row_names_string_missing",
      "column_info",
      "begin_write_rollback",
      "with_transaction_success",
      "with_transaction_failure",
      "with_transaction_break",
      "bind_multi_row_zero_length",
      "bind_factor",
      "bind_raw",

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
