load("//:defs.bzl", "simple_rule")

# We don't need an external repo to define Starlark settings. But Skylib
# provides convenience macros that reduce boilerplate. So we'll use that here.
#
# See https://docs.bazel.build/versions/master/skylark/config.html and
# https://github.com/bazelbuild/bazel-skylib) for more info.
load("@bazel_skylib//rules:common_settings.bzl", "string_flag")

# Define our custom flag.
string_flag(
    name = "my_flag",
    build_setting_default = "my_default",
    # We could also omit this attribute to allow any value:
    values = [
        "custom1",
        "custom2",
        "my_default",
    ],
)

# Try:
#  $ bazel build //:buildme                       # Print default flag value
#  $ bazel build //:buildme --//:my_flag=custom1  # Print custom value.
#  $ bazel build //:buildme --//:my_flag=bad      # Error: value not allowed.
simple_rule(name = "buildme")
