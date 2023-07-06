#' @rdname DBI
#' @inheritParams methods::show
#' @usage NULL
show_KazamResult <- function(object) {
  cat("<KazamResult>\n")
  # TODO: Print more details
}
#' @rdname DBI
#' @export
setMethod("show", "KazamResult", show_KazamResult)
