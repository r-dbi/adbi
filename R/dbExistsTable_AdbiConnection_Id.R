#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbExistsTable
#' @usage NULL
dbExistsTable_AdbiConnection_Id <- function(conn, name, ...) {
  if (!dbIsValid(conn)) {
    stop("Invalid connection.", call. = FALSE)
  }

  name <- name@name

  if (all(names(name) == "")) {
    names(name) <- NULL
  }

  if (!all(names(name) %in% c("catalog", "schema", "table"))) {
    stop(
      "Expecting Id components \"catalog\", \"schema\", and \"table\", ",
      "not ",
      paste0("\"", names(name), "\"", collapse = ", "),
      ".",
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

  res <- do.call(get_schema_objects, c(list(conn, "table"), name))

  length(res[["table_name"]]) == 1L
}

#' @rdname AdbiConnection-class
#' @export
setMethod(
  "dbExistsTable",
  c("AdbiConnection", "Id"),
  dbExistsTable_AdbiConnection_Id
)
