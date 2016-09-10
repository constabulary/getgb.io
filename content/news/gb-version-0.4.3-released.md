+++
title = "gb version 0.4.3 released"
date = "2016-06-26"
+++

gb version 0.4.3 adds the ability to automatically download released dependencies.
<!--more-->

Briefly summarised, if a dependency is listed in `$PROJECT/depfile` but is not present in the users' cache, gb will attempt to fetch it.

_NOTE: currently only dependencies hosted on github are fetched. Vanity import paths, bitbucket, private git repos, etc. are not yet supported._

#### `$PROJECT/depfile` syntax

A valid `depfile` lives at `$PROJECT/depfile`. It contains one or more lines of text. The format of the line is:

<pre>name key=value [key=value]...</pre>

`name` is an import path representing a remote repository. The only supported `key` is `version`, a valid `version` value is any SemVer 2.0.0 value. This version must match a release tag in the format

    v<semver version>

For example:

<pre>github.com/pkg/profile version=1.1.0</pre>

Will fetch the github release tagged `v1.1.0`.

#### Sample `$PROJECT/depfile`

Elements can be separated by whitespace. Lines that do not begin with a letter or number are ignored. This provides a simple mechanism for commentary.
```
# some comment
github.com/pkg/profile version=1.1.0

; some other comment
// third kind of comment
 lines starting with blank lines are also ignored
github.com/pkg/errors version=0.7.0
```

Please leave feedback on this feature [via the issue tracker](https://github.com/constabulary/gb/issues/new).

For more details, please consult the 0.4.3 release notes [available on Github](https://github.com/constabulary/gb/releases/tag/v0.4.3).
