+++
date        = "2014-05-07T11:27:27-04:00"
title       = "Getting started"
categories  = [ "examples" ]
+++
# Getting Started

This document is a guide to introduce people to the `gb` project structure. A `gb` project is conceptually a `$GOPATH` per project, but saying that doesn't really help explain how to set up a new project; hence this document.

# Creating An Empty Project

A `gb` project is defined as any directory that has a `src/` subdirectory. The simplest possible `gb` project would be:

<pre>% <b>mkdir -p ~/project/src/</b>
% <b>cd ~/project</b></pre>

<pre>
/home/dfc/project/
           |——— src/
</pre>

`~/project` is therefore a `gb` project.

Source inside a `gb` project follows the same rules as the go tool, see the [Workspaces section of the Go getting started document](https://golang.org/doc/code.html#Workspaces). All Go code is placed inside packages, and packages are subdirectories inside the project's `src/` directory.

Let's create a `helloworld` project:

<pre>% <b>cd ~/project</b>
% <b>mkdir -p src/cmd/helloworld</b></pre>

<pre>
/home/dfc/project/
           |——— src/
                 |——— cmd/
                       |——— helloworld/
</pre>

Next, add a source code file to the project:

<pre>% <b>cat <<EOF > src/cmd/helloworld/helloworld.go</b></pre>

<pre>
package main

import "fmt"
  
func main() {
    fmt.Println("Hello world")
}
EOF
</pre>

Finally, build the small `helloworld` command:

<pre>% <b>gb build cmd/helloworld</b></pre>

# Converting An Existing Project

This section shows how to construct a `gb` project using existing code bases.

## Simple Example

In this example we'll create a `gb` project from the `github.com/pkg/sftp` codebase. 

First, create a project:

<pre>% <b>mkdir -p ~/devel/sftp</b>
% <b>cd ~/devel/sftp</b></pre>

<pre>
/home/dfc/devel/
           |——— sftp/
</pre>

Next, checkout `github.com/pkg/sftp` to the path it expects:

<pre>% <b>mkdir -p src/github.com/pkg/sftp</b>
% <b>git clone https://github.com/pkg/sftp src/github.com/pkg/sftp</b></pre>

<pre>
/home/dfc/devel/
           |——— sftp/
                 |——— src/
                       |——— github.com/
                             |——— pkg/
                                   |——— sftp/
</pre>

Now, let's try to build this:

<pre>% <b>gb build all</b>
FATAL command "build" failed: failed to resolve package "github.com/pkg/sftp": cannot find package "github.com/kr/fs" in any of:
       /home/dfc/go/src/github.com/kr/fs (from $GOROOT)
       /home/dfc/devel/sftp/src/github.com/kr/fs (from $GOPATH)
       /home/dfc/devel/sftp/vendor/src/github.com/kr/fs</pre>

The build failed because the dependency, `github.com/kr/fs` was not found in the project, which was expected (ignore the message about `$GOPATH` this is a side effect of reusing the `go/build` package for dependency resolution).

We must fetch these dependencies and place them in the `$PROJECT/vendor/src` directory:

<pre>% <b>mkdir -p vendor/src/github.com/kr/fs</b></pre>

<pre>
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
</pre>

<pre>% <b>git clone https://github.com/kr/fs vendor/src/github.com/kr/fs</b>
Cloning into 'vendor/src/github.com/kr/fs'...
remote: Counting objects: 18, done.
remote: Total 18 (delta 0), reused 0 (delta 0), pack-reused 18
Unpacking objects: 100% (18/18), done.
Checking connectivity... done.
</pre>

Now, let's try to build this:

<pre>% <b>gb build all</b>
FATAL command "build" failed: failed to resolve package "github.com/pkg/sftp": cannot find package "golang.org/x/crypto/ssh" in any of:
        /home/dfc/go/src/golang.org/x/crypto/ssh (from $GOROOT)
        /home/dfc/devel/demo/src/golang.org/x/crypto/ssh (from $GOPATH)
        /home/dfc/devel/demo/vendor/src/golang.org/x/crypto/ssh
</pre>

Nearly there, just missing the `golang.org/x/crypto/ssh` package:

<pre>% <b>mkdir -p vendor/src/golang.org/x/crypto</b></pre>

<pre>
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
</pre>

<pre>% <b>git clone https://github.com/golang/crypto vendor/src/golang.org/x/crypto</b>
Cloning into 'vendor/src/golang.org/x/crypto'...
remote: Counting objects: 1869, done.
remote: Total 1869 (delta 0), reused 0 (delta 0), pack-reused 1869
Receiving objects: 100% (1869/1869), 1.19 MiB | 550.00 KiB/s, done.
Resolving deltas: 100% (1248/1248), done.
Checking connectivity... done.
lucky(~/devel/demo) % gb build all
github.com/kr/fs
golang.org/x/crypto/ssh
golang.org/x/crypto/ssh/agent
github.com/pkg/sftp
github.com/pkg/sftp/examples/buffered-read-benchmark
github.com/pkg/sftp/examples/buffered-write-benchmark
github.com/pkg/sftp/examples/gsftp
github.com/pkg/sftp/examples/streaming-read-benchmark
github.com/pkg/sftp/examples/streaming-write-benchmark
</pre>

Build the code one last time:

<pre>% <b>gb build all</b>
github.com/kr/fs
golang.org/x/crypto/ssh
golang.org/x/crypto/ssh/agent
github.com/pkg/sftp
github.com/pkg/sftp/examples/buffered-read-benchmark
github.com/pkg/sftp/examples/buffered-write-benchmark
github.com/pkg/sftp/examples/gsftp
github.com/pkg/sftp/examples/streaming-read-benchmark
github.com/pkg/sftp/examples/streaming-write-benchmark</pre>

And now it builds.

Few Notes:  

- The package name `all` matches all the packages inside your project's `src/` directory. It's a simple way to build everything, you can use other import paths and globs.

- There is no way to build your vendored source, it will be built if required to build your code in the `src/` directory.

## More Complicated Example

For the second example we'll take a project that uses `godep` vendoring and convert it to be a `gb` project. First, we'll need to setup a project and get the source:

<pre>% <b>mkdir -p ~/devel/confd</b>
% <b>cd ~/devel/confd</b>
% <b>mkdir -p src/github.com/kelseyhightower/confd</b>
% <b>git clone https://github.com/kelseyhightower/confd src/github.com/kelseyhightower/confd</b></pre>

<pre>
/home/dfc/devel/
            |——— confd/
                  |——— src/
                        |——— github.com/
                              |——— kelseyhightower/
                                    |——— confd/
</pre>

We know this project uses `godeps`, so it already includes all its dependencies. We just need to rearrange things a bit:
 
<pre>% <b>mkdir -p vendor/src/</b>
% <b>mv src/github.com/kelseyhightower/confd/Godeps/_workspace/src/* vendor/src/</b></pre>

<pre>
/home/dfc/devel/
            |——— confd/
                  |——— src/
                        |——— github.com/
                              |——— kelseyhightower/
                                    |——— confd/
                            |——— vendor/
                                  |——— src/
                                        |——— {Code From Godep}
</pre>

Let's see if it builds:

<pre>% <b>gb build all</b>
github.com/BurntSushi/toml
github.com/hashicorp/consul/api
github.com/kelseyhightower/confd/backends/env
github.com/coreos/go-etcd/etcd
github.com/garyburd/redigo/internal
github.com/samuel/go-zookeeper/zk
github.com/Sirupsen/logrus
github.com/kelseyhightower/memkv
github.com/garyburd/redigo/redis
github.com/kelseyhightower/confd/log
github.com/kelseyhightower/confd/backends/etcd
github.com/kelseyhightower/confd/backends/consul
github.com/kelseyhightower/confd/backends/redis
github.com/kelseyhightower/confd/backends/zookeeper
github.com/kelseyhightower/confd/integration/zookeeper
github.com/kelseyhightower/confd/backends
github.com/kelseyhightower/confd/resource/template
github.com/kelseyhightower/confd</pre>

# Wrapping Up

Setting up, or converting code to a `gb` project is simple. Once you've done this, you should check your `$PROJECT` directory into a source control. This includes any source you have copied from other projects into your `$PROJECT/vendor/src/` directory.
