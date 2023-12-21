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
      "connect_bigint_character", # arrow-nanoarrow#324
      "data_logical", # r-dbi/DBItest#308
      "create_table_visible_in_other_connection", # r-dbi/DBItest#297

      # misc issues with poorly understood causes
      "quote_identifier_string", # no error produced
      "begin_write_commit", # visibility issue
      "append_table_new", # SQL error
      "roundtrip_raw", # unknown arrow type for `AsIs`
      "column_info",
      "bind_raw",
      "arrow_bind_raw",
      "bind_factor", # no warnings?
      "arrow_bind_factor", # no warnings?
      "read_table_empty",
      "list_objects_features",

      # cause segfaults
      "begin_write_disconnect",

      if (getRversion() < "4.0") {
        c(
          "column_info_consistent_keywords",
          "column_info_consistent_unnamed",
          "column_info_consistent",
          "column_info_row_names"
        )
      }
    )
  )
}
