# Defines a custom C++ toolchain that invokes the "fake" dummy_compiler_linker
# script to simulate compiling and linking.
#
# The point of this file is to show how we're defining a toolchain that triggers
# with //platforms:custom_machine. These match because they both specify
# @platforms//cpu:ppc.

# This is C++-specific overhead required for all C++ toolchains. See
# toolchain_config.bzl for details.
load("//toolchains:toolchain_config.bzl", "dummy_cc_toolchain_config")
dummy_cc_toolchain_config(
    name = "dummy-cc-toolchain-config",
)

filegroup(
    name = "toolchain_files",
    srcs = ["dummy_compiler_linker"])

# Define our cc_toolchain
# (https://docs.bazel.build/versions/master/be/c-cpp.html#cc_toolchain).
# The cc_toolchain rule is pre-defined by the C++ rule owners. It uses these
# parameters to construct a ToolchainInfo provider, as required by Bazel's
# platform/toolchain APIs.
cc_toolchain(
  name = "example_cc_toolchain_definition",
  all_files = ":toolchain_files",
  compiler_files = ":toolchain_files",
  strip_files = ":toolchain_files",
  objcopy_files = ":toolchain_files",
  linker_files = ":toolchain_files",
  dwp_files = ":toolchain_files",
  toolchain_config = ":dummy-cc-toolchain-config")

# Bazel's platform/toolchain APIs require this wrapper around the actual
# toolchain defined above. It serves two purposes: declare which
# constraint_values it supports (which can be matched to appropriate platforms)
# and tell Bazel what language this toolchain is for.
#
# So when you're building a cc_binary, Bazel has all the info it needs to give
# that cc_binary the right toolchain: it knows cc_binary requires a "C++-type
# toolchain" (this is encoded in the cc_binary rule definition) and needs to
# use a toolchain that matches whatever you set --platforms to at the command
# line.
toolchain(
  name = "example_cc_toolchain",
  toolchain = ":example_cc_toolchain_definition",
  toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
  target_compatible_with = ["@platforms//cpu:ppc"],
)  