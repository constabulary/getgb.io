+++
date        = "2014-03-01"
title       = "A sample gb project"
categories  = [ "examples" ]
+++
A picture is worth a thousand words, so let's look at a sample `gb` project.

[The sample repository is here, github.com/constabulary/example-gsftp](https://github.com/constabulary/example-gsftp).

To fetch this project, clone it. You can check out the code anywhere that you like, there is no requirement to check it out inside your <code>$GOPATH</code>.
<pre>% <b>cd $HOME/devel</b>
% <b>git clone https://github.com/constabulary/example-gsftp</b>
Cloning into 'example-gsftp'...</pre>

Let's have a look t the project on disk
<pre>% <b>cd example-gsftp</b>
% <b>tree -d $(pwd)</b>
/home/dfc/devel/example-gsftp
├── src
│   └── cmd
│       └── gsftp
└── vendor
    └── src
        ├── github.com
        │   ├── kr
        │   │   └── fs
        │   └── pkg
        │       └── sftp
        │           └── examples
        │               ├── buffered-read-benchmark
        │               ├── buffered-write-benchmark
        │               ├── streaming-read-benchmark
        │               └── streaming-write-benchmark
        └── golang.org
            └── x
                └── crypto
                    └── ssh
                        ├── agent
                        ├── terminal
                        ├── test
                        └── testdata

23 directories</pre>

You can build the project with `gb build`. `gb` prints out each package's name as it compiles it.
<pre>% <b>gb build</b>
github.com/kr/fs
golang.org/x/crypto/ssh
golang.org/x/crypto/ssh/agent
github.com/pkg/sftp
cmd/gsftp</pre>

As this project contains a command package, `cmd/gsftp`, which is built and copied to `$PROJECT/bin/gsftp`.

_note:_ your commands don't need to live in `$PROJECT/src/cmd`, but you cannot place source at the root of `$PROJECT/src` because that [package would not have a name](http://getgb.io/faq/#cannot-build-src-root).

This project uses `gb-vendor` to manage it's dependencies, so let's have a look at what has been vendored.
<pre>% <b>gb vendor list</b>
github.com/kr/fs        https://github.com/kr/fs        master  2788f0dbd16903de03cb8186e5c7d97b69ad387b
golang.org/x/crypto/ssh https://go.googlesource.com/crypto/ssh  master  c10c31b5e94b6f7a0283272dc2bb27163dcea24b
github.com/pkg/sftp     https://github.com/pkg/sftp     master  f234c3c6540c0358b1802f7fd90c0879af9232eb</pre>

## Next Up

Read more about [getting started](/examples/getting-started/) or setting up a [gb project](/docs/project/).
