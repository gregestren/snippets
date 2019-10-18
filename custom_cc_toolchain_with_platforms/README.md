### Example showing how to use [platforms](https://docs.bazel.build/versions/master/platforms.html) with custom C++ toolchains. 

This example defines a mock PPC-compatible C++ toolchain
(`//toolchains:example_cc_toolchain`) and a custom platform advertising PPC
(`//platforms:custom_machine`).

To see it in action:

**Build with the default (pre-supplied) toolchain:**
```sh
$ bazel build //:hello
$ bazel-bin/hello
Hello!
```

**Build with the new platform, but without telling Bazel about the new toolchain:**
```sh
$ bazel build //:hello  --incompatible_enable_cc_toolchain_resolution
--platforms=//platforms:custom_machine
ERROR: While resolving toolchains for target //:hello: no matching toolchains
found for types @bazel_tools//tools/cpp:toolchain_type
ERROR: Analysis of target '//:hello' failed; build aborted: no matching
toolchains found for types @bazel_tools//tools/cpp:toolchain_type
INFO: Elapsed time: 0.074s
INFO: 0 processes.
FAILED: Build did NOT complete successfully (0 packages loaded, 38 targets
configured)
```

**Build with the new platform and the new toolchain:**
```sh
$ bazel build //:hello  --incompatible_enable_cc_toolchain_resolution
--platforms=//platforms:custom_machine  --extra_toolchains=//toolchains:example_cc_toolchain
INFO: Build completed successfully, 4 total actions
$ cat bazel-bin/hello
dummy out
```

**Build with the new platform, but forget to set `--incompatible_enable_cc_toolchain_resolution`, so the C++ rules don't try to use a different toolchain:**
```sh
$ bazel build //:hello --platforms=//platforms:custom_machine 
--extra_toolchains=//toolchains:example_cc_toolchain
INFO: Build completed successfully, 1 total action
$ bazel-bin/hello
Hello!
```
