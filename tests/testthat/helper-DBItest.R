DBItest::make_context(
  Kazam(),
  list(),
  tweaks = suppressWarnings(DBItest::tweaks(
    dbitest_version = "1.7.3"
  )),
  name = "RKazam",
  default_skip = c(
    # TODO: Remove when dbDisconnect() is implemented
    "can_disconnect",
    "disconnect_closed_connection",
    "disconnect_invalid_connection",
    # TODO: Remove when dbIsValid() is implemented
    "is_valid_connection",
    "is_valid_stale_connection",
    # TODO: Understand why test fails in R < 3.6
    if (getRversion() < "3.6") "connect_format",
    # Fails with older DBItest
    if (packageVersion("DBItest") < "1.7.2") "reexport",
    NULL
  )
)
