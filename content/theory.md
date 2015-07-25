+++
title = "Theory of operation"
categories = [ "Design" ]
date = "2000-01-01"
+++
This article outlines the general theory of compiling Go code, then describes the operation of `gb` as an implementation of a tool that drives compilation of Go programs.

## Theory

Go is a compiled language, and thus needs a compiler tool chain (compiler, assembler, linker, etc.) to convert source code into runable machine code. Go's compilation model differs from traditional compiled languages in the C family (C, C++, Objective-C, etc.) by not using header files. Instead of header files, the Go compilers work with packages, which are both the output of and the input to compilation.

`gb` and the `go` tool are two implementations of programs that analyse Go source code and invoke the Go compiler in a manner that ensures that the dependencies of a package are always compiled before the package itself.

### Import paths

When the go compiler encounters a an `import` statement, it interprets the argument to that statement as a path on disk, relative to a list of paths passed to the compiler with the `-I` flag. Importantly the arguments to `-I` are not where the source of Go code is stored, but rather the compiled versions. To give an example, if the compiler encounters the statement

     import "github.com/pkg/term"

it will search its list of include paths (and finally `$GOROOT/pkg`) for a file called `github.com/pkg/term.a`, and will use the information inside it when compiling. The `-I` argument to the compiler are ordered, with `$GOROOT/pkg` coming first, then any `-I` paths. The Go compiler knows nothing about `$GOPATH`.

### Incremental compilation

Because the dependencies of a package must be compiled before the package itself, incremental compilation&mdash;by storing and reusing the results of previous compilation runs&mdash;falls out naturally from the operation of tools like `gb` and `go`.

### Build tags and conditional compilation

The Go compiler is executed once per package; [conditional compilation](http://dave.cheney.net/2013/10/12/how-to-use-conditional-compilation-with-the-go-build-tool) via `// +build` tags and file name suffixes is achieved by modifying the set of files passed to the Go compiler. This can complicate incremental compilation.

## Operation

As an implementation of a tool that drives Go compilation, `gb` works as follows.

### Argument parsing

With the exception of plugins, all `gb` commands take the following form:

     gb $COMMAND [flags] arguments...

Once `gb` has determined the [project root](https://godoc.org/github.com/constabulary/gb/cmd#FindProjectroot) and constructed a [build context](https://godoc.org/github.com/constabulary/gb#Context) it parses the arguments supplied into import paths. These import paths are considered the roots for the operation of commands. For example, the command

     gb build .../sftp

will invoke the _build_ command for each package whose import path ends in `sftp`.

Arguments can be file paths, import paths, aliases (like `all`), and globs of file or import paths. The specific form of the arguments are described in the [usage document](/docs/usage/).

### Package resolution

Using the build context, each import path is [resolved to a package](https://godoc.org/github.com/constabulary/gb#Context.ResolvePackage). Package resolution involves locating the source that matches an import path&mdash;this may be in `$PROJECT/src`, or `$PROJECT/vendor/src` (noting that the former shadows the latter)&mdash;and inspecting the source with respect to the constraints applicable to the build context (i.e. filtering out files which don't match the current operating system or architecture). Package resolution is a recursive process as one package may import another. 

The build context holds references to every package resolved through it, so resolving multiple import paths is efficient.

### Incremental compilation

`gb` tries to transparently reuse the results of previous compilations wherever possible; we call this incremental compilation. As discussed above, Go packages contain symbols from the packages they depend on, so if the source that a package depends on has changed, its compiled version must be recompiled. During package resolution the staleness of a package is computed recursively.

### Compilation and linking

With package resolution complete, the build context now holds references both to all the packages and their relevant source files. Starting from the import paths&mdash;the roots of the graph&mdash;`gb` will compile each package that is considered to be stale. This is a recursive process whereby a package's dependencies are compiled before any package that depends on them. If the package is not stale, compilation is skipped and instead a reference to the compiled package stored in `$PROJECT/pkg` is used.

Once a package is compiled, a copy of it is stored in `$PROJECT/pkg` for reuse. Some packages are not cached&mdash;specifically the results of compiling a `package main` command, or the results of compiling packages for use by `gb test`.

If any of the import paths are commands, `gb` will invoke the linker and place the final program in `$PROJECT/bin`.
