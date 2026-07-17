#' @include adbi-package.R
NULL

INVALID_DRIVER_MESSAGE <- paste0(
  "`driver` must be `NULL`, an `adbc_driver`, a function, ",
  "or a non-missing character string."
)

#' Adbi driver
#'
#' In order to open a database connection, [DBI::dbConnect()] dispatches on a
#' driver object, which can be instantiated by calling `adbi()`.
#'
#' @details
#' `adbi()` stores the `driver` specification in an `AdbiDriver` object. When
#' that object is passed to [DBI::dbConnect()], the stored value is forwarded
#' as the `driver` argument of
#' [adbcdrivermanager::adbc_database_init()]. Additional arguments to
#' [DBI::dbConnect()] are forwarded to the same function as database options.
#'
#' Consequently, `adbi()` accepts the same modern driver specifications as
#' [adbcdrivermanager::adbc_database_init()]:
#'
#' * `NULL`, which leaves driver selection to the driver manager. Supply a
#'   `uri` or `profile` argument to [DBI::dbConnect()].
#' * A non-missing string containing a driver or manifest name, path, or URI.
#' * An object inheriting from [adbcdrivermanager::adbc_driver].
#'
#' Functions, strings of the form `pkg::fun`, and bare strings that identify an
#' installed R package and driver function are resolved to an `adbc_driver`
#' object before forwarding. These forms are supported for backwards
#' compatibility, but are deprecated. Pass an `adbc_driver` object directly
#' when using an R driver package.
#'
#' @param driver An ADBC driver specification forwarded to the `driver`
#'   argument of [adbcdrivermanager::adbc_database_init()] when connecting.
#'   See Details for the accepted values and deprecated compatibility forms.
#'
#' @export
#' @rdname dbConnect
#' @examples
#' adbi()
#' if (requireNamespace("adbcsqlite")) {
#'   adbi(adbcsqlite::adbcsqlite())
#' }
adbi <- function(driver = NULL) {
  if (is.null(driver) || inherits(driver, "adbc_driver")) {
    return(new("AdbiDriver", driver = driver))
  }

  # TODO: In a future breaking release, remove legacy R function/package
  # resolution and simplify this constructor to a thin wrapper around
  # adbcdrivermanager driver initialization.
  if (is.character(driver)) {
    if (length(driver) != 1L || is.na(driver)) {
      stop(INVALID_DRIVER_MESSAGE, call. = FALSE)
    }

    legacy_driver <- adbi_legacy_driver_string(driver)

    if (is.null(legacy_driver)) {
      return(new("AdbiDriver", driver = driver))
    }

    adbi_deprecate_legacy_driver()
    driver <- legacy_driver
  } else if (is.function(driver)) {
    adbi_deprecate_legacy_driver()
  } else {
    stop(INVALID_DRIVER_MESSAGE, call. = FALSE)
  }

  driver <- driver()

  if (inherits(driver, "adbc_driver")) {
    return(new("AdbiDriver", driver = driver))
  }

  stop("The driver function must return an `adbc_driver` object.", call. = FALSE)
}

adbi_legacy_driver_string <- function(driver) {
  if (grepl("://", driver, fixed = TRUE)) {
    return(NULL)
  }

  spec <- strsplit(driver, "::", fixed = TRUE)[[1L]]

  if (length(spec) == 2L) {
    pkg <- spec[[1L]]
    fun <- spec[[2L]]
  } else if (length(spec) == 1L && requireNamespace(driver, quietly = TRUE)) {
    pkg <- fun <- driver
  } else {
    return(NULL)
  }

  get(fun, envir = asNamespace(pkg), mode = "function", inherits = FALSE)
}

adbi_deprecate_legacy_driver <- function() {
  message <- paste0(
    "Using a function or R package/function string as `driver` is deprecated. ",
    "Pass an `adbc_driver` object directly. See `?adbi` for supported driver ",
    "specifications."
  )
  warning(
    simpleWarning(message, call = sys.call(-1L))
  )
}

#' Class AdbiDriver (and methods)
#'
#' AdbiDriver objects are created by [adbi()], and used to select the
#' correct method in [DBI::dbConnect()]. They are a superclass of the
#' [DBI::DBIDriver-class] class, and used purely for dispatch.
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
