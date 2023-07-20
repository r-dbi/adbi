#' @include Driver.R
NULL

AdbiConnection <- function(driver, ...) {

  db <- adbcdrivermanager::adbc_database_init(driver@driver, ...)
  attr(db, "is_open") <- TRUE

  con <- adbcdrivermanager::adbc_connection_init(db)
  attr(con, "is_open") <- TRUE

  new(
    "AdbiConnection",
    database = db,
    connection = con
  )
}

#' @rdname DBI
#' @export
setClass(
  "AdbiConnection",
  slots = list(
    database = "adbc_database",
    connection = "adbc_connection",
    is_open = "logical"
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
