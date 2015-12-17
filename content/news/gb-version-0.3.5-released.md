+++
title = "gb version 0.3.5 released"
date = "2015-12-16"
+++

gb version 0.3.5 has been released. The headline feature of this release is experimental support for race detection in `gb build` and `test`.

<!--more-->

The race detector requires that your Go installation include a race enabled runtime and stdlib.
All binary releases from the Go website have this support.
If you built Go from source, you may need to compile race support separately.
Please see [this faq entry for more information](http://getgb.io/faq/#missing-race-support).

Release notes are [available on Github](https://github.com/constabulary/gb/releases/tag/v0.3.5).
