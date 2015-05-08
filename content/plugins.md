# Plugins

`gb` supports git style plugins.

Anything in `$PATH` that starts with `gb-` is considered a plugin. Plugins are executed from the main `gb` tool.

At the moment there are two plugins shipped with `gb`.

- [`env`](/plugins/gb-env) - analogous to `go env`, useful for debugging the environment passed to a `gb` plugin, tranditionally all environment variables in this set begin with `GB_`.
- [`vendor`](/plugins/gb-vendor) - is a simple wrapper around `go get` to allow easy bootstrapping of a project by fetching dependencies in to the `vendor/src/` directory.
