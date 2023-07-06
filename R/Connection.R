#' @include Driver.R
NULL

KazamConnection <- function() {
  # TODO: Add arguments
  new("KazamConnection")
}

#' @rdname DBI
#' @export
setClass(
  "KazamConnection",
  contains = "DBIConnection",
  slots = list(
    # TODO: Add slots
  )
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
