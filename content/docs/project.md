+++
title = "Project"
categories = [ "docs" ]
+++
# Projects

A <b>gb</b> project is a workspace for all the Go code that is required to build your project.

A <code>gb</code> project is a folder on disk that contains a subdirectory named <code>src/</code>. That's it, no environment variables to set. For the rest of this document we'll refer to your <code>gb</code> project as <code>$PROJECT</code>.

## Your stuff, their stuff

<b>gb</b> projects differentiate between _your stuff_, the code you've written, and _their stuff_, the code that your code depends on. We call _their stuff_ vendored code. 

Inside a *gb* project _your stuff_, the source code of your project goes in 

    $PROJECT/src/

The source code that others' have written, _their stuff_, goes in

    $PROJECT/vendor/src/

*gb* makes a distinction between your code and vendored code. *gb* can build and test your code.

