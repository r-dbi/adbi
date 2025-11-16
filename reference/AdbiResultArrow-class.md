# Class AdbiResultArrow (and methods)

AdbiResultArrow objects are created by
[`DBI::dbSendQueryArrow()`](https://dbi.r-dbi.org/reference/dbSendQueryArrow.html),
and encapsulate the result of an SQL query (a `SELECT` statement). They
are a superclass of the
[DBI::DBIResultArrow](https://dbi.r-dbi.org/reference/DBIResultArrow-class.html)
class. The "Usage" section lists the class methods overridden by adbi.

## Usage

``` r
# S4 method for class 'AdbiResultArrow'
dbBindArrow(res, params, ...)

# S4 method for class 'AdbiResultArrow'
dbBind(res, params, ...)

# S4 method for class 'AdbiResultArrow'
dbClearResult(res, ...)

# S4 method for class 'AdbiResultArrow'
dbColumnInfo(res, ...)

# S4 method for class 'AdbiResultArrow'
dbFetchArrowChunk(res, ...)

# S4 method for class 'AdbiResultArrow'
dbFetchArrow(res, ...)

# S4 method for class 'AdbiResultArrow'
dbGetRowCount(res, ...)

# S4 method for class 'AdbiResultArrow'
dbGetRowsAffected(res, ...)

# S4 method for class 'AdbiResultArrow'
dbGetStatement(res, ...)

# S4 method for class 'AdbiResultArrow'
dbHasCompleted(res, ...)

# S4 method for class 'AdbiResultArrow'
dbIsValid(dbObj, ...)

# S4 method for class 'AdbiResultArrow'
show(object)
```

## Arguments

- res:

  An object inheriting from
  [DBI::DBIResult](https://dbi.r-dbi.org/reference/DBIResult-class.html).

- params:

  For [`dbBind()`](https://dbi.r-dbi.org/reference/dbBind.html), a list
  of values, named or unnamed, or a data frame, with one element/column
  per query parameter. For
  [`dbBindArrow()`](https://dbi.r-dbi.org/reference/dbBind.html), values
  as a nanoarrow stream, with one column per query parameter.

- ...:

  Other arguments passed on to methods.

- dbObj:

  An object inheriting from
  [DBI::DBIObject](https://dbi.r-dbi.org/reference/DBIObject-class.html),
  i.e.
  [DBI::DBIDriver](https://dbi.r-dbi.org/reference/DBIDriver-class.html),
  [DBI::DBIConnection](https://dbi.r-dbi.org/reference/DBIConnection-class.html),
  or a
  [DBI::DBIResult](https://dbi.r-dbi.org/reference/DBIResult-class.html)

- object:

  Any R object

## See also

The corresponding generic functions
[`DBI::dbFetchArrow()`](https://dbi.r-dbi.org/reference/dbFetchArrow.html),
[`DBI::dbFetchArrowChunk()`](https://dbi.r-dbi.org/reference/dbFetchArrowChunk.html),
[`DBI::dbClearResult()`](https://dbi.r-dbi.org/reference/dbClearResult.html),
[`DBI::dbBind()`](https://dbi.r-dbi.org/reference/dbBind.html),
[`DBI::dbColumnInfo()`](https://dbi.r-dbi.org/reference/dbColumnInfo.html),
[`DBI::dbGetRowsAffected()`](https://dbi.r-dbi.org/reference/dbGetRowsAffected.html),
[`DBI::dbGetRowCount()`](https://dbi.r-dbi.org/reference/dbGetRowCount.html),
[`DBI::dbHasCompleted()`](https://dbi.r-dbi.org/reference/dbHasCompleted.html),
and
[`DBI::dbGetStatement()`](https://dbi.r-dbi.org/reference/dbGetStatement.html).
