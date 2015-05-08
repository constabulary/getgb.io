+++
title = "Background"
+++
# About `gb`

`gb` is a proof of concept replacement build tool for the [Go programming language](https://golang.org).

I gave a talk about `gb` and the rational for its creation at GDG Berlin in April 2015, [video](https://www.youtube.com/watch?v=c3dW80eO88I) and [slides](http://go-talks.appspot.com/github.com/davecheney/presentations/reproducible-builds.slide#1).

## Project based

`gb` operates on the concept of a project. A project has the following properties:

- A project is the consumer of your own source code, and possibly dependencies that your code consumes; nothing consumes the code from a project. Another way of thinking about it is, a project is where package `main` is.
- A project is conceptually a `$GOPATH` workspace dedicated to your project's code.
- A project supports multiple locations for source code, at the moment `src/` for your source code, and `vendor/src/` for third party code that you have copied, cloned, forked, or otherwise included in the project.
- The code that represents an `import` path is controlled by the project, by virtue of being present in one of the source code directories in the project.

