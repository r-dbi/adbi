#' @rdname DBI
#' @inheritParams methods::show
#' @usage NULL
show_AdbiConnection <- function(object) {
  cat("<AdbiConnection>\n")
  # TODO: Print more details
}
#' @rdname DBI
#' @export
setMethod("show", "AdbiConnection", show_AdbiConnection)
