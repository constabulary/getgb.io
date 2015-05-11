+++
date        = "2014-05-07T11:27:27-04:00"
title       = "Getting started"
+++
# Quick Overview

This document is a guide to show you how to structure `gb` based Go projects and use `gb` to build those projects.

A typical `gb` project may look like this on disk:

    /home/dfc/projects/engine/
                        |——— src/
                              |——— cmd/
                                    |——— engine/
                                          |——— main.go
                        |——— vendor/
                              |——— src/
                                    |——— github.com/codegangsta/cli/

Since the `gb` tool can identify the workspace location of the project, imports can be referenced based on their location inside the `src/` and `vendor/src/` directories:

    import (
        "data"
        "services"

        "github.com/codegangsta/cli"
    )

Building the project just requires running `gb build` from anywhere inside the `src/` directory.

# Sample Projects

Let's walk through some steps to create test projects you can try on your own.

### Project 1

The simplest possible `gb` project to create could look like this:

     % mkdir -p ~/project/src/
     % cd ~/project

     /home/dfc/project/
                |——— src/

After running those commands, `~/project` is now a `gb` project.

### Project 2

Next, let's create a hello world program as a `gb` project:

     % cd ~/project
     % mkdir -p src/cmd/hello
     
     /home/dfc/project/
                |——— src/
                      |——— cmd/
                            |——— hello/

Source code inside a `gb` project follows the same rules as the [`Go tool`](https://golang.org/doc/code.html#Workspaces). Inside of a `gb` project, we create packages inside the `src/` directory of the workspace.

Now, let's add a source code file named `hello.go` inside the `hello` package:

     % cat <<EOF > src/cmd/hello/hello.go
     package main
     
     import "fmt"
      
     func main() {
             fmt.Println("Hello World")
     }
     EOF

Finally, we can build the project to create the small comamnd named `hello` that displays `Hello World`.

     % gb build cmd/hello

# Wrapping Up

Creating a `gb` project just takes a few steps. Once you're done, just check the whole project into your source control. Now you have a way to reproduce the build your project without the need to rewrite import paths for vendored code.
