load("//:defs.bzl", "simple_library")

package(default_visibility = ["//visibility:public"])

# This target is part of //myproject:project_scoped_flag's project because
# myproject/PROJECT.scl includes //lib in its directory list.
#
# It has many deps in //lib. Those are *not* considered part of the project, so
# those won't take //myproject:project_scoped_flag's transiioned value.
simple_library(
    name = "project_lib",
    deps = ["//lib:other_lib%d" % i for i in range(1, 21)],
)
