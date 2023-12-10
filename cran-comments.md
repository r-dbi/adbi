## Test environments

* local R installation, macOS 14.1.1, aarch64, R 4.2.2
* GitHub Actions (ubuntu-22.04): devel, release, oldrel-1, oldrel-2, oldrel-3,
  oldrel-4
* GitHub Actions (windows-latest): release, 3.6
* Github Actions (macOS-latest): release
* win-builder: devel, release

## R CMD check results

0 errors | 0 warnings | 1 notes

* New submission (NOTE)
* Addresses CRAN feedback:
  - Package/API names are all in single quotes
  - ADBC URL added to the Description field
  - Adds \value{} documentation
