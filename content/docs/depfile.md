+++
title       = "Automatically fetch project dependencies"
categories = [ "docs" ]
date = "2001-01-01"
+++

_NOTE: This feature is currently **experimental**. Please try it out and [report any issues](https://github.com/constabulary/gb/issues/new)._

gb can optionally download released versions of your project's dependencies.

This feature is only enabled if the dependency file, `$PROJECT/depfile` is present, and the lists explicitly the required version of the dependency. If the `depfile` is updated to reflect a version which is not present locally, that will be downloaded the next time gb is run.

## Backstory
gb cares about reliable builds, a lot. Giving Go developers the tools they need to achieve repeatable builds was the motivation for developing gb. The main way gb does this is via the `$PROJECT/vendor/src` directory. If you need a _specific_ revision of a dependency, you should vendor it to `$PROJECT/vendor/src`. 

A bit later `gb-vendor` came along when it was clear that users wanted tooling to help them manage the contents of `$PROJECT/vendor/src`. This catalyzed around the `gb vendor restore` command which I now regret accepting as it confused the message that gb's reliable build story is based on vendoring.

To be clear, the answer for how to get the most reliable builds with gb is always to copy your dependencies into `$PROJECT/vendor/src`. But it also clear that not everyone is comfortable with having actual copies of their dependencies source in their project's tree; they would rather have a file that explains where to get those dependencies on request.

## Fetch missing dependencies

If a dependency is listed in `$PROJECT/depfile` but is not present in the users' cache, gb will attempt to fetch it.

_NOTE: currently only dependencies hosted on github are fetched. Vanity import paths, bitbucket, private git repos, etc. are not yet supported._
 
<h2 id="syntax"><code>depfile</code> syntax</h2>

A valid `depfile` lives at `$PROJECT/depfile`. It contains one or more lines of text. The format of the line is

     name key=value [key=value]...

- `name` is an import path representing a remote repository.
- `key` is one of the following:
   - `version`: a valid `version` value is any SemVer 2.0.0 version string. This SemVer tag must match a release tag in the format
      <pre>v&lt;semver></pre>
      For example:
      <pre>github.com/pkg/profile version=1.1.0</pre>
      Will fetch the `github.com/pkg/profile` release tagged `v1.1.0`.
   - `tag`: any remote tag. A `tag` value is not required to confirm to SemVer 2.0.0, however gb will assign no semantic meaning to the tag.

## Sample `$PROJECT/depfile`
Elements can be separated by whitespace. Lines that do not begin with a letter or number are ignored. This provides a simple mechanism for commentary.
```
# some comment
github.com/pkg/profile version=1.1.0

; some other comment
// third kind of comment
 lines starting with blank lines are also ignored
github.com/pkg/errors version=0.7.0
```

## Search order
When resolving the packages for a project, gb searches paths in the following order

- `$GOROOT/src`
- `$PROJECT/src`
- `$PROJECT/vendor/src`

When `$PROJECT/depfile` is present, the per user package cache

- `$HOME/.gb/cache/`

is appended to the end of the search list.  If a package could not be found, the cache will be searched, and if the package is not found, an attempt to fetch it from its upstream (as defined by `gb vendor fetch`, which itself is defined by `go get`'s rules) is made, and the cache searched again.

## Package cache
gb stores a cache of packages at `$HOME/.gb/cache`.

This cache is _per user_ not _per project_. This default can be changed via the `GB_HOME` environment variable.
