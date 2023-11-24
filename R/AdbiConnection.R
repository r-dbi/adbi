#' @include AdbiDriver.R
NULL

AdbiConnection <- function(driver, ..., bigint = NULL) {

  db <- adbcdrivermanager::adbc_database_init(driver@driver, ...)

  meta <- list(
    results = list()
  )

  new(
    "AdbiConnection",
    database = db,
    connection = adbcdrivermanager::adbc_connection_init(db),
    metadata = list2env(meta, envir = new.env(parent = emptyenv())),
    bigint = resolve_bigint(bigint)
  )
}

#' @rdname DBI
#' @export
setClass(
  "AdbiConnection",
  slots = list(
    database = "ANY",
    connection = "ANY",
    metadata = "environment",
    bigint = "character"
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

resolve_bigint <- function(x) {

  if (is.null(x)) {
    if (requireNamespace("bit64", quietly = TRUE)) {
      x <- "integer64"
    } else {
      x <- "character"
    }
  }

  match.arg(x, c("integer", "numeric", "character", "integer64"))
}
