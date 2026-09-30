# Changelog

## adbi (development version)

- [`adbi()`](https://adbi.r-dbi.org/reference/dbConnect.md) now accepts
  ADBC Driver Manager driver names and manifest paths. The new `pkg`
  argument explicitly selects an R package driver. Strings of the form
  `pkg::fun` are deprecated in favour of `adbi("fun", pkg = "pkg")`
  ([\#60](https://github.com/r-dbi/adbi/issues/60)).
- Binding logical, integer, numeric or character values, or lists of raw
  vectors, with
  [`dbBind()`](https://dbi.r-dbi.org/reference/dbBind.html) no longer
  requires the arrow package
  ([\#82](https://github.com/r-dbi/adbi/issues/82)).
- Queries and statements now work without `immediate = TRUE` with
  drivers that cannot report parameter metadata, such as Snowflake’s.
  With such drivers, parameters are bound without checking their number
  or names ([\#4](https://github.com/r-dbi/adbi/issues/4)).
- After a bound statement has run,
  [`dbHasCompleted()`](https://dbi.r-dbi.org/reference/dbHasCompleted.html)
  now returns `TRUE`, and binding it again no longer warns that not all
  data may have been fetched
  ([\#69](https://github.com/r-dbi/adbi/issues/69)).
- Overwriting a table with
  [`dbWriteTable()`](https://dbi.r-dbi.org/reference/dbWriteTable.html)
  no longer drops it and then fails, and works for temporary tables too.
  The table is now replaced, or created if it does not exist yet,
  through ADBC’s `replace` ingest mode, which adbcsqlite supports from
  version 0.11.0.1 ([\#72](https://github.com/r-dbi/adbi/issues/72),
  [\#91](https://github.com/r-dbi/adbi/issues/91)).
- Binding POSIXlt timestamps with
  [`dbBind()`](https://dbi.r-dbi.org/reference/dbBind.html) no longer
  fails with an unsupported struct type. They are now bound as the
  equivalent POSIXct values
  ([\#89](https://github.com/r-dbi/adbi/issues/89)).
- Removing a temporary table with `dbRemoveTable(temporary = TRUE)` no
  longer fails with a syntax error on SQLite, PostgreSQL and DuckDB. The
  table name is now qualified with the schema of temporary tables there,
  so a permanent table of the same name is left alone
  ([\#91](https://github.com/r-dbi/adbi/issues/91)).
- Calling
  [`dbExistsTable()`](https://dbi.r-dbi.org/reference/dbExistsTable.html),
  [`dbListTables()`](https://dbi.r-dbi.org/reference/dbListTables.html),
  [`dbListFields()`](https://dbi.r-dbi.org/reference/dbListFields.html)
  or [`dbGetInfo()`](https://dbi.r-dbi.org/reference/dbGetInfo.html) on
  a connection, or printing it, no longer keeps a following
  [`dbDisconnect()`](https://dbi.r-dbi.org/reference/dbDisconnect.html)
  from closing the connection. These calls left the ADBC streams they
  read unreleased until the next garbage collection
  ([\#97](https://github.com/r-dbi/adbi/issues/97)).
- Appending anything but a data frame with
  [`dbAppendTable()`](https://dbi.r-dbi.org/reference/dbAppendTable.html)
  now fails, as the DBI specification requires. A list used to be
  appended as if it were a data frame. Factor columns are still appended
  as character, but now with a warning
  ([\#95](https://github.com/r-dbi/adbi/issues/95)).
- The row counts that
  [`dbExecute()`](https://dbi.r-dbi.org/reference/dbExecute.html),
  [`dbGetRowsAffected()`](https://dbi.r-dbi.org/reference/dbGetRowsAffected.html)
  and
  [`dbAppendTable()`](https://dbi.r-dbi.org/reference/dbAppendTable.html)
  return are now the number of rows changed, where adbcsqlite reported
  `-1` for every statement, and adbcpostgresql for those with bound
  parameters. Statements from
  [`dbSendStatement()`](https://dbi.r-dbi.org/reference/dbSendStatement.html)
  no longer ask the driver for a result set. With adbcsqlite, a
  statement that changes no rows, such as `CREATE TABLE`, reports the
  count of the last `INSERT`, `UPDATE` or `DELETE` until
  apache/arrow-adbc#4820 is fixed
  ([\#92](https://github.com/r-dbi/adbi/issues/92)).
- Statements from
  [`dbSendStatement()`](https://dbi.r-dbi.org/reference/dbSendStatement.html)
  now run before it returns, or, if they have placeholders, each time
  they are bound with
  [`dbBind()`](https://dbi.r-dbi.org/reference/dbBind.html), as the DBI
  specification requires. Unless sent with `immediate = TRUE`, they used
  to run only once
  [`dbGetRowsAffected()`](https://dbi.r-dbi.org/reference/dbGetRowsAffected.html)
  asked for their count, so a statement cleared without that call never
  ran. With drivers that cannot report parameter metadata, only
  statements sent with `immediate = TRUE` or `params` run before
  [`dbSendStatement()`](https://dbi.r-dbi.org/reference/dbSendStatement.html)
  returns. A statement that fails to run there no longer keeps
  [`dbDisconnect()`](https://dbi.r-dbi.org/reference/dbDisconnect.html)
  from closing the connection
  ([\#113](https://github.com/r-dbi/adbi/issues/113)).

## adbi 0.1.3

- A [`dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html) call
  that fails partway now releases the ADBC database and connection it
  had already created ([\#59](https://github.com/r-dbi/adbi/issues/59)).
- For a
  [`dbSendStatement()`](https://dbi.r-dbi.org/reference/dbSendStatement.html)
  result that has not been bound yet,
  [`dbHasCompleted()`](https://dbi.r-dbi.org/reference/dbHasCompleted.html)
  now returns `FALSE` and
  [`dbGetRowsAffected()`](https://dbi.r-dbi.org/reference/dbGetRowsAffected.html)
  returns `NA` ([\#32](https://github.com/r-dbi/adbi/issues/32)).
- Requires R \>= 4.1.0
  ([\#71](https://github.com/r-dbi/adbi/issues/71)).

## adbi 0.1.2 (2025-09-03)

- Docs only update

## adbi 0.1.1 (2024-01-25)

- Update for adbcdrivermanager 0.9.0.1

## adbi 0.1.0 (2023-12-21)

- Update for DBI 1.2.0
- Adds arrow API extension

## adbi 0.0.2 (2023-12-08)

- Initial CRAN release

## adbi 0.0.1 (2023-12-07)

- Target DBI 1.1.3
