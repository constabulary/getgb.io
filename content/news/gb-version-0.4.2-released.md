+++
title = "gb version 0.4.2 released"
date = "2016-06-14"
+++

gb version 0.4.2 is a minor bug fix release which adds one new feature, nope mode.

## Nope mode

Passing `-n` to `gb test` will cause the test binary to be compiled as per usual, however the _execution_ will be skipped.

Nope mode is conceptually the same as `gb test -run=XXX` (or some other non-matching regexp) but also avoids expensive `init`alisation if your test binaries do a lot of setup work before hitting `testing.main`. See [#599](https://github.com/constabulary/gb/issues/599) for details.

Please leave feadback on this feature [via the issue tracker](https://github.com/constabulary/gb/issues/new).

For more details, please consult the 0.4.2 release notes [available on Github](https://github.com/constabulary/gb/releases/tag/v0.4.2).
