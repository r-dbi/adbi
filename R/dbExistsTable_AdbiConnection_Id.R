#' @rdname DBI
#' @inheritParams DBI::dbExistsTable
#' @usage NULL
dbExistsTable_AdbiConnection_Id <- function(conn, name, ...) {

  if (!dbIsValid(conn)) {
    stop("Invalid connection.", call. = FALSE)
  }

  name <- as.list(name@name)

  if (!all(names(name) %in% c("catalog", "schema", "table"))) {
    stop("Expecting Id components \"catalog\", \"schema\", and \"table\".",
      call. = FALSE)
  }

  res <- do.call(get_schema_objects, c(list(conn, "table"), name))

  length(res[["table_name"]]) == 1L
}

#' @rdname DBI
#' @export
setMethod(
  "dbExistsTable",
  c("AdbiConnection", "Id"),
  dbExistsTable_AdbiConnection_Id
)
