#' @rdname dbConnect
#' @param drv An object that inherits from
#'   [DBI::DBIDriver][DBI::DBIDriver-class],
#'   or an existing [DBI::DBIConnection][DBI::DBIConnection-class]
#'   object (in order to clone an existing connection).
#' @param ... Extra arguments passed to [DBI::dbConnect()] are forwarded to
#'   [adbcdrivermanager::adbc_database_init()]
#' @param bigint The R type that 64-bit integer types should be mapped to.
#'   The default, `"integer-strict"`, maps them to `integer` and fails with an
#'   error for values outside its range, whereas `"integer"` silently returns
#'   `NA` for them.
#'   Likewise, `"numeric-strict"` maps them to `numeric` and fails for values
#'   beyond 2^53 in magnitude, which a double may not represent exactly,
#'   whereas `"numeric"` silently rounds them to the nearest double.
#'   Both `"character"` and `"integer64"` are lossless, returning decimal
#'   strings and [bit64::integer64] values respectively.
#'   The latter requires the bit64 package.
#' @examples
#' library(DBI)
#' con <- dbConnect(adbi())
#' dbIsValid(con)
#' dbDisconnect(con)
#' dbIsValid(con)
#' @return A connection object (S4 class `AdbiConnection`, inheriting from
#'   [DBI::DBIConnection-class]) is returned by [DBI::dbConnect()], while
#'   [DBI::dbDisconnect()] returns `TRUE` invisibly.
#' @usage NULL
dbConnect_AdbiDriver <- function(drv, ..., bigint = NULL) {
  AdbiConnection(drv, ..., bigint = bigint)
}

#' @rdname dbConnect
#' @export
setMethod("dbConnect", "AdbiDriver", dbConnect_AdbiDriver)
