load("//:defs.bzl", "transition_rule", "cc_binary")

#transition_rule(
#    name = "foo",
#    actual_binary = ":app_with_feature1",
#    set_features = "feature1",
#)

cc_binary(
    name = "app_with_feature1",
    srcs = ["main.cc"],
    set_features = "feature1",
    deps = [":lib"],
)

cc_binary(
    name = "app_with_feature2",
    srcs = ["main.cc"],
    set_features = "feature2",
    deps = [":lib"],
)

cc_binary(
    name = "app_forgets_to_set_features",
    srcs = ["main.cc"],
    deps = [":lib"],
)

cc_library(
    name = "lib",
    srcs = ["lib.cc"],
    copts = select(
        {
            "//custom_settings:feature1": ["-Dfeature1"],
            "//custom_settings:feature2": ["-Dfeature2"],
        },
        no_match_error = "You must explicitly set which features you want!",
    ),
)
