# adbi 0.1.3

- A `dbConnect()` call that fails partway now releases the ADBC database and
  connection it had already created (#59).
- For a `dbSendStatement()` result that has not been bound yet,
  `dbHasCompleted()` now returns `FALSE` and `dbGetRowsAffected()` returns
  `NA` (#32).
- Requires R >= 4.1.0 (#71).

# adbi 0.1.2 (2024-09-03)

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
