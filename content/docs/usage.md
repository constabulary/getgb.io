+++
title = "Usage"
categories = [ "docs" ]
date = "2001-01-08"
+++
`gb` is the main command. It supports sub-commands, of which there are currently two:

- `build` - which builds your code.
- `test` - which behaves identically to `gb build`, but runs tests.

## Project Root Auto Detection

`gb` automatically detects your project's root directory based on your current working directory.

A `gb` project is defined as any directory that contains a `src/` subdirectory. `gb` automatically detects the root of the project by looking at the current working directory and walking backwards until it finds a directory that contains a `src/` subdirectory.

[Read more about managing gb projects](/docs/project)

In the event you wish to override this auto detection mechanism, the `-R` flag can be used to supply a project root.

## Arguments

Arguments to `gb` subcommands are package import paths or globs relative to the project `src/` directory

- `gb build github.com/a/b` - builds `github.com/a/b`
- `gb build github.com/a/b/...` - builds `github.com/a/b` and all packages below it
- `gb build .../cmd/...` - builds anything that matches `.*/cmd/.*`
- `gb build` - shorthand for `go build ...`, depending on the current working directory this will be the entire project, or a subtree.

Other subcommands, like `test`, `vendor`, etc follow the same rule.

Note: Only import paths within the `src/` directory will match, it is not possible to build source from the `vendor/src/` directory; it will be built if needed by virtue of being imported by a package in the `src/` directory.

## Incremental Compilation

By default `gb` always performs incremental compilation and caches the results in `$PROJECT/pkg/`. See the Flags section for options to alter this behaviour.

## Flags

The following flags are supported by `gb`. Note that these are flags to subcommands, so must come *after* the subcommand.

- `-R` - sets the base of the project root search path from the current working directory to the value supplied. Effectively `gb` changes working directory to this path before searching for the project root.
- `-v` - increases verbosity, effectively lowering the output level from INFO to DEBUG.
- `-q` - decreases verbosity, effectively raising the output level to ERROR. In a successful build, no output will be displayed.
- `-f` - ignore cached packages if present, new packages built will overwrite any cached packages. This effectively disables incremental compilation.
- `-F` - do not cache packages, cached packages will still be used for incremental compilation, `-f -F` is advised to disable the package caching system.
- '-ldflags' - pass flags to linker, mainly used to set build information at link time. eg, `-ldflags "-X main.gitRevision aabbccdd"`
