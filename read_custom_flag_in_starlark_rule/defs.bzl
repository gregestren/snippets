# Custom flags are implemented as plain Starlark rules. This means other rules
# can read them by simply including them as dependencies and reading whatever
# providers they return.
#
# string_flag, which we use in this example, defines a provider called
# "BuildSettingInfo", described here:
# https://github.com/bazelbuild/bazel-skylib/blob/9935e0f820692f5f38e3b00c64ccbbff30cebe11/rules/common_settings.bzl#L24.
load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")

def _impl(ctx):
    my_flag_val = ctx.attr._custom_flag_dep[BuildSettingInfo].value
    print("Called %s with //:my_flag=%s " % (ctx.attr.name, my_flag_val))

# This rule just prints the value of //:my_flag passed to the command line.
simple_rule = rule(
    implementation = _impl,
    attrs = {
        # To be able to read //:my_flag, we depend on it as a normal rule
        # dependency. We prefix the attribute name with a "_" because we don't
        # want users of simple_rule to set this attribute to other values.
        "_custom_flag_dep": attr.label(default = Label("//:my_flag")),
    },
)
