#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbGetInfo
#' @usage NULL
dbGetInfo_AdbiConnection <- function(dbObj, ...) {
  if (!dbIsValid(dbObj)) {
    stop("Invalid connection", call. = FALSE)
  }

  db <- nanoarrow::convert_array_stream(
    adbcdrivermanager::adbc_connection_get_objects(dbObj@connection, 1L)
  )

  list(
    db.version = connection_info_string(dbObj@connection, 1L),
    dbname = db[1L, "catalog_name"],
    username = NA_character_,
    host = NA_character_,
    port = NA_integer_
  )
}

#' @rdname AdbiConnection-class
#' @export
setMethod("dbGetInfo", "AdbiConnection", dbGetInfo_AdbiConnection)
