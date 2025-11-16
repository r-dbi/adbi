if (identical(Sys.getenv("NOT_CRAN"), "true") &&
  packageVersion("DBItest") >= "1.7.2") {

  DBItest::test_all(
    skip = c(
      "package_name",

      # options(adbi.allow_multiple_results = FALSE)
      "send_query_only_one_result_set",
      "send_statement_only_one_result_set",
      "arrow_send_query_only_one_result_set",

      # options(adbi.force_close_results = TRUE)
      "send_query_stale_warning",
      "send_statement_stale_warning",
      "arrow_send_query_stale_warning",

      # int/int64 https://github.com/r-dbi/DBItest/issues/311
      "data_64_bit_numeric",
      "data_64_bit_numeric_warning",
      "data_64_bit_lossless",
      "arrow_read_table_arrow",

      # `field.types` https://github.com/r-dbi/adbi/issues/14
      "append_roundtrip_64_bit_roundtrip",
      "roundtrip_64_bit_numeric",
      "roundtrip_64_bit_character",
      "roundtrip_64_bit_roundtrip",
      "roundtrip_field_types",

      # bind zero length https://github.com/apache/arrow-adbc/issues/1365
      "bind_multi_row_zero_length",
      "arrow_bind_multi_row_zero_length",
      "arrow_stream_bind_multi_row_zero_length",
      "stream_bind_multi_row_zero_length",

      # misc issues with well understood causes
      "create_table_visible_in_other_connection", # apache/arrow-adbc#1591
      "quote_identifier_string", # apache/arrow-adbc#1395
      "read_table_empty", # apache/arrow-adbc#1400

      # misc issues with poorly understood causes
      "append_table_new",
      "begin_write_commit",

      # cause segfaults
      "begin_write_disconnect",

      # not reproducible in isolation
      "table_visible_in_other_connection",
      "remove_table_other_con",

      if (getRversion() < "4.0") {
        c(
          "column_info",
          "column_info_consistent_keywords",
          "column_info_consistent_unnamed",
          "column_info_consistent",
          "column_info_row_names"
        )
      }
    )
  )
}
