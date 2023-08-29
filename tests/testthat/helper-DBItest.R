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
  name = "adbi"
)
