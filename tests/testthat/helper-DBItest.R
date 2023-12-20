DBItest::make_context(
  adbi::adbi("adbcsqlite"),
  list(
    uri = tempfile("DBItest", fileext = ".sqlite"),
    rows_affected_callback = function() function(x) {
      if (x == -1) testthat::skip("unknown number of `rows_affected`") else x
    }
  ),
  tweaks = suppressWarnings(
    DBItest::tweaks(
      dbitest_version = "1.7.3",
      constructor_relax_args = TRUE,
      placeholder_pattern = c("?", "$1", "$name", ":name"),
      date_cast = function(x) paste0("'", x, "'"),
      time_cast = function(x) paste0("'", x, "'"),
      timestamp_cast = function(x) paste0("'", x, "'"),
      logical_return = function(x) as.integer(x),
      date_typed = FALSE,
      time_typed = FALSE,
      timestamp_typed = FALSE,
      temporary_tables = FALSE, # apache/arrow-adbc#1141
      strict_identifier = TRUE
    )
  ),
  name = "adbi"
)
