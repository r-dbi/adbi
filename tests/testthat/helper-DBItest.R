DBItest::make_context(
  adbi("adbcsqlite"),
  list(
    uri = ":memory:"
  ),
  tweaks = suppressWarnings(
    DBItest::tweaks(
      dbitest_version = "1.7.3",
      constructor_relax_args = TRUE
    )
  ),
  name = "adbi",
  default_skip = c(
    "package_name",
    "connect_bigint_integer",
    "connect_bigint_numeric",
    "connect_bigint_character",
    "connect_bigint_integer64",
    # TODO: Understand why test fails in R < 3.6
    if (getRversion() < "3.6") "connect_format",
    # Fails with older DBItest
    if (packageVersion("DBItest") < "1.7.2") "reexport"
  )
)
