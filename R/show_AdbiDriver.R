#' @rdname AdbiDriver-class
#' @inheritParams methods::show
#' @usage NULL
show_AdbiDriver <- function(object) {
  cat("<AdbiDriver>\n")
  # TODO: Print more details
}

#' @rdname AdbiDriver-class
#' @export
setMethod("show", "AdbiDriver", show_AdbiDriver)
