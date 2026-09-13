test_that("adbi() retains its default and accepts existing drivers", {
  default <- adbi()
  expect_s4_class(default, "AdbiDriver")
  expect_s3_class(default@driver, "adbc_driver_monkey")

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

test_that("pkg explicitly selects an R package driver", {
  skip_if_not_installed("adbcsqlite")
  expect_s3_class(adbi(pkg = "adbcsqlite")@driver, "adbc_driver")
  expect_s3_class(
    adbi("adbc_driver_monkey", pkg = "adbcdrivermanager")@driver,
    "adbc_driver"
  )
})

test_that("legacy package spellings warn and continue to work", {
  local_mocked_bindings(
    adbi_has_package_function = function(pkg) identical(pkg, "fakepkg"),
    adbi_package_driver = function(pkg, fun) {
      expect_identical(pkg, "fakepkg")
      expect_identical(fun, "fakepkg")
      adbcdrivermanager::adbc_driver_monkey()
    }
  )

  expect_warning(adbi("fakepkg"), class = "deprecatedWarning")
  expect_warning(adbi(driver = "fakepkg"), class = "deprecatedWarning")
})

test_that("pkg::fun warns and continues to work", {
  expect_warning(
    adbi("adbcdrivermanager::adbc_driver_monkey"),
    "pkg =",
    class = "deprecatedWarning"
  )
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

  local_mocked_bindings(
    adbi_has_package_function = function(pkg) identical(pkg, "fakepkg")
  )
  expect_warning(
    expect_error(
      adbi("fakepkg"),
      "must return an `adbc_driver` object",
      fixed = TRUE
    ),
    class = "deprecatedWarning"
  )

  expect_error(
    adbi(function() 42),
    "must return an `adbc_driver` object",
    fixed = TRUE
  )
})
