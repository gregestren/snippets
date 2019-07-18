Example showing how to use [Starlark
configuration](https://docs.bazel.build/versions/master/skylark/config.html) to
let a `cc_binary` set custom `copts` that `cc_library` dependencies consume.

This example relies on `select` and involves some duplication of values in the
cc_library. But it should be possible to write a `cc_library` Starlark wrapper
that consolidates this even further.
