#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbListFields
#' @usage NULL
dbListFields_AdbiConnection_Id <- function(conn, name, ...) {

  if (!dbIsValid(conn)) {
    stop("Invalid connection.", call. = FALSE)
  }

  if (!dbExistsTable(conn, name)) {
    stop("Table `", name, "` does not exist.", call. = FALSE)
  }

  name <- name@name

  if (all(names(name) == "")) {
    names(name) <- NULL
  }

  if (!all(names(name) %in% c("catalog", "schema", "table"))) {
    stop(
      "Expecting Id components \"catalog\", \"schema\", and \"table\", ",
      "not ", paste0("\"", names(name), "\"", collapse = ", "), ".",
      call. = FALSE
    )
  }

  if (is.null(names(name))) {
    if (length(name) == 1L) {
      names(name) <- "table"
    } else {
      stop("Cannot handle unnamed `Id` objects of length > 1")
    }
  }

  res <- do.call(get_schema_objects, c(list(conn, "field"), name))

  res[["column_name"]]
}

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbListFields",
  c("AdbiConnection", "Id"),
  dbListFields_AdbiConnection_Id
)
