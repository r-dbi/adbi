#' @include AdbiDriver.R
NULL

AdbiConnection <- function(driver, ...) {

  db <- adbcdrivermanager::adbc_database_init(driver@driver, ...)

  meta <- list(
    results = list()
  )

  new(
    "AdbiConnection",
    database = db,
    connection = adbcdrivermanager::adbc_connection_init(db),
    metadata = list2env(meta, envir = new.env(parent = emptyenv()))
  )
}

#' @rdname DBI
#' @export
setClass(
  "AdbiConnection",
  slots = list(
    database = "ANY",
    connection = "ANY",
    metadata = "environment"
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
