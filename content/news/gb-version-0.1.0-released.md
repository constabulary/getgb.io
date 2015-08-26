+++
title = "gb version 0.1.0 released"
date = "2015-08-26"
+++

- New release process
- Cross compilation

<!--more-->

## New release process

By the commit log, gb is six months old, so along with a commitment to [eat my own dog food](http://dave.cheney.net/2015/08/19/using-gb-as-my-every-day-build-tool) it's time to get serious about releasing. With that in mind, [gb version 0.1.0](https://github.com/constabulary/gb/releases/tag/v0.1.0) is released today.

### Road map

The canonical gb road map is tracked in the [README file](https://github.com/constabulary/gb/blob/master/README.md). For convenience the current road map is reproduced here, but if you're reading this in the future, best to check the README.

- Cross Compilation
- gb test improvements, test output, flag handling
- gb vendor updates and bug fixes
- new package resolver (replace go/build)

## Cross compilation

The headline feature of the 0.1 series is support for cross compilation.

In 0.1.0 cross compilation has the following restrictions

- Cross compilation requires Go 1.5 or later, cross compilation is not supported with earlier versions of Go.
- Cross compilation with cgo is not supported, CGO_ENABLED is ignored.

### Usage

Cross compilation is controlled by the `GOOS` and `GOARCH` variables. Here is an example using gb to compile gb itself for `linux/arm` (some output has been elided):
<pre>% <b>env GOOS=linux GOARCH=arm gb build</b>
runtime
errors
sync/atomic
...
go/build
github.com/constabulary/gb
crypto/tls
github.com/constabulary/gb/cmd
net/http
github.com/constabulary/gb/vendor
github.com/constabulary/gb/cmd/gb-vendor
github.com/constabulary/gb/cmd/gb
% <b>file bin/gb-linux-arm</b> 
/home/dfc/bin/gb-linux-arm: ELF 32-bit LSB  executable, ARM, EABI5 version 1 (SYSV), statically linked, not stripped</pre>
Some points to note here

- gb automatically rebuilds the standard library if required. Cross compiled standard library packages are cached in `$PROJECT/pkg`, gb does not require the Go installation to be writable.
- When cross compiling (that is `GOOS` or `GOARCH` do not match the host machine), gb will append the suffix `-$GOOS-$GOARCH` to any binary placed in `$PROJECT/bin`.

Please try it out, and let us know what [works and what does not](https://github.com/constabulary/gb/issues/new).
