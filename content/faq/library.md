+++
title = "Can I use gb if I am working on a Go library?"
date = "2015-05-12"
+++
The short answer is you can vendor source from one `gb` project to another -- just copy the code from your `$PROJECT/src/` into the downstream project.

Vendoring dependencies is similar, you'll need to merge the contents of your libraries `$PROJECT/vendor/src/` into the downstream's vendor directory.

Unfortunately `gb` cannot help you with this as Go projects don't have any concept of versions; there is no way you can look at the source of a Go package and ask it "what version are you" (assuming something like SemVer).

Now you might have commit hashes for both copies of a particular package you are vendoring, and you might be able to take those commit hashes and look them up in the source repository and say "hash abced is newer than hash ed3fc".

Ultimately this is down to the project owner, the one consuming the code, not the library developer, the one producing the code, to solve.

Additionally, if your organisation is happy to use tools like git submodules, or git subtrees, then this can make it easier for the downstream project to at least know which two revisions of a vendored dependency they are dealing with.

`gb` does not mandate the use of git subtrees or submodules, all it cares about is the source is present inside `$PROJECT/src` and `$PROJECT/vendor/src`.

[See issue 70.](https://github.com/constabulary/gb/issues/70)
