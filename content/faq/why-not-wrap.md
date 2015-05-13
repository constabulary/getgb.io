+++
title = "Why not wrap the go tool?"
+++
I think the fact that `gb` does not just wrap the go tool is one if its distinguishing features.

Technically there is nothing that `gb` does that couldn't be done with a shell script. In fact, several tools have been proposed over the last few years that do just this, with the exception of Keith Rarik's `godep`, all have been completely overlooked by the market.

Why is this? Well probably for one, Go programmers want to use tools written in Go. This seems like a bizarre statement, but it's true, not just for Go programmers, but pretty much most programming communities.

The second reason is, while you can construct an equivalent line of shell script to mimick what `gb` does, generalising that shell script with $PROJECT detection from your working directory and then handling the case where you may be several levels deep inside the $PROJECT is difficult. What could have been a one line shell script now becomes a rather complicated shell script, which adds further weight to programmers not wanting to use a tool not written in their language. Then let's talk about Windows compatibility ...

I think there is also value in convention. I chose vendor/src arbitrarily because that's what it was called in Rails. Without this convention people would use 3pp, external, etc. Everyone would come up with their own naming convention, and suddenly you're not talking one shell script, but one shell script per project, along with various configuration flags, etc.

So, what does `gb` do? Nothing that you couldn't do by hand. But people don't want to do things by hand, hence `gb`.
