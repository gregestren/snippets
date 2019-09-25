# Defines the C++ settings that tell Bazel precisely how to construct C++
# commands. This is unique to C++ toolchains: other languages don't require
# anything like this. 
#
# This is mostly boilerplate. It provides all the structure Bazel's C++ logic
# expects (like where to find the compiler, linker, object code copier, etc) and
# points them all to a dummy script called "dummy_compiler_linker", which is
# checked in with this example.
#
# See
# https://docs.bazel.build/versions/master/cc-toolchain-config-reference.html
# for all the gory details.
#
# This file is more about C++-specific toolchain configuration than how to
# declare toolchains and match them to platforms. It's important if you want to
# write your own custom C++ toolchains. But if you want to write toolchains for
# other languages or figure out how to select toolchains for custom CPU types,
# OSes, etc., the BUILD file is much more interesting.

load("@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl", "tool_path")

def _impl(ctx):
    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.write(out, "Fake executable")
    tool_paths = [              
        tool_path(
            name = "ar",
            path = "dummy_compiler_linker",
        ),
        tool_path(
            name = "cpp",
            path = "dummy_compiler_linker",
        ),
        tool_path(
            name = "gcc",
            path = "dummy_compiler_linker",
        ),
        tool_path(
            name = "gcov",
            path = "dummy_compiler_linker",
        ),
        tool_path(
            name = "ld",
            path = "dummy_compiler_linker",
        ),
        tool_path(
            name = "nm",
            path = "dummy_compiler_linker",
        ),  
        tool_path(
            name = "objdump",
            path = "dummy_compiler_linker",
        ),
        tool_path(
            name = "strip",
            path = "dummy_compiler_linker",
        ),
    ]
    return [
        cc_common.create_cc_toolchain_config_info(
            ctx = ctx,
            toolchain_identifier = "dummy-toolchain",
            host_system_name = "nothing",
            target_system_name = "nothing",
            target_cpu = "nothing",
            target_libc = "nothing",
            cc_target_os = "nothing",
            compiler = "nothing",
            abi_version = "nothing",
            abi_libc_version = "eleventy",
	    tool_paths = tool_paths,
        ),
        DefaultInfo(
            executable = out,
        ),
    ]

dummy_cc_toolchain_config = rule(
    implementation = _impl,
    provides = [CcToolchainConfigInfo],
    executable = True,
)
