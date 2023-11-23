#' @rdname DBI
#' @inheritParams methods::show
#' @usage NULL
show_AdbiConnection <- function(object) {
  cat("<AdbiConnection>\n")
  browser()
  nanoarrow::convert_array_stream(
    adbcdrivermanager::adbc_connection_get_info(object@connection, 100)
  )
}
#' @rdname DBI
#' @export
setMethod("show", "AdbiConnection", show_AdbiConnection)
