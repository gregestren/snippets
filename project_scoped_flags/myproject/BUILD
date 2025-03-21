# Entry point for this example.
#
# Defines binaries that transition on project-scoped and unscoped flags, to
# demonstrate impact on build graph size and cacheability.
load("//:defs.bzl", "simple_library")
load("//bazel_skylib_copy:common_settings.bzl", "string_flag")
load(":defs.bzl", "project_scoped_binary", "unscoped_binary")

# Once a transition sets this flag, it changes all transitive dependencies.
string_flag(
    name = "unscoped_flag",
    build_setting_default = "default_value",
)

# Binary that transitions on //myproject:unscoped_flag. All its transitive
# dependencies take the flag's transitioned value.
unscoped_binary(
    name = "unscoped_target1",
    flag_value = "changed to one",
    deps = ["//also_my_project:project_lib"],
)

# Binary that transitions on //myproject:unscoped_flag. All its transitive
# dependencies take the flag's transitioned value.
unscoped_binary(
    name = "unscoped_target2",
    flag_value = "changed to two",
    deps = ["//also_my_project:project_lib"],
)

# Once a transition sets this flag, it only changes dependencies that are part
# of this project, as defined in the directories in
# myproject/PROJECT.scl. Dependencies that aren't in those directories reset the
# flag to its original value, so those can't fork across the build.
string_flag(
    name = "project_scoped_flag",
    build_setting_default = "default_value",
    scope = "project",
)

# Binary that transitions on //myproject:project_scoped_flag. Only its
# dependencies in //myproject and //also_my_project see the changd
# value. Dependencies in //lib all keep the flag's original pre-transiioned value.
project_scoped_binary(
    name = "project_scoped_target1",
    flag_value = "changed to one",
    deps = ["//also_my_project:project_lib"],
)

# Binary that transitions on //myproject:project_scoped_flag. Only its
# dependencies in //myproject and //also_my_project see the changd
# value. Dependencies in //lib all keep the flag's original pre-transiioned value.
project_scoped_binary(
    name = "project_scoped_target2",
    flag_value = "changed to two",
    deps = ["//also_my_project:project_lib"],
)
