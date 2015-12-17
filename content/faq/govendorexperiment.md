+++
title = "Does gb use the GOVENDOREXPERIMENT flag?"
date = "2015-12-17"
+++

TL;DR: gb does not use the `GOVENDOREXPERIMENT`, vendored code goes in `$PROJECT/vendor/src`.

The [`GOVENDOREXPERIMENT` flag](https://golang.org/s/go15vendor), which is enabled by default in Go 1.6, allows go gettable code to include some or all of it's dependencies in a `vendor/` folder at the top of it's repository.
The `GOVENDOREXPERIMENT` flag has no effect on gb.
gb does not use `go get` to retrieve dependencies, and gb projects are not go gettable.

You can vendor dependencies (via `gb vendor fetch` or manually) that themselves include a `vendor/` folder, but gb will ignore them for the purposes of dependency resolution.
To resolve these ignored dependencies, you can either copy them from each dependencies' `vendor/` folder to the top level of your `$PROJECT/vendor/src` directory, or vendor a fresh copy with `gb vendor fetch`.
The latter is the recommended process so the dependencies' location is recorded in the gb vendor manifest file.

Irrespective of the way you choose to build up your `$PROJECT/vendor/src` folder, the responsibility of deciding _which_ copy of a particular dependencies' source to use falls to you, the project owner.
