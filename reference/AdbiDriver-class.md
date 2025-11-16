# Class AdbiDriver (and methods)

AdbiDriver objects are created by
[`adbi()`](https://adbi.r-dbi.org/reference/dbConnect.md), and used to
select the correct method in
[`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).
They are a superclass of the
[DBI::DBIDriver](https://dbi.r-dbi.org/reference/DBIDriver-class.html)
class, and used purely for dispatch. The "Usage" section lists the class
methods overridden by adbi.

## Usage

``` r
# S4 method for class 'AdbiDriver'
dbDataType(dbObj, obj, ...)

# S4 method for class 'AdbiDriver'
dbGetInfo(dbObj, ...)

# S4 method for class 'AdbiDriver'
dbIsValid(dbObj, ...)

# S4 method for class 'AdbiDriver'
show(object)
```

## Arguments

- dbObj:

  A object inheriting from
  [DBI::DBIDriver](https://dbi.r-dbi.org/reference/DBIDriver-class.html)
  or
  [DBI::DBIConnection](https://dbi.r-dbi.org/reference/DBIConnection-class.html)

- obj:

  An R object whose SQL type we want to determine.

- ...:

  Other arguments passed on to methods.

- object:

  Any R object
