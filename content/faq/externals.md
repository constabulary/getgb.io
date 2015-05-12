+++
title = "Copying code is gross! Can I use git submodules?"
+++
Yes.

gb is agnostic to the source control system you use to manage your project. If your source control system has a concept of linking different repositories together, a la, git submodules or svn externals, then you can use that rather than copying code.
