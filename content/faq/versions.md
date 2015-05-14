+++
title = "How can I track a vendor package's git version?"
date = "2015-05-12"
+++
At the moment the best way to do this is probably to use git submodules or subversions (depending on your preference). 

`gb` doesn't mandate that you do this, in fact `gb` doesn't mandate which DVCS you use (although obviously not using source control would be short sighted). 

In the future the [`gb-vendor`](/docs/gb-vendor) plugin may be able to help here, and it may be able to emit a file which records the revision of code vendored.
