# Changelog

## adbi (development version)

- [`adbi()`](https://adbi.r-dbi.org/reference/dbConnect.md) now accepts
  ADBC Driver Manager driver names and manifest paths. The new `pkg`
  argument explicitly selects an R package driver. Strings of the form
  `pkg::fun` are deprecated in favour of `adbi("fun", pkg = "pkg")`
  ([\#60](https://github.com/r-dbi/adbi/issues/60)).

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
