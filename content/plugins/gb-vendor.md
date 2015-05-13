+++
title = "gb-vendor"
categories = [ "plugins" ]
+++
# gb-vendor

`gb-vendor` is a simple gb plugin that wraps the `go get` command to make it easier to create your initial gb project.

# Installation

`gb-vendor` is not included with `gb`. Installation is currently via `go get`

    go get -u -v github.com/constabulary/gb-vendor

# Usage

## Simple example

In this example we'll create a `gb` project from the `github.com/pkg/sftp` codebase. 

First, create a project,

<pre>% <b>mkdir -p ~/devel/sftp</b>
% <b>cd ~/devel/sftp</b></pre>

Now checkout `github.com/pkg/sftp` to the path it expects

<pre>% <b>mkdir -p src/github.com/pkg/sftp</b>
% git clone https://github.com/pkg/sftp src/github.com/pkg/sftp</b></pre>

Now, let's try to build this

<pre>% <b>gb build all</b>
FATAL command "build" failed: failed to resolve package "github.com/pkg/sftp": cannot find package "github.com/kr/fs" in any of:
       /home/dfc/go/src/github.com/kr/fs (from $GOROOT)
       /home/dfc/devel/sftp/src/github.com/kr/fs (from $GOPATH)
       /home/dfc/devel/sftp/vendor/src/github.com/kr/fs</pre>

The build failed because the dependency, `github.com/kr/fs` was not found in the project, which was expected (ignore the message about `$GOPATH` this is a side effect of reusing the `go/build` package for dependency resolution). So we can use the `gb vendor` plugin to fetch the code for `github.com/kr/fs`, and try again

<pre>% <b>gb vendor github.com/kr/fs</b>
% <b>gb build all</b>
FATAL command "build" failed: failed to resolve package "github.com/pkg/sftp": cannot find package "golang.org/x/crypto/ssh" in any of:
       /home/dfc/go/src/golang.org/x/crypto/ssh (from $GOROOT)
       /home/dfc/devel/sftp/src/golang.org/x/crypto/ssh (from $GOPATH)
       /home/dfc/devel/sftp/vendor/src/golang.org/x/crypto/ssh</pre>

Nearly, there, just missing the `golang.org/x/crypto/ssh` package, again we'll use `gb vendor`.

<pre>% <b>gb vendor golang.org/x/crypto/ssh</b>
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
