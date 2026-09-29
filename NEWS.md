# adbi (development version)

- `adbi()` now accepts ADBC Driver Manager driver names and manifest paths.
  The new `pkg` argument explicitly selects an R package driver. Strings of the
  form `pkg::fun` are deprecated in favour of `adbi("fun", pkg = "pkg")` (#60).
- Binding logical, integer, numeric or character values, or lists of raw
  vectors, with `dbBind()` no longer requires the arrow package (#82).
- Queries and statements now work without `immediate = TRUE` with drivers
  that cannot report parameter metadata, such as Snowflake's. With such
  drivers, parameters are bound without checking their number or names (#4).
- After a bound statement has run, `dbHasCompleted()` now returns `TRUE`, and
  binding it again no longer warns that not all data may have been fetched
  (#69).
- Overwriting a table with `dbWriteTable()` no longer drops it and then fails,
  and works for temporary tables too. The table is now replaced, or created if
  it does not exist yet, through ADBC's `replace` ingest mode, which adbcsqlite
  supports from version 0.11.0.1 (#72, #91).
- Binding POSIXlt timestamps with `dbBind()` no longer fails with an
  unsupported struct type. They are now bound as the equivalent POSIXct
  values (#89).
- Removing a temporary table with `dbRemoveTable(temporary = TRUE)` no longer
  fails with a syntax error on SQLite, PostgreSQL and DuckDB. The table name
  is now qualified with the schema of temporary tables there, so a permanent
  table of the same name is left alone (#91).
- Calling `dbExistsTable()`, `dbListTables()`, `dbListFields()` or
  `dbGetInfo()` on a connection, or printing it, no longer keeps a following
  `dbDisconnect()` from closing the connection. These calls left the ADBC
  streams they read unreleased until the next garbage collection (#97).

# adbi 0.1.3

- A `dbConnect()` call that fails partway now releases the ADBC database and
  connection it had already created (#59).
- For a `dbSendStatement()` result that has not been bound yet,
  `dbHasCompleted()` now returns `FALSE` and `dbGetRowsAffected()` returns
  `NA` (#32).
- Requires R >= 4.1.0 (#71).

# adbi 0.1.2 (2025-09-03)

- Docs only update

# adbi 0.1.1 (2024-01-25)

- Update for adbcdrivermanager 0.9.0.1

# adbi 0.1.0 (2023-12-21)

- Update for DBI 1.2.0
- Adds arrow API extension

# adbi 0.0.2 (2023-12-08)

- Initial CRAN release

# adbi 0.0.1 (2023-12-07)

- Target DBI 1.1.3
