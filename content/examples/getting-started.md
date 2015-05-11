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
                        |——— data/
                        |——— services/
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

# Converting Existing Projects

Let's walk through some examples of converting an existing project into a `gb` project.

### Simple Example

In this example, we create a `gb` project from the `github.com/pkg/sftp` codebase. 

To begin, we create a project workspace:

     % mkdir -p ~/devel/sftp
     % cd ~/devel/sftp

     /home/dfc/devel/
                |——— sftp/

Next, we create the directory structure for the `sftp` codebase we are converting:

     % mkdir -p src/github.com/pkg/sftp

     /home/dfc/devel/
                |——— sftp/
                      |——— src/
                            |——— github.com/
                                  |——— pkg/
                                        |——— sftp/

Finally, we checkout `github.com/pkg/sftp`, placing the code inside the directory we created:

     % git clone https://github.com/pkg/sftp src/github.com/pkg/sftp

With the code inside the `gb` project, we can now build the code. We are using the `all` option to have `gb` build all the packages inside the project:

     % gb build all
     2015/04/29 13:39:44 INFO project root "/home/dfc/devel/sftp"
     2015/04/29 13:39:44 INFO build duration: 486.967µs map[]
     2015/04/29 13:39:44 command "build" failed: failed to resolve package "github.com/pkg/sftp": cannot find package "github.com/kr/fs" in any of:
             /home/dfc/go/src/github.com/kr/fs (from $GOROOT)
             /home/dfc/devel/sftp/src/github.com/kr/fs (from $GOPATH)
             /home/dfc/devel/sftp/vendor/src/github.com/kr/fs

When we build the project, it fails because we are missing some dependencies the `gb` tool could not locate. When this happens, we can use the `vendor` command to fetch the dependencies and vendor them inside the project:

     % gb vendor github.com/kr/fs
     2015/04/29 13:42:02 INFO project root "/home/dfc/devel/sftp"

     /home/dfc/devel/
                |——— sftp/
                      |——— src/
                            |——— github.com/
                                  |——— pkg/
                                        |——— sftp/
                            |——— vendor/
                                  |——— src/
                                        |——— github.com/
                                              |——— kr/
                                                    |——— fs/

After running the `vendor` command, we have the missing code for the dependency cloned inside the new `vendor/src` directory. The canonical path for the dependency remains in tact under the `vendor/src` directory.

When we try to build the project, it fails once again because of more missing dependencies:

     % gb build all                                                                                                                   
     2015/04/29 13:42:06 INFO project root "/home/dfc/devel/sftp"
     2015/04/29 13:42:06 INFO build duration: 701.994µs map[]
     2015/04/29 13:42:06 command "build" failed: failed to resolve package "github.com/pkg/sftp": cannot find package "golang.org/x/crypto/ssh" in any of:
             /home/dfc/go/src/golang.org/x/crypto/ssh (from $GOROOT)
             /home/dfc/devel/sftp/src/golang.org/x/crypto/ssh (from $GOPATH)
             /home/dfc/devel/sftp/vendor/src/golang.org/x/crypto/ssh

We need to use the `vendor` command once more to pull down the code for this final missing dependency:

      % gb vendor golang.org/x/crypto/ssh
     2015/04/29 13:44:32 INFO project root "/home/dfc/devel/sftp"

     /home/dfc/devel/
                |——— sftp/
                      |——— src/
                            |——— github.com/
                                  |——— pkg/
                                        |——— sftp/
                            |——— vendor/
                                  |——— src/
                                        |——— github.com/
                                              |——— kr/
                                                    |——— fs/
                                        |——— golang.org/
                                              |——— x/
                                                    |——— crypto/
                                                          |——— ssh/

Now when we build the project, everything builds successfully:

     % gb build all                                                                                                                   
     2015/04/29 13:44:40 INFO project root "/home/dfc/devel/sftp"
     2015/04/29 13:44:40 INFO compile github.com/kr/fs [filesystem.go walk.go]
     2015/04/29 13:44:40 INFO compile golang.org/x/crypto/ssh [buffer.go certs.go channel.go cipher.go client.go client_auth.go common.go connection.go doc.go handshake.go kex.go keys.go mac.go messages.go mux.go server.go session.go tcpip.go transport.go]
     2015/04/29 13:44:40 INFO install compile {fs github.com/kr/fs /home/dfc/devel/sftp/vendor/src/github.com/kr/fs}
     2015/04/29 13:44:41 INFO install compile {ssh golang.org/x/crypto/ssh /home/dfc/devel/sftp/vendor/src/golang.org/x/crypto/ssh}
     2015/04/29 13:44:41 INFO compile golang.org/x/crypto/ssh/agent [client.go forward.go keyring.go server.go]
     2015/04/29 13:44:41 INFO compile github.com/pkg/sftp [attrs.go client.go packet.go release.go sftp.go]
     2015/04/29 13:44:42 INFO install compile {agent golang.org/x/crypto/ssh/agent /home/dfc/devel/sftp/vendor/src/golang.org/x/crypto/ssh/agent}
     2015/04/29 19:50:55 INFO compile github.com/pkg/sftp/examples/buffered-read-benchmark [main.go]
     2015/04/29 19:50:55 INFO compile github.com/pkg/sftp/examples/buffered-write-benchmark [main.go]
     2015/04/29 19:50:55 INFO compile github.com/pkg/sftp/examples/gsftp [main.go]
     2015/04/29 19:50:55 INFO compile github.com/pkg/sftp/examples/streaming-read-benchmark [main.go]
     2015/04/29 19:50:55 INFO compile github.com/pkg/sftp/examples/streaming-write-benchmark [main.go]
     2015/04/29 19:50:56 INFO link /home/dfc/devel/sftp/bin/buffered-read-benchmark [/tmp/gb786934546/github.com/pkg/sftp/examples/buffered-read-benchmark/main.a]
     2015/04/29 19:50:56 INFO link /home/dfc/devel/sftp/bin/gsftp [/tmp/gb786934546/github.com/pkg/sftp/examples/gsftp/main.a]
     2015/04/29 19:50:56 INFO link /home/dfc/devel/sftp/bin/streaming-read-benchmark [/tmp/gb786934546/github.com/pkg/sftp/examples/streaming-read-benchmark/main.a]
     2015/04/29 19:50:56 INFO link /home/dfc/devel/sftp/bin/streaming-write-benchmark [/tmp/gb786934546/github.com/pkg/sftp/examples/streaming-write-benchmark/main.a]
     2015/04/29 19:50:56 INFO link /home/dfc/devel/sftp/bin/buffered-write-benchmark [/tmp/gb786934546/github.com/pkg/sftp/examples/buffered-write-benchmark/main.a]
     2015/04/29 19:50:58 INFO build duration: 2.535541868s map[compile:1.895628229s link:9.827128875s]

With all the dependencies vendored, the project now builds. Thanks to the way `gb` vendors code and manages the project's workspace, none of the code brought into the project needed to have their imports rewritten.

### GODEP Example

In this example, we take a project that is using `Godep` to vendor dependencies and we convert it to be a `gb` project.

To begin, we create a project workspace and clone the source code:

     % mkdir -p ~/devel/confd
     % cd ~/devel/confd

     % mkdir -p src/github.com/kelseyhightower/confd
     % git clone https://github.com/kelseyhightower/confd src/github.com/kelseyhightower/confd  

     /home/dfc/devel/
                |——— confd/
                      |——— src/
                            |——— github.com/
                                  |——— kelseyhightower/
                                        |——— confd/

Next, we want to move the `Godep` vendored dependencies out of `Godeps` and into the `gb` projects `vendor/src` directory:
 
     % mkdir -p vendor/src/
     % mv src/github.com/kelseyhightower/confd/Godeps/_workspace/src/* vendor/src/

     /home/dfc/devel/
                |——— confd/
                      |——— src/
                            |——— github.com/
                                  |——— kelseyhightower/
                                        |——— confd/
                            |——— vendor/
                                  |——— src/
                                        |——— {Code From Godep}

Now when we build the project, everything builds successfully:

     % gb build all
     2015/04/29 19:52:16 INFO project root "/home/dfc/devel/confd"
     2015/04/29 19:52:16 INFO compile github.com/kelseyhightower/confd [confd.go config.go node_var.go version.go]
     2015/04/29 19:52:16 INFO compile github.com/kelseyhightower/confd/integration/zookeeper [main.go]
     2015/04/29 19:52:16 INFO link /home/dfc/devel/confd/bin/zookeeper [/tmp/gb934182157/github.com/kelseyhightower/confd/integration/zookeeper/main.a]
     2015/04/29 19:52:16 INFO link /home/dfc/devel/confd/bin/confd [/tmp/gb934182157/github.com/kelseyhightower/confd/main.a]
     2015/04/29 19:52:17 INFO build duration: 1.7575955s map[compile:405.681764ms link:2.275663206s]

# Wrapping Up

Setting up or converting code into a `gb` project just takes a few steps. Once you're done, just check the whole project into your source control. Now you have a way to reproduce the build your project without the need to rewrite import paths for vendored code.
