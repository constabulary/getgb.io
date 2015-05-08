+++
title = "About gb"
categories = [ "design" ]
+++
# About `gb`

`gb` is a proof of concept replacement build tool for the [Go programming language](https://golang.org).

[Read more about the history of gb](/docs/background).

## Project based

`gb` operates on the concept of a project. A project has the following properties:

- A project is the consumer of your own source code, and possibly dependencies that your code consumes; nothing consumes the code from a project. Another way of thinking about it is, a project is where package `main` is.
- A project is a workspace dedicated to your project's code.
- A project supports multiple locations for source code, at the moment `src/` for your source code, and `vendor/src/` for third party code that you have copied, cloned, forked, or otherwise included in the project.
- The code that represents an `import` path is controlled by the project, by virtue of being present in one of the source code directories in the project.

[Read more about setting up a gb project](/docs/project).

## Installation

Installing, or upgrading *gb* is super simple (assuming you've already got Go installed)

    go get -u github.com/constabulary/gb/...

[Read more about installing and using gb](/docs/install).

## Next up

Now you've got gb installed, move on the to [getting started](/docs/getting-started)
