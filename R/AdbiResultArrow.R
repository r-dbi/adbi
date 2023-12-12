#' @include AdbiConnection.R
NULL

AdbiResultArrow <- function(connection, statement, immediate = NULL,
                            type = c("query", "statement"), bigint = NULL) {

  init_result(connection, statement, "AdbiResultArrow", immediate, type, bigint)
}

#' Class AdbiResultArrow (and methods)
#'
#' AdbiResultArrow objects are created by [DBI::dbSendQueryArrow()], and
#' encapsulate the result of an SQL query (a `SELECT` statement). They are a
#' superclass of the [DBIResultArrow-class] class. The "Usage" section lists
#' the class methods overridden by \pkg{adbi}.
#'
#' @seealso
#' The corresponding generic functions
#' [DBI::dbFetchArrow()], [DBI::dbFetchArrowChunk()], [DBI::dbClearResult()],
#' [DBI::dbBind()], [DBI::dbColumnInfo()], [DBI::dbGetRowsAffected()],
#' [DBI::dbGetRowCount()], [DBI::dbHasCompleted()], and [DBI::dbGetStatement()].
#'
#' @export
#' @keywords internal
setClass(
  "AdbiResultArrow",
  contains = "DBIResultArrow",
  slots = list(
    statement = "ANY",
    metadata = "environment",
    bigint = "character"
  )
)
