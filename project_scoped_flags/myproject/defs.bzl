# Transition that sets //myproject:unscoped_flag to the "flag_value" attribute of the binary
# that sets it.
def _unscoped_transition_impl(settings, attr):
    return {"//myproject:unscoped_flag": attr.flag_value}

unscoped_transition = transition(
    implementation = _unscoped_transition_impl,
    inputs = [],
    outputs = ["//myproject:unscoped_flag"],
)

def _unscoped_binary_impl(ctx):
    print("Running implementation of " + str(ctx.label))

# Simple binary that transitions //myproject:unscoped_flag to its "flag_value" attribute.
unscoped_binary = rule(
    implementation = _unscoped_binary_impl,
    attrs = {
        "deps": attr.label_list(),
        "flag_value": attr.string(),
    },
    cfg = unscoped_transition,
)

# Transition that sets //myproject:project_scoped_flag to the "flag_value" attribute of the binary
# that sets it.
def _project_scoped_transition_impl(settings, attr):
    return {"//myproject:project_scoped_flag": attr.flag_value}

project_scoped_transition = transition(
    implementation = _project_scoped_transition_impl,
    inputs = [],
    outputs = ["//myproject:project_scoped_flag"],
)

def _project_scoped_binary_impl(ctx):
    print("Running implementation of " + str(ctx.label))

# Simple binary that transitions //myproject:project_scoped_flag to its "flag_value" attribute.
project_scoped_binary = rule(
    implementation = _project_scoped_binary_impl,
    attrs = {
        "deps": attr.label_list(),
        "flag_value": attr.string(),
    },
    cfg = project_scoped_transition,
)
