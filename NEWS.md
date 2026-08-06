# adbi (development version)

- `adbi()` now defaults to driver-manager inference. It accepts connection
  profile URIs, ordinary URIs, driver or manifest names and paths, as well as
  existing `adbc_driver` objects.
- Resolving an R driver from a function, `pkg::fun`, or installed package name
  is deprecated. Pass the driver object directly instead.
- A database allocated during a failed connection attempt is now released.

# adbi 0.1.2 (2024-09-03)

- Docs only update

# adbi 0.1.1 (2024-01-25)

- Update for adbcdrivermanager 0.9.0.1

# adbi 0.1.0 (2023-12-21)

- Update for DBI 1.2.0
- Adds arrow API extension

# adbi 0.0.2 (2023-12-08)

- Initial CRAN release

# adbi 0.0.1 (2023-12-07)

- Target DBI 1.1.3
