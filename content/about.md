+++
title = "About gb"
categories = [ "design" ]
date = "2001-01-02"
+++
# About `gb`

`gb` is an alternative build tool for the [Go programming language](https://golang.org).

[Read more about the rationale for gb](/rationale).

## Project based

`gb` operates on the concept of a project. A gb project is a workspace for all the Go code that is required to build your project. 

A gb project is a folder on disk that contains a sub directory named <code>src/</code>. That's it, no environment variables to set. For the rest of this document we'll refer to your <code>gb</code> project as <code>$PROJECT</code>.

You can create as many projects as you like and move between them simply by changing directories.

[Read more about setting up a gb project](/docs/project).

## Installation

Installing, or upgrading gb is super simple (assuming you've already got Go installed)

    go get github.com/constabulary/gb/...

[Read more about installing and using gb](/docs/install).

## Next up

Now you've got gb installed, move on the to [setting up a gb project](/docs/project).
