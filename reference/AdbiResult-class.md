# Class AdbiResult (and methods)

AdbiResult objects are created by
[`DBI::dbSendQuery()`](https://dbi.r-dbi.org/reference/dbSendQuery.html)
or
[`DBI::dbSendStatement()`](https://dbi.r-dbi.org/reference/dbSendStatement.html),
and encapsulate the result of an SQL statement (either `SELECT` or not).
They are a superclass of the
[DBI::DBIResult](https://dbi.r-dbi.org/reference/DBIResult-class.html)
class. The "Usage" section lists the class methods overridden by adbi.

## Usage

``` r
# S4 method for class 'AdbiResult'
dbBindArrow(res, params, ...)

# S4 method for class 'AdbiResult'
dbBind(res, params, ...)

# S4 method for class 'AdbiResult'
dbClearResult(res, ...)

# S4 method for class 'AdbiResult'
dbColumnInfo(res, ...)

# S4 method for class 'AdbiResult'
dbGetRowCount(res, ...)

# S4 method for class 'AdbiResult'
dbGetRowsAffected(res, ...)

# S4 method for class 'AdbiResult'
dbGetStatement(res, ...)

# S4 method for class 'AdbiResult'
dbHasCompleted(res, ...)

# S4 method for class 'AdbiResult'
dbIsValid(dbObj, ...)

# S4 method for class 'AdbiResult'
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
[`DBI::dbFetch()`](https://dbi.r-dbi.org/reference/dbFetch.html),
[`DBI::dbClearResult()`](https://dbi.r-dbi.org/reference/dbClearResult.html),
[`DBI::dbBind()`](https://dbi.r-dbi.org/reference/dbBind.html),
[`DBI::dbColumnInfo()`](https://dbi.r-dbi.org/reference/dbColumnInfo.html),
[`DBI::dbGetRowsAffected()`](https://dbi.r-dbi.org/reference/dbGetRowsAffected.html),
[`DBI::dbGetRowCount()`](https://dbi.r-dbi.org/reference/dbGetRowCount.html),
[`DBI::dbHasCompleted()`](https://dbi.r-dbi.org/reference/dbHasCompleted.html),
and
[`DBI::dbGetStatement()`](https://dbi.r-dbi.org/reference/dbGetStatement.html).
