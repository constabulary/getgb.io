+++
title = "gb version 0.4.4 released"
date = "2017-02-22"
+++

gb version 0.4.4 is a bugfix release for the previous 0.4.3 release.

The 0.4 series focuses on improvements to project dependency management.

# New features (since 0.4.3)
- `depfile` now supports `tag=sometag` in addition to `version=semver`. See #629
- `gb` now uses the `go/build` package for parsing source code. The previous importer introduced over the Dec 2015 break has been removed. No user visible change is expected.
- @gliptak has added a bunch of code hygiene tools to the CI process, and subsequently fixed a lot of style and hygiene issues. Thanks!

# Bug fixes (since 0.4.3)
- `gb-vendor` no longer gets tripped up when a package refers to the copy of `golang.org/x/net/http2/hpack` vendored in the Go standard library after Go 1.6. Fixes #635
- `gb-vendor` now ignores invalid XML after <meta> tag when parsing vanity imports. Fixes #643. Thanks @seh 
- `gb` now builds cgo packages correctly on distributions that default to `-PIE` mode. Fixes #607. Thanks @rdwilliamson 
- `gb-vendor` now refuses to accept more than one argument when the `-all` flag is used. Thanks @nubunto 
- `gb-vendor restore` now operates in parallel. Thanks @gsquire 
- `gb test` now works with Go 1.8. Fixes #690. Thanks to @freeformz  for the test case.

For more details, please consult the 0.4.4 release notes [available on Github](https://github.com/constabulary/gb/releases/tag/v0.4.4).
