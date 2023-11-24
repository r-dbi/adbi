#' @include AdbiConnection.R
NULL

AdbiResultArrow <- function(connection, statement, immediate = NULL,
                            type = c("query", "statement"), bigint = NULL) {

  init_result(connection, statement, "AdbiResultArrow", immediate, type, bigint)
}

#' @rdname DBI
#' @export
setClass(
  "AdbiResultArrow",
  contains = "DBIResultArrow",
  slots = list(
    statement = "ANY",
    metadata = "environment",
    bigint = "character"
  )
)
