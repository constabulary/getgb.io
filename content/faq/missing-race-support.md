+++
title = "My Go installation is missing -race support"
date = "2015-12-16"
+++

Building or testing with the race detector requires that your Go installation have a current version of the race enabled runtime and standard library.
If not, gb will exit with an error like this:
```
% gb build -race
FATAL: go installation at /Users/dfc/go is missing race support. See https://getgb.io/faq/missing-race-support
```
To solve this error, you need to install 

### Packaged versions of Go
If you have installed Go from the https://golang.org/ website, your operating system's distribution, or some mechanism _other than_ compiling Go from source, then you should not receive this error.
All Go distributions from https://golang.org/ come with the race runtime properly built.
If gb says that your Go installation is missing race support, your Go install may be incorrectly installed.

I strongly recommend using the official binary distributions from https://golang.org/, they are very well tested and known to work.

### Source compiled Go
If you have compiled Go from source using `./make.bash` or `./all.bash` (or the Windows equiv.), the race enabled runtime will not be built.
To build the race enabled runtime and standard library, run the following command:
```
go install -a -race std
```
**DO NOT RUN THIS COMMAND IF YOU HAVE __NOT__ BUILT GO FROM SOURCE**
