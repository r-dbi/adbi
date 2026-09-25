## Resubmission of an archived package

CRAN archived adbi on 2026-09-11 as it requires 'adbcdrivermanager', which had
been archived. The 'adbcdrivermanager' package is back on CRAN (0.24.0-3), as
is 'adbcsqlite' (0.24.0-2), which the examples and tests use when it is
installed.

The last check results before the archival had errors on r-release-macos-arm64
and r-release-macos-x86_64, where 'adbcsqlite' could not be loaded. The tests
now use 'adbcsqlite' and 'DBItest' only when they are installed.

## Test environments

* Ubuntu 24.04 (local): R 4.6.1
* GitHub Actions (ubuntu-latest): R-devel, release, oldrel-1 and 4.1, and
  release without suggested packages
* GitHub Actions (macos-latest): R release
* GitHub Actions (windows-latest): R release
* Windows (win-builder): R-devel

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new submission of a package that was archived on CRAN.
