# Create result sets

Creating result sets using
[`DBI::dbSendQuery()`](https://dbi.r-dbi.org/reference/dbSendQuery.html)
(and by extension using
[`DBI::dbGetQuery()`](https://dbi.r-dbi.org/reference/dbGetQuery.html))
mostly follows DBI specification. One way where adbi deviates from DBI
mechanisms is how the `bigint` setting is not only per connection, but
the per-connection setting can be overridden on a result set basis. As
default, the connection setting is applied, but passing one of the
accepted values as `bigint` when creating a result set will subsequently
use that setting for all fetches using this result set.

## Usage

``` r
# S4 method for class 'AdbiConnection'
dbSendQueryArrow(
  conn,
  statement,
  ...,
  params = NULL,
  immediate = NULL,
  bigint = NULL
)

# S4 method for class 'AdbiConnection,character'
dbSendQuery(
  conn,
  statement,
  ...,
  params = NULL,
  immediate = NULL,
  bigint = NULL
)

# S4 method for class 'AdbiConnection,character'
dbSendStatement(
  conn,
  statement,
  ...,
  params = NULL,
  immediate = NULL,
  bigint = NULL
)
```

## Arguments

- conn:

  A
  [DBI::DBIConnection](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).

- statement:

  a character string containing SQL.

- ...:

  Other parameters passed on to methods.

- params:

  Optional query parameters (forwarded to
  [`DBI::dbBind()`](https://dbi.r-dbi.org/reference/dbBind.html))

- immediate:

  Passing a value `TRUE` is intended for statements containing no
  placeholders and `FALSE` otherwise. The default value `NULL` will
  inspect the statement for presence of placeholders (will `PREPARE` the
  statement)

- bigint:

  The R type that 64-bit integer types should be mapped to, default is
  chosen according to the connection setting

## Value

An S4 class `AdbiResult` (inheriting from
[DBI::DBIResult](https://dbi.r-dbi.org/reference/DBIResult-class.html)).

## Details

Multiple open result sets per connection are supported and support can
be disabled by setting `options(adbi.allow_multiple_results = FALSE)`.
If not enabled, creating a new result will finalize potential other
results and throw a warning.

## See also

adbi-driver

## Examples

``` r
if (requireNamespace("adbcsqlite")) {
  library(DBI)
  con <- dbConnect(adbi::adbi("adbcsqlite"), uri = ":memory:")
  dbWriteTable(con, "swiss", swiss)
  str(
    dbGetQuery(con, "SELECT Examination from swiss WHERE Agriculture < 30")
  )
  str(
    dbGetQuery(con, "SELECT Examination from swiss WHERE Agriculture < 30",
      bigint = "integer")
  )
  dbDisconnect(con)
}
#> 'data.frame':    10 obs. of  1 variable:
#>  $ Examination: int  15 26 31 25 29 22 35 25 37 22
#> 'data.frame':    10 obs. of  1 variable:
#>  $ Examination: int  15 26 31 25 29 22 35 25 37 22
```
