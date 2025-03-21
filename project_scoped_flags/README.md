### Example demonstraing new "project-scoped Starlark flags" feature.

This example demonstates Bazel's new "project-scoped flags" experimental feature. 

This feature lets you restrict a Starlark flag's transition impact to only a
couple of packages. For example, if //myproject:project_scoped_binary
transitions on Starlark flag //myproject:project_scoped_flag, we can "undo "the"
transition on that flag after leaving //myproject's qualifying packages.

The qualifying packages are determined by myproject/PROJECT.scl (PROJECT.scl is
also an experimental new Bazel feature for storing important project
information). 

Effective use of this can produce smaller, cleaner, faster, cheaper builds. In
other words, it makes config transitions cheaper.


#### Example:

Build two targets that transition on an "unscoped" Starlark flag. These targets
share a common dependency subgaph in //lib. So building them both, where each
transitions to a different value, doubles the size of that build graph.

This result shows the # of evaluated graph nodes when building these targets:

```sh
export USE_BAZEL_VERSION=last_green; bazelisk clean && bazelisk build //myproject:unscoped_target{1,2} 2>&1 | grep 'Running implementation' | wc -l
44
```

By contrast, these targets transition on project-scoped flags. The flag they
change "untransitions" on most of the subgraph. So total graph size is about
half:

```sh
export USE_BAZEL_VERSION=last_green; bazelisk clean && bazelisk build //myproject:project_scoped_target{1,2} 2>&1 | grep 'Running implementation' | wc -l
24
```

#### Exanple 2:

This uses cquery to show how many targets are analyzed in how many configurations in the above examples.

Unscoped:

```sh
export USE_BAZEL_VERSION=last_green; bazelisk cquery 'deps(//myproject:unscoped_target1+//myproject:unscoped_target2)' 2>/dev/null | perl -npe 's/^.*?\((.*)\)$/$1/' | sort | uniq -c | sort -n
      1 null
      6 47c482e
     22 a65e43f
     22 b932bb7
```

Scoped:

```sh
export USE_BAZEL_VERSION=last_green; bazelisk cquery 'deps(//myproject:project_scoped_target1+//myproject:project_scoped_target2)' 2>/dev/null | perl -npe 's/^.*?\((.*)\)$/$1/' | sort | uniq -c | sort -n
      1 null
      2 ea1423d
      2 f02fd0c
      6 47c482e
     20 7640d05
```

In both cases, you can run `$ bazelisk config` to examine the config hashes. This shows that in the unscoped version the vast majority of graph nodes are in transitioned configs with `ST-<hash>` paths. In the project-scoped version, the majority have no `ST-<hash>`.

You can also run `$ bazelisk config <hash>` to examine the specific flags in a config, and check the value of the flags used in this example.
