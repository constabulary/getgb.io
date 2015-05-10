+++
title = "Project"
categories = [ "docs" ]
+++
# Projects

gb commands operate on a project. A project is all the source needed to build and test your package or application. 

A gb project is a workspace for all the Go code that is required to build your project. 

A <code>gb</code> project is a folder on disk that contains a subdirectory named <code>src/</code>. That's it, no environment variables to set. For the rest of this document we'll refer to your <code>gb</code> project as <code>$PROJECT</code>.

## Your stuff, their stuff

gb projects differentiate between _your stuff_, the code you've written, and _their stuff_, the code that your code depends on. We call _their stuff_ vendored code. 

Inside a *gb* project _your stuff_, the source code of your project goes in 

    $PROJECT/src/

The source code that others' have written, _their stuff_, goes in

    $PROJECT/vendor/src/

gb makes a distinction between your code and vendored code. 

## Creating a project

Creating a gb project is as simple as creating a directory

<pre>% <b>mkdir -p $HOME/code/demo-project</b></pre>

Obiviously if you like to arrange your source code in another way, you'll choose different name for your project's directory. From now on we'll refer to `$HOME/demo-project` as `$PROJECT`. We call this the _project root_.

### Creating the source directory

Now you have created a project, you will need to create a folder inside your project root directory to hold your source code.

<pre>% <b>mkdir -p $PROJECT/src</b></pre>

## Creating a package

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
2015/05/08 22:26:18 INFO project root "/home/dfc/devel/demo"
2015/05/08 22:26:18 INFO compile hello
2015/05/08 22:26:18 INFO link /home/dfc/devel/demo/bin/hello
2015/05/08 22:26:19 INFO build duration: 415.421666ms map[compile:11.867412ms link:402.973924ms]
% <b>bin/hello</b>
Hello gb</pre>

## Benefits of project based workflows vs GOPATH

## Next steps

Now that you've created a gb project, check the entire $PROJECT into the source control of your choosing.
