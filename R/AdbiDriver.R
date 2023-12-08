#' @include adbi-package.R
NULL

#' Adbi driver
#'
#' In order to open a database connection, [DBI::dbConnect()] dispatches on a
#' driver object, which can be instantiated by calling `adbi()`.
#'
#' @details
#' To specify the type of adbc driver, `adbi` accepts as `driver` argument
#'
#' * an object inheriting from `adbc_driver`,
#' * a function that can be evaluated with no arguments and returns an object
#'   inheriting from `adbc_driver`,
#' * a string of the form `pkg::fun` (where `pkg::` is optional and defaults
#'   to `fun`), which can be used to look up such a function.
#'
#' As default, an [adbcdrivermanager::adbc_driver_monkey()] object is created.
#'
#' @param driver A driver specification that can be evaluated (with no
#'  arguments) to give an [adbcdrivermanager::adbc_driver()]. See Details for
#'  more information.
#'
#' @export
#' @rdname dbConnect
#' @examples
#' adbi()
#' if (requireNamespace("adbcsqlite")) {
#'   adbi("adbcsqlite")
#' }
adbi <- function(driver = NA_character_) {

  if (inherits(driver, "adbc_driver")) {
    return(new("AdbiDriver", driver = driver))
  }

  if (is.function(driver)) {

    drv_obj <- driver()

  } else {

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

    drv_fun <- get(
      fun,
      envir = asNamespace(pkg),
      mode = "function",
      inherits = FALSE
    )

    drv_obj <- drv_fun()
  }

  stopifnot(inherits(drv_obj, "adbc_driver"))

  new("AdbiDriver", driver = drv_obj)
}

#' Class AdbiDriver (and methods)
#'
#' AdbiDriver objects are created by [adbi()], and used to select the
#' correct method in [dbConnect()]. They are a superclass of the
#' [DBIDriver-class] class, and used purely for dispatch.
#' The "Usage" section lists the class methods overridden by \pkg{adbi}.
#'
#' @keywords internal
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
