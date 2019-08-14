# Example scenarios selecting a desired C++ toolchain from various sources.
# See BUILD for accompanying definitions.
#
# Prototype only! This isn't operational!

# 1) GCC is installed on my laptop.  I want to use it.
$ bazel build //myapp --extra_execution_platforms=//:platform_with_gcc 

# 2) Clang is installed on my laptop.  I want to use it.
$ bazel build //myapp --extra_execution_platforms=//:platform_with_clang

# 3) Clang and GCC are installed on my laptop.  I want to select which compiler to use.
$ bazel build //myapp --extra_execution_platforms=//:platform_with_gcc_and_clang --@rules_cc//flags:compiler=gcc
$ bazel build //myapp --extra_execution_platforms=//:platform_with_gcc_and_clang --@rules_cc//flags:compiler=clang

# 4) I want to ignore all compilers on my laptop and use a hermetic compiler downloaded from the internet.
#    Will provide both GCC and Clang, user can select.
$ bazel build //myapp --extra_toolchains=//:use_this_toolchain --@rules_cc//flags:compiler=gcc
$ bazel build //myapp --extra_toolchains=//:use_this_toolchain --@rules_cc//flags:compiler=clang
$ bazel build //myapp --@rules_cc//flag:use_hermetic_toolchain --@rules_cc//flags:compiler=gcc
$ bazel build //myapp --@rules_cc//flag:use_hermetic_toolchain --@rules_cc//flags:compiler=clang

# 5) I want to ignore all compilers on my laptop and use a hermetic GCC compiler downloaded from the internet.
$ echo "???"

# 6) GCC or Clang is randomly installed on my laptop. Figure out what is installed and use it.
$ bazel build //myapp --@rules_cc//flag:use_hermetic_toolchain=false
