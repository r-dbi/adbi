#' @include Connection.R
NULL

KazamResult <- function(connection, statement) {
  # TODO: Initialize result
  new("KazamResult",
    connection = connection,
    statement = statement
  )
}

#' @rdname DBI
#' @export
setClass(
  "KazamResult",
  contains = "DBIResult",
  slots = list(
    connection = "KazamConnection",
    statement = "character"
  )
)
