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

Let's walk through some examples of converting an existing project into a `gb` project.

### Simple Example

In this example, we create a `gb` project from the `github.com/pkg/sftp` codebase. 

To begin, we create a project workspace:

     *% mkdir -p ~/devel/sftp*
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
     FATAL command "build" failed: failed to resolve package "github.com/pkg/sftp": cannot find package "golang.org/x/crypto/ssh" in any of:
             /Users/bill/go/src/golang.org/x/crypto/ssh (from $GOROOT)
             /Users/bill/devel/sftp/src/golang.org/x/crypto/ssh (from $GOPATH)
             /Users/bill/devel/sftp/vendor/src/golang.org/x/crypto/ssh

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
     FATAL command "build" failed: failed to resolve package "github.com/pkg/sftp": cannot find package "golang.org/x/crypto/ssh" in any of:
             /Users/bill/go/src/golang.org/x/crypto/ssh (from $GOROOT)
             /Users/bill/devel/sftp/src/golang.org/x/crypto/ssh (from $GOPATH)
             /Users/bill/devel/sftp/vendor/src/golang.org/x/crypto/ssh

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
     github.com/kr/fs
     golang.org/x/crypto/ssh
     golang.org/x/crypto/ssh/agent
     github.com/pkg/sftp
     github.com/pkg/sftp/examples/buffered-read-benchmark
     github.com/pkg/sftp/examples/buffered-write-benchmark
     github.com/pkg/sftp/examples/gsftp
     github.com/pkg/sftp/examples/streaming-read-benchmark
     github.com/pkg/sftp/examples/streaming-write-benchmark

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
     github.com/kelseyhightower/confd/backends/redis
     github.com/kelseyhightower/confd/backends/etcd
     github.com/kelseyhightower/confd/backends/zookeeper
     github.com/kelseyhightower/confd/integration/zookeeper
     github.com/kelseyhightower/confd/backends/consul
     github.com/kelseyhightower/confd/backends
     github.com/kelseyhightower/confd/resource/template
     github.com/kelseyhightower/confd

# Wrapping Up

Setting up or converting code into a `gb` project just takes a few steps. Once you're done, just check the whole project into your source control. Now you have a way to reproduce the build your project without the need to rewrite import paths for vendored code.