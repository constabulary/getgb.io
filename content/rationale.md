+++
title = "Design rationale"
categories = [ "design" ]
date = "2001-01-01"
+++

# Design rationale

## Reproducible builds

Go does not have reproducible builds because the import statement, which drives `go get` does not contain sufficient information to identify which revision of a package it should fetch.

## Import path imprecision

From the point of view of the language and its specification, the argument to the `import` statement, the import path, is opaque. Its interpretation is dependant on the tool processing the file. `go get` interprets the import path as a URL to fetch source code. The compiler interprets the import path as a location on disk where it will find a matching compiled package.

note: the import path of a package is _not_ the package's name (although convention dictates that they match). The former is dictated by the path on disk where the source files are found. The latter comes from the `package` declaration at the top of the `.go` file. 

Peter Bourgon notes that Go packages exist in both space and time. Space is the namespacing convention of using your companies domain or GitHub URL in the import path of a package.

As for the time component, the import statement is mute; it does not contain any information which could identify one copy of a package's source from another.

It is important to note that Go packages do not have versions, at least not in the way that many consider libraries in other languages to have versions. The source of a Go package _may_ be tracked by a revision control system, and that revision control system may use a revision number or hash to identify a copy of the source at a point in time, but this is not a version number.

The primary reason why Go projects cannot be reproducibly built is two independent invocations of `go get` may fetch revisions of that code. Additionally if the source code of a package stored in a remote repository changes in an incompatible way, there is no way for code that consumes that import path to indicate that it does not want to blindly fetch the latest revision of the code.

## Vendoring

The solution to this problem is to ensure that your Go project includes in its repository all the code it depends on. This is colloquially known as _vendoring_. 

Vendoring code isolates the project from later changes in the repositories of code that it depends on. It also isolates it from political, organisational, or financial events which may affect the availability of those remote repositories.

However, the `go` tool does not make vendoring easy. A repository fetched with `go get` will always be checked out in a matching directory on the local computer and so any other code included in that repository will be checked out relative to that location, _not_ in the location that the compiler requires.

## Import rewriting

To work around this limitation, the recommended approach is to rewrite the source code you depend on to a new import path, relative to your code, so that it will be checked out in the location that is expected by the compiler, albeit with a convoluted import path.

## Why a new build tool ?

It is clear that the reason Go developers do not have reproducible builds today stems from `go get`. Import rewriting and placing tags or version numbers in the package's import paths are work arounds layered on top of the limitations of `go get`.

gb is a new build tool that does not wrap the `go` tool, nor does it use `$GOPATH`. gb replace the `go` tool's workspace metaphor with a project based approach which natively allows vendoring without the import rewriting work arounds mandated by `go get` and a `$GOPATH` workspace.

## Read more

You can watch the [original presentation](https://www.youtube.com/watch?v=c3dW80eO88I) on reproducible builds from GDG Berlin where gb was introduced. The [slides are also available](http://go-talks.appspot.com/github.com/davecheney/presentations/reproducible-builds.slide#1).

## Next up

[Read more about installing and using gb](/docs/install).
