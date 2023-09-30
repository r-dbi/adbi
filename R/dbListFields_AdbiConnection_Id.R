#' @rdname DBI
#' @inheritParams DBI::dbListFields
#' @usage NULL
dbListFields_AdbiConnection_Id <- function(conn, name, ...) {

  if (!dbIsValid(conn)) {
    stop("Invalid connection.", call. = FALSE)
  }

  if (!dbExistsTable(conn, name)) {
    stop("Table `", name, "` does not exist.", call. = FALSE)
  }

  name <- as.list(name@name)

  if (!all(names(name) %in% c("catalog", "schema", "table"))) {
    stop("Expecting Id components \"catalog\", \"schema\", and \"table\".",
      call. = FALSE)
  }

  res <- do.call(get_schema_objects, c(list(conn, "field"), name))

  res[["column_name"]]
}

#' @rdname DBI
#' @export
setMethod(
  "dbListFields",
  c("AdbiConnection", "Id"),
  dbListFields_AdbiConnection_Id
)
