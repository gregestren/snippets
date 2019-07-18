# We don't actually need an external repo to define Starlark settings. But
# Skylib provides convenience macros that reduce boilerplate, so we'll use that
# here.
#
# See https://docs.bazel.build/versions/master/skylark/config.html and
# https://github.com/bazelbuild/bazel-skylib) for more info.

load("@bazel_skylib//rules:common_settings.bzl", "string_flag")

string_flag(
    name = "mycopts",
    build_setting_default = "unset",
    # We could also omit this attribute to allow any value:
    values = [
        "feature1",
        "feature2",
        # We'll use this to trigger an error if the binary forgets
        # to set the feature it wants:
        "unset",
    ],
)

config_setting(
    name = "feature1",
    flag_values = {":mycopts": "feature1"},
)

config_setting(
    name = "feature2",
    flag_values = {":mycopts": "feature2"},
)
