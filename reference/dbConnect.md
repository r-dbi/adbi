# Adbi driver

In order to open a database connection,
[`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html)
dispatches on a driver object, which can be instantiated by calling
`adbi()`.

## Usage

``` r
adbi(driver = NA_character_, pkg = NA_character_)

# S4 method for class 'AdbiDriver'
dbConnect(drv, ..., bigint = NULL)

# S4 method for class 'AdbiConnection'
dbDisconnect(conn, force = getOption("adbi.force_close_results", FALSE), ...)
```

## Arguments

- driver:

  An ADBC driver object, a function returning one, an ADBC Driver
  Manager driver name or manifest path, or (when `pkg` is supplied) the
  name of a driver function in that package. See Details for more
  information.

- pkg:

  An R package containing a driver function, or `NA` if no R package is
  explicitly specified.

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
  [bit64::integer64](https://bit64.r-lib.org/reference/bit64-package.html),
  if bit64 is installed and `character` otherwise

- conn:

  A
  [DBI::DBIConnection](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).

- force:

  Close open results when disconnecting

## Value

A connection object (S4 class `AdbiConnection`, inheriting from
[DBI::DBIConnection](https://dbi.r-dbi.org/reference/DBIConnection-class.html))
is returned by
[`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html),
while
[`DBI::dbDisconnect()`](https://dbi.r-dbi.org/reference/dbDisconnect.html)
returns `TRUE` invisibly.

## Details

To specify the type of ADBC driver, `adbi()` accepts as `driver`
argument

- an object inheriting from `adbc_driver`,

- a function that can be evaluated with no arguments and returns an
  object inheriting from `adbc_driver`,

- an ADBC Driver Manager driver name or manifest path.

Use `pkg` to load a driver provided by an R package. By default, the
driver function has the same name as the package; supply a character
`driver` to use a different function. For example,
`adbi(pkg = "adbcsqlite")` calls
[`adbcsqlite::adbcsqlite()`](https://arrow.apache.org/adbc/current/r/adbcsqlite/reference/adbcsqlite.html),
while `adbi("adbc_driver_monkey", pkg = "adbcdrivermanager")` calls
[`adbcdrivermanager::adbc_driver_monkey()`](https://arrow.apache.org/adbc/current/r/adbcdrivermanager/reference/adbc_driver_monkey.html).

For compatibility, a character `driver` that names an installed R
package with a same-named driver function still selects that function,
so `adbi("adbcsqlite")` is equivalent to `adbi(pkg = "adbcsqlite")`.
Strings of the form `pkg::fun` are deprecated; use
`adbi("fun", pkg = "pkg")` instead.

As default, an
[`adbcdrivermanager::adbc_driver_monkey()`](https://arrow.apache.org/adbc/current/r/adbcdrivermanager/reference/adbc_driver_monkey.html)
object is created.

## Examples

``` r
adbi()
#> <AdbiDriver>
#>   Type: <adbc_driver_monkey>
if (FALSE) adbi("sqlite") # \dontrun{}
if (requireNamespace("adbcsqlite")) {
  adbi(pkg = "adbcsqlite")
}
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
