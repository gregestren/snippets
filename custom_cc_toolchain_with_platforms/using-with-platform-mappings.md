**Context:** *[Platforms and bazel-out layout](https://groups.google.com/d/msg/bazel-discuss/g2jL4Le01Lg/qyJ7HDTZCwAJ)
(from bazel-discuss):*

As of this commit, there can be a discrepancy between `--platforms` and where build outputs go:

```sh
$ bazel query --output=build //platforms:custom_machine
platform(
  name = "custom_machine",
  constraint_values = ["@platforms//cpu:ppc"],
)

$ bazel clean && bazel build //:hello  --incompatible_enable_cc_toolchain_resolution
--platforms=//platforms:custom_machine  --extra_toolchains=//toolchains:example_cc_toolchain
INFO: Build completed successfully, 6 total actions

$ ls bazel-out/
k8-fastbuild  stable-status.txt  _tmp  volatile-status.txt
```

`//platorms:custom-machine` specifies `PPC`. But the output goes in `k8-fastbuild`.

https://groups.google.com/d/msg/bazel-discuss/g2jL4Le01Lg/XsEFS40rDAAJ discusses why, and a proposed workaround of
[platform mappings](https://docs.bazel.build/versions/master/platforms-intro.html#platform-mappings). These implicitly
set `--cpu=ppc` so the logic that names `bazel-out` paths (which reads `--cpu`) makes more sense.

But that creates its own problem, as discovered [here](https://groups.google.com/d/msg/bazel-discuss/g2jL4Le01Lg/TXWbYht-DAAJ).
I'll emulate this by setting `--cpu` explicitly at the command line in addition to `--platforms` (that produces the same
effect as a platorm mapping):

```sh
$ bazel clean && bazel build //:hello  --incompatible_enable_cc_toolchain_resolution
--platforms=//platforms:custom_machine --extra_toolchains=//toolchains:example_cc_toolchain  --cpu=ppc
ERROR: C:/users/yurchuk/_bazel_yurchuk/ubpijymk/external/local_config_cc/BUILD:47:1: in
cc_toolchain_suite rule @local_config_cc//:toolchain: cc_toolchain_suite
'@local_config_cc//:toolchain' does not contain a toolchain for cpu 'ppc'
```

I'm not sure why `cc_toolchain_suite` has a legacy dependency on `--cpu`, since the purpose of 
`-incompatible_enable_cc_toolchain_resolution` is that C++ toolchain resolution doesn't depend at all on `--cpu`.
That's a question for Bazel's C++ experts.

But I can demonstrate a workaround: define a custom `cc_toolchain_suite` that doesn't do anything interesting
but doesn't complain about not being able to find `--cpu=ppc`:

```sh
$ mkdir dummy_toolchain_suite
$ cat > dummy_toolchain_suite/BUILD <<EOF
cc_toolchain_suite(
    name = "blank",
    toolchains = {
        "ppc": "@local_config_cc//:cc-compiler-armeabi-v7a",
    },
    visibility = ["//visibility:public"],
)
EOF
```

Now repeat the build with `--crosstool_top` set to this new suite:

```sh
$ bazel clean && bazel build //:hello  --incompatible_enable_cc_toolchain_resolution
--platforms=//platforms:custom_machine  --extra_toolchains=//toolchains:example_cc_toolchain 
--cpu=ppc --crosstool_top=//dummy_toolchain_suite:blank
INFO: Build completed successfully, 6 total actions
```

This builds successfully. *And* we get better output paths:

```sh
ls bazel-out/
ppc-fastbuild  stable-status.txt  _tmp  volatile-status.txt
```

You can integrate this back into a platform mapping by adding both `--cpu`- and `--crosstool_top` accordingly:

```sh
platforms:
//:foobar
  --cpu=k8
  --crosstool_top=//dummy_toolchain_suite:blank
```

Hopefully the C++ experts can make this little workaround ultimately unnecessary!
