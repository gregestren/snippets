# Scratch notes brainstorming ways to choose a desired C++ compiler given
# different compiler types, hermetic vs. installed on the platform,
# user-controlled vs. auto-configured.
#
# This is all prototype code: none of this is intended to work now.
#
# Also see:
#   https://docs.google.com/document/d/1J0UtPx9YnV-9E2gDc22Cxa780W0jrn04w4CGLlmX2WQ/
#   https://docs.google.com/document/d/1TkbNTpBCE1MobexzmjUEpEaYzZVVXPt1cCTK-z2bvig/

################################################################
# config_settings:
################################################################

# Not sure about constraint_values specifically, but config_setting is generally designed
# such that if one config_setting is a "specialization" of another (i.e. is has the same
# conditions AND MORE), both are allowed in the same select() and the specialized one wins.
config_setting(
  name = "gcc_and_clang_installed_on_platform",
  constraint_values = [
    "@rules_cc//platform_constraints:gcc",   # constraint_setting that means gcc is installed on the platform
    "@rules_cc//platform_constraints:clang", # constraint_setting that means clang is installed on the platform
  ])

config_setting(
  name = "gcc_installed_on_platform",
  constraint_values = [
    "@rules_cc//platform_constraints:gcc",
  ])

config_setting(
  name = "clang_installed_on_platform",
  constraint_values = [
    "@rules_cc//platform_constraints:clang",
  ])

config_setting(
  name = "user_wants_gcc", # Assume a build_settting called "compiler" is defined in @rules_cc
  flag_values = {"@rules_cc//flags:compiler": "gcc" }) 

config_setting(
  name = "user_wants_clang",
  flag_values = {"@rules_cc//flags:compiler": "clang" })

config_setting(
  name = "no_user_selection",
  flag_values = {"@rules_cc//flags:compiler": "none" })
  
config_setting(
  name = "use_hermetic_toolchain",
  flag_values = {"@rules_cc//flags:use_hermetic_toolchain": "true"})

################################################################
# compiler choices:
################################################################

filegroup(
  name = "gcc_installed_compiler",
  srcs = glob(["installed/gcc/*"])  # Maybe the toolchain definition can use the platform.tool_paths
)                                   # proposal to find the actual installed location. If that
                                    # involves more than one file that might be awkward.

filegroup(
  name = "clang_intalled_compiler",
  srcs = glob(["installed/clang/*"]))

filegroup(
  name = "auto_choose_installed_compiler",
  srcs = select({
    ":gcc_and_clang_installed_on_platform": [":gcc_installed_compiler"], # Both available? Default to gcc.
    ":gcc_installed_on_platform": [":gcc_installed_compiler"],
    ":clang_installed_on_platform": [":clang_installed_compiler"],
  }, no_match_error = "Can't find a matching compiler!")
)
  
filegroup(
  name = "user_controlled_installed_compiler",
  srcs = select({
    ":user_wants_gcc": [":gcc_installed_compiler"],
    ":user_wants_clang": [":clang_installed_compiler"],
  }))

filegroup(
  name = "gcc_hermetic_compiler",
  srcs = glob(["hermetic/gcc/*"]))
)

filegroup(
  name = "clang_hermetic_compiler",
  srcs = glob(["hermetic/clang/*"]))

filegroup(
  name = "user_controlled_hermetic_compiler",
  srcs = select({
    ":user_wants_gcc": [":gcc_hermetic_compiler"],
    ":user_wants_clang": [":clang_hermetic_compiler"],
  }))

################################################################
# toolchains:
################################################################

cc_toolchain(
  name = "nonhermetic_toolchain",
  compiler_files = select({
    ":no_user_selection": [":auto_chooose_installed_compiler"]
    "//conditions:default": [":user_controlled_installed_compiler"]
  }))

cc_toolchain(
  name = "hermetic_toolchain",
  compiler_files = select({
    ":no_user_selection": [":gcc_hermetic_compiler"]   # Ironically *this* is the default!
    "//conditions:default": [":user_controlled_hermetic_compiler"]
  }))

alias(
  name = "use_this_toolchain"
  actual = select({
    ":use_hermetic_toolchain": ":hermetic_toolchain",
    "//conditions:default": ":nonhermetic_toolchain",
  }))

################################################################
# platforms:
################################################################

platform(
  name = "platform_with_gcc",
  constraint_values = ["@rules_cc//platform_constraints:gcc"])

platform(
  name = "platform_with_clang",
  constraint_values = ["@rules_cc//platform_constraints:clang"])

platform(
  name = "platform_with_gcc_and_clang",
  constraint_values = [
    "@rules_cc//platform_constraints:gcc",
    "@rules_cc//platform_constraints:clang",
  ])
