#' @include RKazam-package.R
NULL

#' DBI methods
#'
#' Implementations of pure virtual functions defined in the `DBI` package.
#' @name DBI
NULL

#' Kazam driver
#'
#' TBD.
#'
#' @export
#' @examples
#' \dontrun{
#' #' library(DBI)
#' RKazam::Kazam()
#' }
Kazam <- function() {
  new("KazamDriver")
}

#' @rdname DBI
#' @export
setClass(
  "KazamDriver",
  contains = "DBIDriver",
  slots = list(
    # TODO: Add slots
  )
)

#' @export
DBI::dbCanConnect

#' @export
DBI::Id
