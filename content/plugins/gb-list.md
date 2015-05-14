+++
title = "gb-list"
categories = [ "plugins" ]
+++
`gb-list` lists the packages named by the import paths, one per line.

<pre>usage: gb list [-s] [-f format] [-json] [packages]</pre>

The default output shows the package import path:

<pre>% <b>gb list github.com/constabulary/...</b>
github.com/constabulary/gb
github.com/constabulary/gb/cmd
github.com/constabulary/gb/cmd/gb
github.com/constabulary/gb/cmd/gb-env
github.com/constabulary/gb/cmd/gb-list</pre>

The `-f` flag specifies an alternate format for the list, using the syntax of package template. The default output is equivalent to `-f '{{.ImportPath}}'`.

The struct being passed to the template is currently an instance of [gb.Package](https://godoc.org/github.com/constabulary/gb#Package). <b>This structure is under active development and it's contents are not guarenteed to be stable</b>.
