#' @include Connection.R
NULL

AdbiResultArrow <- function(connection, statement, immediate = NULL,
                       type = c("query", "statement")) {

  init_result(connection, statement, "AdbiResultArrow", immediate, type)
}

#' @rdname DBI
#' @export
setClass(
  "AdbiResultArrow",
  contains = "DBIResult",
  slots = list(
    statement = "ANY",
    metadata = "environment"
  )
)
