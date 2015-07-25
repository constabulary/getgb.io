+++
title = "Can I use gb if I am working on a Go library?"
date = "2015-05-12"
+++
The short answer is yes: you can vendor source from one `gb` project to another&mdash;just copy the code from your `$PROJECT/src/` into the downstream project.

Vendoring dependencies is similar; you'll need to merge the contents of your libraries `$PROJECT/vendor/src/` into the downstream's vendor directory.

Unfortunately `gb` cannot help you with this, as Go projects don't have any concept of versions; there is no way you can look at the source of a Go package and ask it "what version are you" (assuming something like [SemVer](http://semver.org/).

Now you might have commit hashes for both copies of a particular package you are vendoring, and you might be able to take those commit hashes and look them up in the source repository and say, "Hash `abced` is newer than hash `ed3fc`."

Ultimately this is down to the project owner&mdash;the one consuming the code&mdash;and not the library developer&mdash;the one producing the code&mdash;to solve.

Additionally, if your organisation is happy to use tools like Git _submodules_ or Git _subtrees_, then this can make it easier for the downstream project to at least know which revision of a vendored dependency it is dealing with.

`gb` does not mandate the use of Git subtrees or submodules; all it cares about is that the source is present inside `$PROJECT/src` and `$PROJECT/vendor/src`.

[See issue 70.](https://github.com/constabulary/gb/issues/70)
