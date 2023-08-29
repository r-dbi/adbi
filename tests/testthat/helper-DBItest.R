DBItest::make_context(
  adbi(),
  list(),
  tweaks = suppressWarnings(
    DBItest::tweaks(
      dbitest_version = "1.7.3",
      constructor_relax_args = TRUE
    )
  ),
  name = "adbi",
  default_skip = c(
    # TODO: Understand why test fails in R < 3.6
    if (getRversion() < "3.6") "connect_format",
    # Fails with older DBItest
    if (packageVersion("DBItest") < "1.7.2") "reexport"
  )
)
