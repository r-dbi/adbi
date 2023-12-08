#' @rdname adbi-driver
#' @param ... Extra arguments passed to [dbConnect()] are forwarded to
#'   [adbcdrivermanager::adbc_database_init()]
#' @param bigint The R type that 64-bit integer types should be mapped to,
#'   default is [bit64::integer64], if bit64 is installed and `character`
#'   otherwise
#' @inheritParams DBI::dbConnect
#' @examples
#' library(DBI)
#' con <- dbConnect(adbi())
#' dbIsValid(con)
#' dbDisconnect(con)
#' dbIsValid(con)
#' @usage NULL
dbConnect_AdbiDriver <- function(drv, ..., bigint = NULL) {
  AdbiConnection(drv, ..., bigint = bigint)
}

#' @rdname adbi-driver
#' @export
setMethod("dbConnect", "AdbiDriver", dbConnect_AdbiDriver)
