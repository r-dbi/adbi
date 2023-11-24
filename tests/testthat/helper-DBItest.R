DBItest::make_context(
  adbi::adbi("adbcsqlite"),
  list(
    uri = tempfile("DBItest", fileext = ".sqlite")
  ),
  tweaks = suppressWarnings(
    DBItest::tweaks(
      dbitest_version = "1.7.3",
      constructor_relax_args = TRUE,
      placeholder_pattern = c("?", "$1", "$name", ":name"),
      date_cast = function(x) paste0("'", x, "'"),
      time_cast = function(x) paste0("'", x, "'"),
      timestamp_cast = function(x) paste0("'", x, "'"),
      logical_return = function(x) bit64::as.integer64(x),
      date_typed = FALSE,
      time_typed = FALSE,
      timestamp_typed = FALSE,
      temporary_tables = FALSE, # apache/arrow-adbc#1141
      strict_identifier = TRUE
    )
  ),
  name = "adbi"
)
