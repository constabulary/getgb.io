+++
date        = "2014-05-07T11:27:27-04:00"
title       = "Getting started"
categories  = [ "examples" ]
+++
This document is a guide to introduce people to the `gb` project structure. A `gb` project is conceptually a `$GOPATH` per project, but saying that doesn't really help explain how to set up a new project; hence this document.

## Creating An Empty Project

A `gb` project is defined as any directory that has a `src/` subdirectory. The simplest possible `gb` project would be:

<pre>% <b>mkdir -p ~/project/src/</b>
% <b>cd ~/project</b>
% <b>tree</b>
.
└── src</pre>

`~/project` is therefore a `gb` project.

Source inside a `gb` project follows the same rules as the go tool, see the [Workspaces section of the Go getting started document](https://golang.org/doc/code.html#Workspaces). All Go code is placed inside packages, and packages are subdirectories inside the project's `src/` directory.

Let's create a `helloworld` project:

<pre>% <b>cd ~/project</b>
% <b>mkdir -p src/cmd/helloworld</b>
% <b>tree</b>
.
└── src
    └── cmd
        └── helloworld</pre>

Next, add a source code file to the project:

<pre>% <b>cat &lt;&lt;EOF > src/cmd/helloworld/helloworld.go</b>
package main

import "fmt"
  
func main() {
    fmt.Println("Hello world")
}
EOF
% <b>tree</b>
.
└── src
    └── cmd
        └── helloworld
            └── helloworld.go</pre>

Finally, build the small `helloworld` command:

<pre>% <b>gb build cmd/helloworld</b>
cmd/helloworld
% <b>tree</b>
.
├── bin
│   └── helloworld
└── src
    └── cmd
        └── helloworld
            └── helloworld.go</pre>

# Converting An Existing Project

This section shows how to construct a `gb` project using existing code bases.

## Simple Example

In this example we'll create a `gb` project from the `github.com/pkg/sftp` codebase. 

First, create a project:

<pre>% <b>mkdir -p ~/devel/sftp</b>
% <b>cd ~/devel/sftp</b></pre>

Next, checkout `github.com/pkg/sftp` to the path it expects:

<pre>% <b>mkdir -p src/github.com/pkg/sftp</b>
% <b>git clone https://github.com/pkg/sftp src/github.com/pkg/sftp</b>
% <b>tree -d</b>
.
└── src
    └── github.com
        └── pkg
            └── sftp
                └── examples
                    ├── buffered-read-benchmark
                    ├── buffered-write-benchmark
                    ├── gsftp
                    ├── streaming-read-benchmark
                    └── streaming-write-benchmark</pre>

Now, let's try to build this:

<pre>% <b>gb build all</b>
FATAL command "build" failed: failed to resolve package "github.com/pkg/sftp": cannot find package "github.com/kr/fs" in any of:
       /home/dfc/go/src/github.com/kr/fs (from $GOROOT)
       /home/dfc/devel/sftp/src/github.com/kr/fs (from $GOPATH)
       /home/dfc/devel/sftp/vendor/src/github.com/kr/fs</pre>

The build failed because the dependency, `github.com/kr/fs` was not found in the project, which was expected (ignore the message about `$GOPATH` this is a side effect of reusing the `go/build` package for dependency resolution).

We must fetch these dependencies and place them in the `$PROJECT/vendor/src` directory:

<pre>% <b>mkdir -p vendor/src/github.com/kr/fs</b>
% <b>tree -d</b>
.
├── src
│   └── github.com
│       └── pkg
│           └── sftp
│               └── examples
│                   ├── buffered-read-benchmark
│                   ├── buffered-write-benchmark
│                   ├── gsftp
│                   ├── streaming-read-benchmark
│                   └── streaming-write-benchmark
└── vendor
    └── src
        └── github.com
            └── kr
                └── fs</pre>

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

<pre>% <b>mkdir -p vendor/src/golang.org/x/crypto</b><
% <b>git clone https://github.com/golang/crypto vendor/src/golang.org/x/crypto</b>
% <b>tree -d</b>
.
├── src
│   └── github.com
│       └── pkg
│           └── sftp
│               └── examples
│                   ├── buffered-read-benchmark
│                   ├── buffered-write-benchmark
│                   ├── gsftp
│                   ├── streaming-read-benchmark
│                   └── streaming-write-benchmark
└── vendor
    └── src
        ├── github.com
        │   └── kr
        │       └── fs
        └── golang.org
            └── x
                └── crypto
                    ...
% <b>gb build all</b>
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

Notes:  

- The package name `all` matches all the packages inside your project's `src/` directory. It's a simple way to build everything, you can use other import paths and globs.
- There is no way to build your vendored source, it will be built if required to build your code in the `src/` directory.

## A More Complicated Example

For the second example we'll take a project that uses `godep` vendoring and convert it to be a `gb` project. First, we'll need to setup a project and get the source:

<pre>% <b>mkdir -p ~/devel/confd</b>
% <b>cd ~/devel/confd</b>
% <b>mkdir -p src/github.com/kelseyhightower/confd</b>
% <b>git clone https://github.com/kelseyhightower/confd src/github.com/kelseyhightower/confd</b>
% <b>tree -d</b>
.
└── src
    └── github.com
        └── kelseyhightower
            └── confd
                ├── backends
                │   ├── consul
                │   ├── dynamodb
                │   ├── env
                │   ├── etcd
                │   ├── redis
                │   └── zookeeper
                ├── contrib
                ├── docs
                ├── Godeps
                │   └── _workspace
                │       └── src
                │           ...
                ...
                ├── log
                └── resource
                    └── template</pre>


We know this project uses `godep`, so it already includes all its dependencies. We just need to rearrange things a bit:
 
<pre>% <b>mkdir -p vendor/src/</b>
% <b>mv src/github.com/kelseyhightower/confd/Godeps/_workspace/src/* vendor/src/</b>
% <b>tree -d</b>
.
├── src
│   └── github.com
│       └── kelseyhightower
│           └── confd
│               ├── backends
│               │   ├── consul
│               │   ├── dynamodb
│               │   ├── env
│               │   ├── etcd
│               │   ├── redis
│               │   └── zookeeper
│               ├── contrib
│               ├── docs
│               ├── Godeps
│               │   └── _workspace
│               │       └── src
│               ├── integration
│               │   ├── confdir
│               │   │   ├── conf.d
│               │   │   └── templates
│               │   ├── consul
│               │   ├── dynamodb
│               │   ├── etcd
│               │   ├── redis
│               │   └── zookeeper
│               ├── log
│               └── resource
│                   └── template
└── vendor
    └── src
        └── github.com
            ├── awslabs
            │   └── aws-sdk-go
            │       ...
            ├── BurntSushi
            │   └── toml
            │       ...
            ...
            └── vaughan0
                └── go-ini</pre>

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
github.com/kelseyhightower/confd
% <b>bin/confd</b>
2015-05-13T20:32:43+10:00 lucky bin/confd[14849]: INFO Backend set to etcd
2015-05-13T20:32:43+10:00 lucky bin/confd[14849]: INFO Starting confd
2015-05-13T20:32:43+10:00 lucky bin/confd[14849]: INFO Backend nodes set to http://127.0.0.1:4001
2015-05-13T20:32:43+10:00 lucky bin/confd[14849]: FATAL cannot connect to etcd cluster: http://127.0.0.1:4001</pre>

## Wrapping up

Setting up, or converting code to a `gb` project is simple. Once you've done this, you should check your `$PROJECT` directory into a source control. This includes any source you have copied from other projects into your `$PROJECT/vendor/src/` directory.
