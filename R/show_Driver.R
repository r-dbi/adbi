#' @rdname DBI
#' @inheritParams methods::show
#' @usage NULL
show_KazamDriver <- function(object) {
  cat("<KazamDriver>\n")
  # TODO: Print more details
}
#' @rdname DBI
#' @export
setMethod("show", "KazamDriver", show_KazamDriver)
