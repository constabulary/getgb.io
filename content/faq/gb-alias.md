+++
title = "gb conflicts with zsh's git branch alias"
date = "2015-05-14"
+++
Some systems with the git plugin for `oh-my-zsh` installed include an alias `gb` to `git branch`. This conflicts with `gb`.

If you see this error running `gb`
<pre>% <b>gb</b>
fatal: Not a git repository (or any of the parent directories): .git
% <b>which gb</b>
gb: aliased to git branch</pre>

You can remove the alias with
<pre>% <b>unalias gb</b></pre>
[See also issue #4](https://github.com/constabulary/gb/issues/4)
