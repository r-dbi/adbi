#' @rdname AdbiResult-class
#' @inheritParams methods::show
#' @usage NULL
show_AdbiResult <- function(object) {
  cat("<AdbiResult>\n")
  # TODO: Print more details
}

#' @rdname AdbiResult-class
#' @export
setMethod("show", "AdbiResult", show_AdbiResult)
