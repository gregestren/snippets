### Minimal example showing how to read a [custom flag](https://docs.bazel.build/versions/master/skylark/config.html#user-defined-build-settings) from a Starlark rule.

This example has two files:

* [defs.bzl](defs.bzl) - Defines a simple Starlark rule, `simple_rule`, that
  prints the the value of custom flag `//:my_flag`.

* [BUILD](BUILD) - Defines [custom flag](https://docs.bazel.build/versions/master/skylark/config.html#user-defined-build-settings)
  `//:my_flag` and provides a `simple_rule` instance to build.

To see it in action, try the following commands:

```sh
$ bazel run //:buildme
$ bazel run //:buildme --//:my_flag=custom1
$ bazel run //:buildme --//:my_flag=bad
```
