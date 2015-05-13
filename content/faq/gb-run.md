+++
title = "Why isn't there a gb run command?"
+++
gb is a project based tool. Every subcommand works on a list of import paths (packages) within that project, and most default to "all packages in the project".

One of my frustrations with the go tool was its inconsistency in this manner, most go commands work on import paths, except for `go run` which takes a file. Actually that's not correct, `go run` takes a list of files, but your chances of success of using it drops exponentially the more files you pass to `go run`.

While I recognise the utility of `go run` for simple examples, and it's a great way to introduce the language, the fact that it works allowed many new gophers to use it well past the point of its original intent and have a confusing and unsatisfactory time. When they ask for help, they have the double wammy that smug experienced gophers tell them "they are holding it wrong" and should learn to restructure their code.

Because gb is focused on a project workflow, not a package or file workflow; most of the time you are building or testing your project (see digression in #49 ) I felt I could make things simpler and more consistent by not supporting `gb run` at all.

[See also issue 51](https://github.com/constabulary/gb/issues/51).
