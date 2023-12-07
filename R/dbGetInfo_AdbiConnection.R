#' @rdname AdbiConnection-class
#' @inheritParams DBI::dbGetInfo
#' @usage NULL
dbGetInfo_AdbiConnection <- function(dbObj, ...) {

  if (!dbIsValid(dbObj)) {
    stop("Invalid connection", call. = FALSE)
  }

  version <- nanoarrow::convert_array_stream(
    adbcdrivermanager::adbc_connection_get_info(dbObj@connection, 1L)
  )

  db <- nanoarrow::convert_array_stream(
    adbcdrivermanager::adbc_connection_get_objects(dbObj@connection, 1L)
  )

  list(
    db.version = version[1L, "info_value"][1L, "string_value"],
    dbname = db[1L, "catalog_name"],
    username = NA_character_,
    host = NA_character_,
    port = NA_integer_
  )
}

#' @rdname AdbiConnection-class
#' @export
setMethod("dbGetInfo", "AdbiConnection", dbGetInfo_AdbiConnection)
