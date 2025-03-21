# A trivial library that prints its label name in its rule implementation.

def _simple_lib_impl(ctx):
    print("Running implementation of " + str(ctx.label))

simple_library = rule(
    implementation = _simple_lib_impl,
    attrs = {
        "deps": attr.label_list(),
    },
)
