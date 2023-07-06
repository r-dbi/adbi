#' @include Connection.R
NULL

KazamResultArrow <- function(connection, statement) {
  # TODO: Initialize result
  new("KazamResultArrow",
    connection = connection,
    statement = statement
  )
}

#' @rdname DBI
#' @export
setClass(
  "KazamResultArrow",
  contains = "DBIResultArrow",
  slots = list(
    connection = "KazamConnection",
    statement = "character"
  )
)
