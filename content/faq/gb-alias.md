+++
title = "gb conflicts with zsh's git branch alias"
date = "2015-05-14"
+++
Some systems with the git plugin for `oh-my-zsh` installed include an alias `gb` to `git branch`. This conflicts with `gb`.

If you see this error running `gb`
```
% <b>gb</b>
fatal: Not a git repository (or any of the parent directories): .git
% <b>which gb</b>
gb: aliased to git branch
```

You can remove the alias with
``` 
% <b>unalias gb</b>
```

[See also issue #4](https://github.com/constabulary/gb/issues/4)
