#' @rdname AdbiConnection-class
#' @usage NULL
dbAppendTable_AdbiConnection <- function(
  conn,
  name,
  value,
  ...,
  row.names = NULL
) {
  if (!is.null(row.names)) {
    stop("Can't pass `row.names` to `dbAppendTable()`", call. = FALSE)
  }

  if (!is.data.frame(value)) {
    stop("Argument `value` must be a data frame", call. = FALSE)
  }

  value <- factor_to_character(value, "Appending factors as character.")

  query <- sqlAppendTable(
    con = conn,
    table = name,
    values = value,
    row.names = row.names,
    ...
  )

  dbExecute(conn, query)
}

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbAppendTable",
  signature("AdbiConnection"),
  dbAppendTable_AdbiConnection
)
