+++
title = "Project"
categories = [ "docs" ]
date = "2001-01-09"
+++
# Projects

gb commands operate on a project. A project is all the source needed to build and test your package or application. 

A gb project is a workspace for all the Go code that is required to build your project. 

A gb project is a folder on disk that contains a subdirectory named <code>src/</code>. That's it, no environment variables to set. For the rest of this document we'll refer to your <code>gb</code> project as <code>$PROJECT</code>.

## Your stuff, their stuff

gb projects differentiate between _your stuff_, the code you've written, and _their stuff_, the code that your code depends on. We call _their stuff_ vendored code. gb makes a distinction between your code and vendored code. 

Inside a *gb* project _your stuff_, the source code of your project goes in 

    $PROJECT/src/

The source code that others' have written, _their stuff_, goes in

    $PROJECT/vendor/src/

## Projects do not live in $GOPATH

gb projects do not live inside your `$GOPATH`, nor does gb require you to set or update `$GOPATH` to use it. 

gb does not use `go get` to manage a project's dependencies, the owner of the project should _copy_ any code that the project depends on into the `$PROJECT/vendor/src/` directory.

gb projects are also not `go get`able as they do not follow the convention required by `go get`.

## Creating a project

Creating a gb project is as simple as creating a directory

<pre>% <b>mkdir -p $HOME/code/demo-project</b></pre>

Obiviously if you like to arrange your source code in another way, you'll choose different name for your project's directory. From now on we'll refer to `$HOME/demo-project` as `$PROJECT`. We call this the _project root_.

Now you have created a project, you will need to create a folder inside your project root directory to hold your source code.

<pre>% <b>mkdir -p $PROJECT/src</b></pre>

## Creating a package

note: gb requires you to place all your code in packages inside `$PROJECT/src/`. Code placed at the root of your projects `src/` directory will not be built, see [issue #46](https://github.com/constabulary/gb/issues/46).

Inside your source directory, let's create a package

<pre>% <b>mkdir -p $PROJECT/src/hello</b>
% <b>cat > hello.go <<EOF
package main
> 
> import "fmt"
> 
> func main() {
>         fmt.Println("Hello gb")
> }
> EOF</b></pre>

## Compiling

Now your project has some code in it, we can compile and run it

<pre>% <b>gb build all</b>
hello
% <b>bin/hello</b>
Hello gb</pre>

## Creating a source control repository

Now that you've created a gb project, you should share that project with others by check the entire contents of `$PROJECT` into the source control of your choosing. This includes any source you have copied from other projects into your `$PROJECT/vendor/src/` directory.

## Next up

[Read through examples of using gb](/examples).
