+++
title = "Design rational"
+++

# Why gb

# Reproducible builds

# go get

# space, but not time

# no versions


why a new go tool

go get is the problem, a new tools frees us fron its' constraints

The reason gb does not wrap the go tool is two fold

a. divorcing itself from the go tool gives gb a clean slate to work from, not to be bound to simple orchestrate the movements of the go tool. There is a fair point to be made that in #50 I made the decision to retain some compatibility with source arranged in the traditional GOPATH layout, but this was for compatibility with tools like goimports, godoc, golint, etc which work with GOPATH. It was not for compatibility with the go tool itself.

b. Personally I don't see any value in a tool that wraps the go tool. Others have tried, most notably godep (without -r), and it received little mindshare. I'm going to go to the extreme of saying I felt that Go developers do not want another wrapper, they want an opinionated tool.
