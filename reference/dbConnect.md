# Adbi driver

In order to open a database connection,
[`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)
dispatches on a driver object, which can be instantiated by calling
`adbi()`.

## Usage

``` r
adbi(driver = NA_character_)

# S4 method for class 'AdbiDriver'
dbConnect(drv, ..., bigint = NULL)

# S4 method for class 'AdbiConnection'
dbDisconnect(conn, force = getOption("adbi.force_close_results", FALSE), ...)
```

## Arguments

- driver:

  A driver specification that can be evaluated (with no arguments) to
  give an
  [`adbcdrivermanager::adbc_driver()`](https://arrow.apache.org/adbc/current/r/adbcdrivermanager/reference/adbc_driver_void.html).
  See Details for more information.

- drv:

  An object that inherits from
  [DBI::DBIDriver](https://dbi.r-dbi.org/reference/DBIDriver-class.html),
  or an existing
  [DBI::DBIConnection](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object (in order to clone an existing connection).

- ...:

  Extra arguments passed to
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)
  are forwarded to
  [`adbcdrivermanager::adbc_database_init()`](https://arrow.apache.org/adbc/current/r/adbcdrivermanager/reference/adbc_database_init.html)

- bigint:

  The R type that 64-bit integer types should be mapped to, default is
  [bit64::integer64](https://rdrr.io/pkg/bit64/man/bit64-package.html),
  if bit64 is installed and `character` otherwise

- conn:

  A
  [DBI::DBIConnection](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).

- force:

  Close open results when disconnecting

## Value

A connection object (S4 class `AdbiCOnnection`, inheriting from
[DBI::DBIConnection](https://dbi.r-dbi.org/reference/DBIConnection-class.html))
is returned by
[`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html),
while
[`DBI::dbDisconnect()`](https://dbi.r-dbi.org/reference/dbDisconnect.html)
returns `TRUE` invisibly.

## Details

To specify the type of adbc driver, `adbi` accepts as `driver` argument

- an object inheriting from `adbc_driver`,

- a function that can be evaluated with no arguments and returns an
  object inheriting from `adbc_driver`,

- a string of the form `pkg::fun` (where `pkg::` is optional and
  defaults to `fun`), which can be used to look up such a function.

As default, an
[`adbcdrivermanager::adbc_driver_monkey()`](https://arrow.apache.org/adbc/current/r/adbcdrivermanager/reference/adbc_driver_monkey.html)
object is created.

## Examples

``` r
adbi()
#> <AdbiDriver>
#>   Type: <adbc_driver_monkey>
if (requireNamespace("adbcsqlite")) {
  adbi("adbcsqlite")
}
#> Loading required namespace: adbcsqlite
#> <AdbiDriver>
#>   Type: <adbcsqlite_driver_sqlite>
library(DBI)
con <- dbConnect(adbi())
dbIsValid(con)
#> [1] TRUE
dbDisconnect(con)
dbIsValid(con)
#> [1] FALSE
```
