+++
title = "Why didn’t you contribute back to the go tool?"
+++
The Go authors agree that vendoring, taking a copy of your dependencies, is the path to repeatable builds -- we just disagree on the method.

The Go authors are recommending vendoring by copying the source of your dependencies into a folder inside your package, then rewriting the source of those vendored depdendencies to accomodate.

`gb` also recommends vendoring, but with its project based approach, it can give the same result -- all dependencies are bundled within the project, without rewriting the source code. This is important, and I believe other Go programmers agree.
