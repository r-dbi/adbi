#' @rdname DBI
#' @inheritParams DBI::dbFetch
#' @usage NULL
dbFetch_KazamResult <- function(res, n = -1, ...) {
  #
  # FOR IMPLEMENTERS:
  #
  # If you are interfacing against a native database library,
  # consider copying and adapting Db*.cpp and Db*.h from r-dbi/RPostgres.
  # These classes help growing a data frame whose number of rows
  # may be unknown at the beginning.
  # Similar code is in r-dbi/odbc.
  #
  testthat::skip("Not yet implemented: dbFetch(Result)")
}
#' @rdname DBI
#' @export
setMethod("dbFetch", "KazamResult", dbFetch_KazamResult)
