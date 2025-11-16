# Fetch result sets

When fetching results using
[`DBI::dbFetch()`](https://dbi.r-dbi.org/reference/dbFetch.html), the
argument `n` can be specified to control chunk size per fetching
operation. The default value of `-1` corresponds to retrieving the
entire result set at once, while a positive integer will try returning
as many rows (as long as `n` does not exceed the available number of
rows), in line with standard DBI expectations. As data transfer is
mediated by Arrow data structures, which are retrieved as array chunks,
the underlying chunk size can be used by passing an `n` value `NA`.

## Usage

``` r
# S4 method for class 'AdbiResult'
dbFetch(res, n = -1, ...)
```

## Arguments

- res:

  An object inheriting from
  [DBI::DBIResult](https://dbi.r-dbi.org/reference/DBIResult-class.html),
  created by
  [`DBI::dbSendQuery()`](https://dbi.r-dbi.org/reference/dbSendQuery.html).

- n:

  maximum number of records to retrieve per fetch. Use `n = -1` or
  `n = Inf` to retrieve all pending records. Some implementations may
  recognize other special values.

- ...:

  Other arguments passed on to methods.

## Value

A `data.frame` with the requested number of rows (or zero rows if
[`DBI::dbFetch()`](https://dbi.r-dbi.org/reference/dbFetch.html) is
called on a result set with no more remaining rows).

## Examples

``` r
if (requireNamespace("adbcsqlite")) {
  library(DBI)
  con <- dbConnect(adbi::adbi("adbcsqlite"), uri = ":memory:")
  dbWriteTable(con, "swiss", swiss)
  res <- dbSendQuery(con, "SELECT * from swiss WHERE Agriculture < 30")
  dbFetch(res)
  dbClearResult(res)
  dbDisconnect(con)
}
```
