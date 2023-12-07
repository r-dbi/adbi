#' @rdname AdbiConnection-class
#' @inheritParams methods::show
#' @usage NULL
show_AdbiConnection <- function(object) {
  cat("<AdbiConnection>\n")
  # TODO: Print more details
}

#' @rdname AdbiConnection-class
#' @export
setMethod("show", "AdbiConnection", show_AdbiConnection)
