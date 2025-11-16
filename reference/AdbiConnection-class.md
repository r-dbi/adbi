# Class AdbiConnection (and methods)

AdbiConnection objects are created by passing
[`adbi()`](https://adbi.r-dbi.org/reference/dbConnect.md) as first
argument to
[`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).
They are a superclass of the
[DBI::DBIConnection](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
class. The "Usage" section lists the class methods overridden by adbi.

## Usage

``` r
# S4 method for class 'AdbiConnection'
dbAppendTable(conn, name, value, ..., row.names = NULL)

# S4 method for class 'AdbiConnection'
dbBegin(conn, ...)

# S4 method for class 'AdbiConnection'
dbCommit(conn, ...)

# S4 method for class 'AdbiConnection'
dbDataType(dbObj, obj, ...)

# S4 method for class 'AdbiConnection,Id'
dbExistsTable(conn, name, ...)

# S4 method for class 'AdbiConnection,SQL'
dbExistsTable(conn, name, ...)

# S4 method for class 'AdbiConnection,character'
dbExistsTable(conn, name, ...)

# S4 method for class 'AdbiConnection'
dbGetInfo(dbObj, ...)

# S4 method for class 'AdbiConnection'
dbIsValid(dbObj, ...)

# S4 method for class 'AdbiConnection,Id'
dbListFields(conn, name, ...)

# S4 method for class 'AdbiConnection,SQL'
dbListFields(conn, name, ...)

# S4 method for class 'AdbiConnection,character'
dbListFields(conn, name, ...)

# S4 method for class 'AdbiConnection'
dbListTables(conn, ...)

# S4 method for class 'AdbiConnection,character'
dbQuoteIdentifier(conn, x, ...)

# S4 method for class 'AdbiConnection,SQL'
dbQuoteIdentifier(conn, x, ...)

# S4 method for class 'AdbiConnection,character'
dbQuoteLiteral(conn, x, ...)

# S4 method for class 'AdbiConnection,character'
dbQuoteString(conn, x, ...)

# S4 method for class 'AdbiConnection,SQL'
dbQuoteString(conn, x, ...)

# S4 method for class 'AdbiConnection,character'
dbRemoveTable(conn, name, ..., temporary = FALSE, fail_if_missing = TRUE)

# S4 method for class 'AdbiConnection,Id'
dbRemoveTable(conn, name, ..., temporary = FALSE, fail_if_missing = TRUE)

# S4 method for class 'AdbiConnection'
dbRollback(conn, ...)

# S4 method for class 'AdbiConnection'
dbUnquoteIdentifier(conn, x, ...)

# S4 method for class 'AdbiConnection,Id,data.frame'
dbWriteTable(
  conn,
  name,
  value,
  overwrite = FALSE,
  append = FALSE,
  ...,
  field.types = NULL,
  row.names = NULL,
  temporary = FALSE
)

# S4 method for class 'AdbiConnection,SQL,data.frame'
dbWriteTable(conn, name, value, ...)

# S4 method for class 'AdbiConnection,character,data.frame'
dbWriteTable(conn, name, value, ...)

# S4 method for class 'AdbiConnection'
show(object)
```

## Arguments

- conn:

  A
  [DBI::DBIConnection](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object, as returned by
  [`DBI::dbConnect()`](https://dbi.r-dbi.org/reference/dbConnect.html).

- name:

  The table name, passed on to
  [`dbQuoteIdentifier()`](https://dbi.r-dbi.org/reference/dbQuoteIdentifier.html).
  Options are:

  - a character string with the unquoted DBMS table name, e.g.
    `"table_name"`,

  - a call to [`Id()`](https://dbi.r-dbi.org/reference/Id.html) with
    components to the fully qualified table name, e.g.
    `Id(schema = "my_schema", table = "table_name")`

  - a call to [`SQL()`](https://dbi.r-dbi.org/reference/SQL.html) with
    the quoted and fully qualified table name given verbatim, e.g.
    `SQL('"my_schema"."table_name"')`

- value:

  A [data.frame](https://rdrr.io/r/base/data.frame.html) (or coercible
  to data.frame).

- ...:

  Other parameters passed on to methods.

- row.names:

  A logical specifying whether the `row.names` should be output to the
  output DBMS table; if `TRUE`, an extra field whose name will be
  whatever the R identifier `"row.names"` maps to the DBMS (see
  [`DBI::make.db.names()`](https://dbi.r-dbi.org/reference/make.db.names.html)).
  If `NA` will add rows names if they are characters, otherwise will
  ignore.

- dbObj:

  A object inheriting from
  [DBI::DBIDriver](https://dbi.r-dbi.org/reference/DBIDriver-class.html)
  or
  [DBI::DBIConnection](https://dbi.r-dbi.org/reference/DBIConnection-class.html)

- obj:

  An R object whose SQL type we want to determine.

- x:

  A character vector,
  [DBI::SQL](https://dbi.r-dbi.org/reference/SQL.html) or
  [DBI::Id](https://dbi.r-dbi.org/reference/Id.html) object to quote as
  identifier.

- temporary:

  a logical specifying whether the new table should be temporary. Its
  default is `FALSE`.

- fail_if_missing:

  If `FALSE`,
  [`DBI::dbRemoveTable()`](https://dbi.r-dbi.org/reference/dbRemoveTable.html)
  succeeds if the table doesn't exist.

- overwrite:

  Allow overwriting the destination table. Cannot be `TRUE` if `append`
  is also `TRUE`.

- append:

  Allow appending to the destination table. Cannot be `TRUE` if
  `overwrite` is also `TRUE`.

- field.types:

  character vector of named SQL field types where the names are the
  names of new table's columns. If missing, types inferred with
  [`DBI::dbDataType()`](https://dbi.r-dbi.org/reference/dbDataType.html)).

- object:

  Any R object

## See also

The corresponding generic functions
[`DBI::dbSendQuery()`](https://dbi.r-dbi.org/reference/dbSendQuery.html),
[`DBI::dbGetQuery()`](https://dbi.r-dbi.org/reference/dbGetQuery.html),
[`DBI::dbSendStatement()`](https://dbi.r-dbi.org/reference/dbSendStatement.html),
[`DBI::dbExecute()`](https://dbi.r-dbi.org/reference/dbExecute.html),
[`DBI::dbExistsTable()`](https://dbi.r-dbi.org/reference/dbExistsTable.html),
[`DBI::dbListTables()`](https://dbi.r-dbi.org/reference/dbListTables.html),
[`DBI::dbListFields()`](https://dbi.r-dbi.org/reference/dbListFields.html),
[`DBI::dbRemoveTable()`](https://dbi.r-dbi.org/reference/dbRemoveTable.html),
and [`DBI::sqlData()`](https://dbi.r-dbi.org/reference/sqlData.html).
