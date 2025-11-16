#' @rdname AdbiConnection-class
#' @inheritParams methods::show
#' @usage NULL
show_AdbiConnection <- function(object) {
  cat("<AdbiConnection>\n")

  if (dbIsValid(object)) {
    info <- nanoarrow::convert_array_stream(
      adbcdrivermanager::adbc_connection_get_info(object@connection)
    )

    nms <- c(
      `0` = "Vendor name",
      `1` = "Vendor version",
      `2` = "Vendor arrow version",
      `100` = "Driver name",
      `101` = "Driver version",
      `102` = "Driver arrow version"
    )

    info_val <- info[["info_value"]][["string_value"]]
    info_nme <- nms[as.character(info[["info_name"]])]

    Map(cat, "  ", info_nme, ": ", info_val, "\n", sep = "")
  } else {
    cat("  DISCONNECTED\n")
  }

  invisible(object)
}

#' @rdname AdbiConnection-class
#' @export
setMethod("show", "AdbiConnection", show_AdbiConnection)
