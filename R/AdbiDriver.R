#' @include adbi-package.R
NULL

#' Adbi driver
#'
#' In order to open a database connection, [DBI::dbConnect()] dispatches on a
#' driver object, which can be instantiated by calling `adbi()`.
#'
#' @details
#' To specify the type of ADBC driver, `adbi()` accepts as `driver` argument
#'
#' * an object inheriting from `adbc_driver`,
#' * a function that can be evaluated with no arguments and returns an object
#'   inheriting from `adbc_driver`,
#' * an ADBC Driver Manager driver name or manifest path.
#'
#' Use `pkg` to load a driver provided by an R package. By default, the driver
#' function has the same name as the package; supply a character `driver` to
#' use a different function. For example, `adbi(pkg = "adbcsqlite")` calls
#' [adbcsqlite::adbcsqlite()], while
#' `adbi("adbc_driver_monkey", pkg = "adbcdrivermanager")` calls
#' [adbcdrivermanager::adbc_driver_monkey()].
#'
#' Character values passed through `driver` that identify an R package with a
#' same-named driver function, and strings of the form `pkg::fun`, are supported
#' for compatibility but deprecated. Use the explicit `pkg` argument instead.
#'
#' As default, an [adbcdrivermanager::adbc_driver_monkey()] object is created.
#'
#' @param driver An ADBC driver object, a function returning one, an ADBC Driver
#'   Manager driver name or manifest path, or (when `pkg` is supplied) the name
#'   of a driver function in that package. See Details for more information.
#' @param pkg An R package containing a driver function, or `NA` if no R package
#'   is explicitly specified.
#'
#' @export
#' @rdname dbConnect
#' @examples
#' adbi()
#' \dontrun{adbi("sqlite")}
#' if (requireNamespace("adbcsqlite")) {
#'   adbi(pkg = "adbcsqlite")
#' }
adbi <- function(driver = NA_character_, pkg = NA_character_) {
  pkg_supplied <- !identical(pkg, NA_character_)

  if (
    pkg_supplied &&
      (!is.character(pkg) || length(pkg) != 1L || is.na(pkg) || !nzchar(pkg))
  ) {
    stop("`pkg` must be a non-missing character scalar.", call. = FALSE)
  }

  if (inherits(driver, "adbc_driver")) {
    if (pkg_supplied) {
      stop(
        "`pkg` cannot be supplied with an `adbc_driver` object.",
        call. = FALSE
      )
    }
    return(new("AdbiDriver", driver = driver))
  }

  if (is.function(driver)) {
    if (pkg_supplied) {
      stop(
        "`pkg` cannot be supplied with a function-valued `driver`.",
        call. = FALSE
      )
    }
    drv_obj <- driver()
  } else {
    if (!is.character(driver) || length(driver) != 1L) {
      stop(
        "`driver` must be an ADBC driver, a function, or a character scalar.",
        call. = FALSE
      )
    }

    driver_default <- identical(driver, NA_character_)

    if (pkg_supplied) {
      fun <- if (driver_default) pkg else driver
      if (!nzchar(fun) || grepl("::", fun, fixed = TRUE)) {
        stop(
          "With `pkg`, `driver` must be a non-empty function name.",
          call. = FALSE
        )
      }
      drv_obj <- adbi_package_driver(pkg, fun)
    } else if (driver_default) {
      pkg <- "adbcdrivermanager"
      fun <- "adbc_driver_monkey"
      drv_obj <- adbi_package_driver(pkg, fun)
    } else if (!nzchar(driver)) {
      stop("`driver` must not be empty.", call. = FALSE)
    } else if (grepl("::", driver, fixed = TRUE)) {
      driver_parts <- strsplit(driver, "::", fixed = TRUE)[[1L]]
      if (length(driver_parts) != 2L || any(!nzchar(driver_parts))) {
        stop("A package driver must have the form `pkg::fun`.", call. = FALSE)
      }

      pkg <- driver_parts[1L]
      fun <- driver_parts[2L]
      .Deprecated(
        new = sprintf('adbi("%s", pkg = "%s")', fun, pkg),
        msg = sprintf(
          '`adbi("%s")` is deprecated; use `adbi("%s", pkg = "%s")` instead.',
          driver,
          fun,
          pkg
        )
      )
      drv_obj <- adbi_package_driver(pkg, fun)
    } else if (adbi_has_package_function(driver)) {
      .Deprecated(
        new = sprintf('adbi(pkg = "%s")', driver),
        msg = sprintf(
          paste0(
            '`adbi("%s")` as an R package lookup is deprecated; ',
            'use `adbi(pkg = "%s")` instead.'
          ),
          driver,
          driver
        )
      )
      drv_obj <- adbi_package_driver(driver, driver)
    } else {
      drv_obj <- adbcdrivermanager::adbc_driver(driver)
    }
  }

  if (!inherits(drv_obj, "adbc_driver")) {
    stop(
      "The selected driver function must return an `adbc_driver` object.",
      call. = FALSE
    )
  }

  new("AdbiDriver", driver = drv_obj)
}

adbi_package_driver <- function(pkg, fun) {
  drv_fun <- get(
    fun,
    envir = asNamespace(pkg),
    mode = "function",
    inherits = FALSE
  )
  drv_fun()
}

adbi_has_package_function <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    return(FALSE)
  }

  exists(pkg, envir = asNamespace(pkg), mode = "function", inherits = FALSE)
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
