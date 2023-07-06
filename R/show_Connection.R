#' @rdname DBI
#' @inheritParams methods::show
#' @usage NULL
show_KazamConnection <- function(object) {
  cat("<KazamConnection>\n")
  # TODO: Print more details
}
#' @rdname DBI
#' @export
setMethod("show", "KazamConnection", show_KazamConnection)
