+++
title = "Upcoming changes"
date = "2017-04-29"
+++

gb progress has been slow for a long time; mainly due to personal issues.
Hopefully this will improve over the coming months.

There are several upcoming gb changes that may affect you.
<!--more-->
### No more support for Go 1.7 and earlier

The next major version of gb will drop support for Go 1.7 and earlier.
It's time to accept that Go 1.4 is history and move on.
With the parallel compilation changes coming in Go 1.9 we'll _finally_ have compilation speeds that best Go 1.4, so there is no reason for gb users to not just use the latest version of Go, which is currently Go 1.8.

To be clear, we'll stop testing Go 1.7 and earlier in Travis builds; gb might keep working on Go 1.7 and earlier, but it will no longer be tested.

Not testing with versions prior to Go 1.8 will also free up CI resources, which are currently overloaded by testing six Go versions on every commit.

### getgb.io website will move

Over the next month or so getgb.io will redirect to a new location.
This might end up being [dave.cheney.net/gb](https://dave.cheney.net/gb) or [github.com/constabulary/gb](https://github.com/constabulary/gb), this hasn't been decided.
Maintaining a .io domain was fun for a while, but it's turned out to be overhead and expense that I'd like to avoid.
The current [getgb.io](https://getgb.io) domain will 301 redirect until the domain registration expires.
