def _copt_transition_impl(settings, attr):
    return {"//custom_settings:mycopts": attr.set_features}

_copt_transition = transition(
    implementation = _copt_transition_impl,
    inputs = [],
    outputs = ["//custom_settings:mycopts"],
)

def _transition_rule_impl(ctx):
    actual_binary = ctx.attr.actual_binary[0]
    outfile = ctx.actions.declare_file(ctx.label.name)
    cc_binary_outfile = actual_binary[DefaultInfo].files.to_list()[0]

    ctx.actions.run_shell(
        inputs = [cc_binary_outfile],
        outputs = [outfile],
        command = "cp %s %s" % (cc_binary_outfile.path, outfile.path),
    )
    return [
        # Propagate upward the actual cc_binary's runfiles.
        DefaultInfo(
            executable = outfile,
            data_runfiles = actual_binary[DefaultInfo].data_runfiles,
        ),
    ]

transition_rule = rule(
    implementation = _transition_rule_impl,
    attrs = {
        "set_features": attr.string(default = "unset"),
        "actual_binary": attr.label(cfg = _copt_transition),
        "_whitelist_function_transition": attr.label(
            default = "@bazel_tools//tools/whitelists/function_transition_whitelist",
        ),
    },
    executable = True,
)

#def cc_binary(name, **kwargs):
#   cc_binary(name, None,
def cc_binary(name, set_features = None, **kwargs):
    cc_binary_name = name + "_native_binary"
    transition_rule(
        name = name,
        actual_binary = ":%s" % cc_binary_name,
        set_features = set_features,
    )
    native.cc_binary(
        name = cc_binary_name,
        **kwargs
    )
