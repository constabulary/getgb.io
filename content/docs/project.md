+++
title = "Projects"
categories = [ "docs" ]
date = "2001-01-09"
+++
`gb` commands operate on a project. A `gb` project is a workspace which contains all the source needed to build and test your library or application. 

A `gb` project is a folder on disk that contains a sub directory named <code>src/</code>. That's it, no environment variables to set. For the rest of this document we'll refer to your gb project as <code>$PROJECT</code>.

## Your Stuff, Their Stuff

`gb` projects differentiate between _your stuff_&mdash;the code you've written&mdash;and _their stuff_&mdash;the code that your code depends on. We call _their stuff_ "vendored code". `gb` makes a distinction between your code and vendored code. 

Inside a `gb` project, _your stuff_&mdash;the source code of your project&mdash;goes in:

<pre><b>$PROJECT/src/</b></pre>

The source code that others have written&mdash;_their stuff_&mdash;goes in:

<pre><b>$PROJECT/vendor/src/</b></pre>

## Projects Do Not Live In $GOPATH

`gb` projects do not live inside your `$GOPATH`, nor does `gb` require you to set or update `$GOPATH` to use it. 

`gb` does not use `go get` to manage a project's dependencies; the owner of the project should _copy_ any code on which project depends on into the `$PROJECT/vendor/src/` directory.

`gb` projects can be retrieved using `go get`, but cannot be built by the _go_ tool as they do not follow the convention required by `go get`.

## Creating a Project

Creating a `gb` project is as simple as creating a directory:

<pre>% <b>mkdir -p $HOME/code/demo-project</b></pre>

Obviously if you like to arrange your source code in another way, you'll choose different name for your project's directory. From now on we'll refer to `$HOME/code/demo-project` as `$PROJECT`. We call this directory the _project root_.

Now you have created a project, you will need to create a folder inside your project root directory to hold your source code:

<pre>% <b>mkdir -p $PROJECT/src</b>
% <b>tree $PROJECT</b>
/home/dfc/code/demo-project
└── src</pre>

## Creating a Package

Note: `gb` requires you to place all your code in packages inside `$PROJECT/src/`. Code placed at the root of your projects `src/` directory will not be built; see [issue #46](https://github.com/constabulary/gb/issues/46).

Inside your source directory, let's create a package:

<pre>% <b>mkdir -p $PROJECT/src/hello</b>
% <b>tree $PROJECT</b>
/home/dfc/code/demo-project
└── src
    └── hello</pre>

Next, let's add a source code file to the package:

<pre>% <b>cat &lt;&lt;EOF > $PROJECT/src/hello/hello.go</b>
package main
 
import "fmt"
 
func main() {
    fmt.Println("Hello gb")
}
EOF
% <b>tree $PROJECT</b>
/home/dfc/code/demo-project
└── src
    └── hello
        └── hello.go</pre>

## Compiling

Now that your project has some code in it, we can compile and run it:

<pre>% <b>gb build all</b>
hello
% <b>bin/hello</b>
Hello gb
% <b>tree $PROJECT</b>
/home/dfc/code/demo-project
├── bin
│   └── hello
└── src
    └── hello
        └── hello.go</pre>

## Source Control Repository

Now that you've created a `gb` project, you should share that project with others by checking the entire contents of `$PROJECT` into the source control repository of your choosing. This includes any source you have copied from other projects into your `$PROJECT/vendor/src/` directory. You don't need to track `$PROJECT/pkg` nor `$PROJECT/bin`.

## Next Up

[Read through examples of using gb](/examples).
