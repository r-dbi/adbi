#' @include Driver.R
NULL

AdbiConnection <- function(driver, ...) {

  db <- adbcdrivermanager::adbc_database_init(driver@driver, ...)

  new(
    "AdbiConnection",
    database = db,
    connection = adbcdrivermanager::adbc_connection_init(db)
  )
}

#' @rdname DBI
#' @export
setClass(
  "AdbiConnection",
  slots = list(
    database = "ANY",
    connection = "ANY"
  ),
  contains = "DBIConnection"
)

#' @export
DBI::dbIsReadOnly

#' @export
DBI::dbQuoteLiteral

#' @export
DBI::dbUnquoteIdentifier

#' @export
DBI::dbGetQuery

#' @export
DBI::dbExecute

#' @export
DBI::dbReadTable

#' @export
DBI::dbCreateTable

#' @export
DBI::dbAppendTable

#' @export
DBI::dbListObjects

#' @export
DBI::dbWithTransaction
