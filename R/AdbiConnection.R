#' @include AdbiDriver.R
NULL

AdbiConnection <- function(
  driver,
  ...,
  rows_affected_callback = identity,
  bigint = NULL
) {
  db <- adbcdrivermanager::adbc_database_init(driver@driver, ...)

  meta <- list(
    results = list()
  )

  new(
    "AdbiConnection",
    database = db,
    connection = adbcdrivermanager::adbc_connection_init(db),
    metadata = list2env(meta, envir = new.env(parent = emptyenv())),
    bigint = resolve_bigint(bigint),
    rows_affected_callback = rows_affected_callback
  )
}

#' Class AdbiConnection (and methods)
#'
#' AdbiConnection objects are created by passing [adbi()] as first
#' argument to [DBI::dbConnect()]. They are a superclass of the
#' [DBI::DBIConnection-class] class. The "Usage" section lists the class
#' methods overridden by \pkg{adbi}.
#'
#' @seealso
#' The corresponding generic functions
#' [DBI::dbSendQuery()], [DBI::dbGetQuery()],
#' [DBI::dbSendStatement()], [DBI::dbExecute()],
#' [DBI::dbExistsTable()], [DBI::dbListTables()], [DBI::dbListFields()],
#' [DBI::dbRemoveTable()], and [DBI::sqlData()].
#'
#' @keywords internal
#' @export
setClass(
  "AdbiConnection",
  slots = list(
    database = "ANY",
    connection = "ANY",
    metadata = "environment",
    bigint = "character",
    rows_affected_callback = "function"
  ),
  contains = "DBIConnection"
)

bigint_opts <- c(
  "integer",
  "integer-strict",
  "numeric",
  "numeric-strict",
  "character",
  "integer64"
)

resolve_bigint <- function(x) {
  if (is.null(x)) {
    x <- "integer-strict"
  }

  res <- match.arg(x, bigint_opts)

  if (
    identical(res, "integer64") &&
      !requireNamespace("bit64", quietly = TRUE)
  ) {
    stop("Need to install bit64.", call. = FALSE)
  }

  res
}
