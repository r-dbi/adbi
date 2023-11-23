#' @rdname DBI
#' @inheritParams methods::show
#' @usage NULL
show_AdbiDriver <- function(object) {
  cat("<AdbiDriver>\n")
  # TODO: Print more details
}
#' @rdname DBI
#' @export
setMethod("show", "AdbiDriver", show_AdbiDriver)
