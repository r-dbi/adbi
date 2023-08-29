#' @include adbi-package.R
NULL

#' DBI methods
#'
#' Implementations of pure virtual functions defined in the `DBI` package.
#' @name DBI
NULL

#' Adbi driver
#'
#' TBD.
#'
#' @param driver String-valued driver specification
#'
#' @export
#' @rdname adbi-driver
#' @examples
#' \dontrun{
#' #' library(DBI)
#' adbi::adbi()
#' }
adbi <- function(driver = NA_character_) {

  if (is.na(driver)) {

    pkg <- "adbcdrivermanager"
    fun <- "adbc_driver_monkey"

  } else {

    driver <- strsplit(driver, "::", fixed = TRUE)[[1L]]

    if (length(driver) == 1L) {

      pkg <- fun <- driver

    } else {

      stopifnot(length(driver) == 2L)

      pkg <- driver[1L]
      fun <- driver[2L]
    }
  }

  drv_fun <- get(fun, envir = asNamespace(pkg), mode = "function",
                 inherits = FALSE)
  drv_obj <- drv_fun()

  stopifnot(inherits(drv_obj, "adbc_driver"))

  new("AdbiDriver", driver = drv_obj)
}

#' @rdname DBI
#' @export
setClass(
  "AdbiDriver",
  slots = list(
    driver = "ANY"
  ),
  contains = "DBIDriver"
)

#' @export
DBI::dbCanConnect

#' @export
DBI::Id
