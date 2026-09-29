skip_if_not_installed("DBItest")
skip_if_not_installed("adbcsqlite")

if (
  identical(Sys.getenv("NOT_CRAN"), "true") &&
    packageVersion("DBItest") >= "1.7.2"
) {
  DBItest::test_all(
    skip = c(
      "package_name",

      # need options(adbi.allow_multiple_results = FALSE)
      # https://github.com/r-dbi/adbi/issues/109
      "send_query_only_one_result_set",
      "send_statement_only_one_result_set",
      "arrow_send_query_only_one_result_set",

      # need options(adbi.force_close_results = TRUE)
      # https://github.com/r-dbi/adbi/issues/109
      "send_query_stale_warning",
      "send_statement_stale_warning",
      "arrow_send_query_stale_warning",

      # int/int64 https://github.com/r-dbi/DBItest/issues/311
      "data_64_bit_numeric",
      "data_64_bit_numeric_warning",
      "data_64_bit_lossless",
      "append_roundtrip_64_bit_numeric",
      "append_roundtrip_64_bit_character",
      "arrow_read_table_arrow",
      "arrow_write_table_arrow_roundtrip_integer",
      "arrow_write_table_arrow_roundtrip_logical",
      "arrow_write_table_arrow_roundtrip_character",
      "arrow_write_table_arrow_roundtrip_blob",
      "arrow_write_table_arrow_roundtrip_mixed",
      "arrow_append_table_arrow_roundtrip_integer",
      "arrow_append_table_arrow_roundtrip_logical",
      "arrow_append_table_arrow_roundtrip_character",
      "arrow_append_table_arrow_roundtrip_blob",
      "arrow_append_table_arrow_roundtrip_mixed",

      # `field.types` https://github.com/r-dbi/adbi/issues/14
      "append_roundtrip_64_bit_roundtrip",
      "roundtrip_64_bit_numeric",
      "roundtrip_64_bit_character",
      "roundtrip_64_bit_roundtrip",
      "roundtrip_field_types",

      # Lists of raw vectors with NULL entries fail in `dbDataType()`
      # https://github.com/r-dbi/adbi/issues/108
      "append_roundtrip_raw",

      # bind zero length https://github.com/apache/arrow-adbc/issues/1365
      "bind_multi_row_zero_length",
      "arrow_bind_multi_row_zero_length",
      "arrow_stream_bind_multi_row_zero_length",
      "stream_bind_multi_row_zero_length",

      # Empty and all-NULL columns read back as integer, as adbcsqlite infers
      # types from values https://github.com/apache/arrow-adbc/issues/1591
      "create_table_name",
      "create_table_name_quoted",
      "create_table_value_df",
      "create_table_value_array",
      "create_table_temporary_1",
      "create_table_row_names_default",
      "create_table_row_names_null",
      "append_table_invalid_value",
      "append_table_value_subset",
      "append_table_value_shuffle_subset",
      "write_table_value_subset",
      "write_table_value_shuffle_subset",
      "arrow_write_table_arrow_value_subset",
      "arrow_write_table_arrow_value_shuffle_subset",
      "arrow_create_table_arrow_name",
      "arrow_create_table_arrow_name_quoted",
      "arrow_create_table_arrow_value_df",
      "arrow_create_table_arrow_value_array",
      "arrow_create_table_arrow_value_stream",
      "arrow_create_table_arrow_value_schema",
      "arrow_create_table_arrow_temporary_1",
      "arrow_append_table_arrow_invalid_value",
      "arrow_append_table_arrow_value_subset",
      "arrow_append_table_arrow_value_shuffle_subset",
      "create_table_visible_in_other_connection",
      "arrow_create_table_arrow_visible_in_other_connection",

      # misc issues with well understood causes
      "quote_identifier_string", # see apache/arrow-adbc#1395
      "read_table_empty", # see apache/arrow-adbc#1400
      "arrow_read_table_arrow_empty", # see apache/arrow-adbc#1400

      # Appending to a missing table https://github.com/r-dbi/adbi/issues/107
      "append_table_new",

      # cause segfaults
      # https://github.com/r-dbi/adbi/issues/110
      "begin_write_disconnect",

      # A failed append in `write_table_append_incompatible` leaves the
      # connection in a transaction
      # https://github.com/apache/arrow-adbc/issues/4828
      "table_visible_in_other_connection",
      "remove_table_other_con",

      if (!requireNamespace("arrow", quietly = TRUE)) {
        c(
          "roundtrip_raw"
        )
      },

      if (!requireNamespace("bit64", quietly = TRUE)) {
        c(
          "connect_bigint_integer64"
        )
      },

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
