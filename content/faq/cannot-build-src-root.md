+++
title = "Why can't I place source in $PROJECT/src?"
date = "2015-05-16"
+++

Go code is organised into packages. Every package has a _name_, which is derived from its `package` declaration, and an _import path_ which is derived from its relative location inside `$PROJECT/src` (or inside `$PROJECT/vendor/src`). 

As an example the file `a.go` containing the declaration `package a` inside the directory `$PROJECT/src/github.com/dfc/a` has the name `a`, and the import path `github.com/dfc/a`.

There exists an ambiguity if Go code is placed directly at the root of the project's source directory, e.g., `$PROJECT/src/a.go`. In this case the package's name is `a`, but the package's import path is _blank_, as its directory name is the same as the project's source directory, `$PROJECT/src`.

It is not possible to use a package with a blank import path: `import ""` is a syntax error. A blank import path gives rise to two problems.

First, as `gb` always works in terms of package import paths, a package with a blank import path&mdash;that is a package whose source is stored in `$PROJECT/src`&mdash;is invisible when using the globbing operators like `gb build all` and `gb build github.com/...`. 

Second, passing `gb` a relative path to the package&mdash;i.e., `gb build .` or `gb build ..`&mdash;to explicitly tell `gb` to build the source in a particular location (and infer the import path later) will result in an error.
<pre>% <b>pwd</b>
/home/dfc/devel/demo3/src/a
% <b>gb build ..</b> # build the package directly above this directory
FATAL command "build" failed: "/home/dfc/devel/demo3/src" is not a package</pre>

To avoid this situation, we recommend that all Go code inside `gb` projects be placed in _subdirectories_ of `$PROJECT/src/`.
