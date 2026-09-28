sqlite_manifest <- function(dir) {
  loadNamespace("adbcsqlite")
  path <- file.path(dir, "adbi_test_sqlite.toml")
  writeLines(
    c(
      "manifest_version = 1",
      "",
      "[ADBC]",
      "version = 'v1.1.0'",
      "",
      "[Driver]",
      sprintf("shared = '%s'", getLoadedDLLs()[["adbcsqlite"]][["path"]]),
      "entrypoint = 'AdbcDriverSqliteInit'"
    ),
    path
  )
  path
}
