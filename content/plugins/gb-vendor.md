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
2015/04/29 13:39:44 INFO project root "/home/dfc/devel/sftp"
2015/04/29 13:39:44 INFO build duration: 486.967µs map[]
2015/04/29 13:39:44 command "build" failed: failed to resolve package "github.com/pkg/sftp": cannot find package "github.com/kr/fs" in any of:
       /home/dfc/go/src/github.com/kr/fs (from $GOROOT)
       /home/dfc/devel/sftp/src/github.com/kr/fs (from $GOPATH)
       /home/dfc/devel/sftp/vendor/src/github.com/kr/fs</pre>

The build failed because the dependency, `github.com/kr/fs` was not found in the project, which was expected (ignore the message about `$GOPATH` this is a side effect of reusing the `go/build` package for dependency resolution). So we can use the `gb vendor` plugin to fetch the code for `github.com/kr/fs`, and try again

<pre>% <b>gb vendor github.com/kr/fs</b>
2015/04/29 13:42:02 INFO project root "/home/dfc/devel/sftp"
% <b>gb build all</b>
2015/04/29 13:42:06 INFO project root "/home/dfc/devel/sftp"
2015/04/29 13:42:06 INFO build duration: 701.994µs map[]
2015/04/29 13:42:06 command "build" failed: failed to resolve package "github.com/pkg/sftp": cannot find package "golang.org/x/crypto/ssh" in any of:
       /home/dfc/go/src/golang.org/x/crypto/ssh (from $GOROOT)
       /home/dfc/devel/sftp/src/golang.org/x/crypto/ssh (from $GOPATH)
       /home/dfc/devel/sftp/vendor/src/golang.org/x/crypto/ssh</pre>

Nearly, there, just missing the `golang.org/x/crypto/ssh` package, again we'll use `gb vendor`.

<pre>% <b>gb vendor golang.org/x/crypto/ssh</b>
2015/04/29 13:44:32 INFO project root "/home/dfc/devel/sftp"
% <b>gb build all</b>
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
2015/04/29 19:50:58 INFO build duration: 2.535541868s map[compile:1.895628229s link:9.827128875s]</pre>

And now it builds.
