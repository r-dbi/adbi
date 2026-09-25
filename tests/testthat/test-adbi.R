test_that("adbi() retains its default and accepts existing drivers", {
  default <- adbi()
  expect_s4_class(default, "AdbiDriver")
  expect_s3_class(default@driver, "adbc_driver_monkey")
  expect_s3_class(adbi(NA)@driver, "adbc_driver_monkey")
  expect_s3_class(adbi(pkg = NA)@driver, "adbc_driver_monkey")

  driver <- adbcdrivermanager::adbc_driver_monkey()
  result <- adbi(driver)
  expect_identical(result@driver, driver)
})

test_that("ADBC driver specifications use the Driver Manager", {
  seen <- character()
  fake_driver <- adbcdrivermanager::adbc_driver_monkey()
  local_mocked_bindings(
    adbc_driver = function(driver) {
      seen <<- c(seen, driver)
      fake_driver
    },
    .package = "adbcdrivermanager"
  )

  expect_identical(adbi("sqlite")@driver, fake_driver)
  expect_identical(adbi("/tmp/sqlite.toml")@driver, fake_driver)
  expect_identical(seen, c("sqlite", "/tmp/sqlite.toml"))
})

test_that("Driver Manager specs load a real driver", {
  skip_if_not_installed("adbcsqlite")

  dir <- withr::local_tempdir()
  manifest <- sqlite_manifest(dir)
  # Before adbcdrivermanager 0.20.0, the variable was ADBC_CONFIG_PATH
  withr::local_envvar(ADBC_DRIVER_PATH = dir, ADBC_CONFIG_PATH = dir)

  for (spec in c(manifest, "adbi_test_sqlite")) {
    con <- dbConnect(adbi(spec), uri = ":memory:")
    expect_equal(dbGetQuery(con, "SELECT 1 AS x")$x, 1)
    dbDisconnect(con)
  }
})

test_that("pkg explicitly selects an R package driver", {
  expect_s3_class(
    adbi("adbc_driver_monkey", pkg = "adbcdrivermanager")@driver,
    "adbc_driver_monkey"
  )

  skip_if_not_installed("adbcsqlite")
  expect_s3_class(
    adbi(pkg = "adbcsqlite")@driver,
    "adbcsqlite_driver_sqlite"
  )
})

test_that("package names passed as driver still select the package driver", {
  driver <- adbcdrivermanager::adbc_driver_monkey()
  local_mocked_bindings(
    adbi_has_package_function = function(pkg) identical(pkg, "fakepkg"),
    adbi_package_driver = function(pkg, fun) {
      expect_identical(pkg, "fakepkg")
      expect_identical(fun, "fakepkg")
      driver
    }
  )

  expect_no_warning(result <- adbi("fakepkg"))
  expect_identical(result@driver, driver)
  expect_no_warning(adbi(driver = "fakepkg"))
})

test_that("package names resolve to the package's own driver", {
  skip_if_not_installed("adbcsqlite")

  expect_no_warning(drv <- adbi("adbcsqlite"))
  expect_s3_class(drv@driver, "adbcsqlite_driver_sqlite")
})

test_that("pkg::fun warns and continues to work", {
  expect_warning(
    adbi("adbcdrivermanager::adbc_driver_monkey"),
    "pkg =",
    class = "deprecatedWarning"
  )
})

test_that("non-driver package functions fall back to the Driver Manager", {
  fake_driver <- adbcdrivermanager::adbc_driver_monkey()
  local_mocked_bindings(
    adbi_has_package_function = function(pkg) identical(pkg, "fakepkg"),
    adbi_package_driver = function(pkg, fun) 42
  )
  local_mocked_bindings(
    adbc_driver = function(driver) {
      expect_identical(driver, "fakepkg")
      fake_driver
    },
    .package = "adbcdrivermanager"
  )

  expect_identical(adbi("fakepkg")@driver, fake_driver)
})

test_that("installed packages without a same-name driver use Driver Manager", {
  fake_driver <- adbcdrivermanager::adbc_driver_monkey()
  local_mocked_bindings(
    adbc_driver = function(driver) {
      expect_identical(driver, "utils")
      fake_driver
    },
    .package = "adbcdrivermanager"
  )

  expect_false(adbi_has_package_function("utils"))
  expect_identical(adbi("utils")@driver, fake_driver)
})

test_that("a package that fails to load reports its own error", {
  lib <- withr::local_tempdir()
  dir.create(file.path(lib, "adbibrokenpkg"))
  writeLines(
    c("Package: adbibrokenpkg", "Version: 0.0.1"),
    file.path(lib, "adbibrokenpkg", "DESCRIPTION")
  )
  withr::local_libpaths(lib, action = "prefix")

  err <- expect_error(adbi("adbibrokenpkg"))
  expect_false(inherits(err, "adbc_status"))
})

test_that("unknown driver names also rule out an R package", {
  expect_error(
    adbi("adbi_no_such_driver"),
    "No installed R package `adbi_no_such_driver`",
    fixed = TRUE,
    class = "adbc_status_not_found"
  )
})

test_that("invalid adbi() argument combinations fail clearly", {
  expect_error(adbi(pkg = character()), "`pkg` must")
  expect_error(adbi(pkg = ""), "`pkg` must")
  expect_error(adbi(1), "`driver` must")
  expect_error(adbi(character()), "`driver` must")
  expect_error(adbi("", pkg = "utils"), "function name")
  expect_error(adbi("pkg::fun", pkg = "utils"), "function name")

  driver <- adbcdrivermanager::adbc_driver_monkey()
  expect_error(adbi(driver, pkg = "utils"), "cannot be supplied")
  expect_error(adbi(function() driver, pkg = "utils"), "cannot be supplied")
})

test_that("driver functions must return an adbc_driver", {
  local_mocked_bindings(adbi_package_driver = function(pkg, fun) 42)
  expect_error(
    adbi(pkg = "fakepkg"),
    "must return an `adbc_driver` object",
    fixed = TRUE
  )

  expect_error(
    adbi(function() 42),
    "must return an `adbc_driver` object",
    fixed = TRUE
  )
})
