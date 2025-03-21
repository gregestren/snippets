load("//:defs.bzl", "simple_library")

package(default_visibility = ["//visibility:public"])

# Lots of targets. These aren't part of //myproject because //lib isn't in
# myproject/PROJECT.scl's directory list. So these don't take transiioned values
# of //myproject:project_scoped_flag.
[simple_library(name = "other_lib%d" % i) for i in range(1, 21)]
