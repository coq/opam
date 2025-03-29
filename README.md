# opam archive for the Rocq Prover and Coq

All [opam](https://opam.ocaml.org) repositories of packages for the [Rocq Prover](https://rocq-prover.org)
and [Coq](https://rocq-prover.org/about#Name) live here. Packages are organized in repositories in the following way:

* `released`: packages for officially released versions of libraries and extensions for the Rocq Prover and Coq.

* `core-dev`: packages for current and past development versions of the Rocq Prover and Coq.

* `extra-dev`: packages for development versions of libraries and extensions for the Rocq Prover and Coq.

We welcome pull requests to the `released` repository adding any Rocq or Coq-related package that is compatible
with a [released version of the Rocq Prover](https://github.com/ocaml/opam-repository/tree/master/packages/rocq-prover)
or a [released version of Coq](https://github.com/ocaml/opam-repository/tree/master/packages/coq).
Besides _libraries_ and _extensions_ of general interest, this also includes _paper artifacts_ and
other _specialized formalizations_ that are not necessarily expected to be immediately reusable by others.

## Usage

To activate the repositories:

* `released` (recommended default):

    ```
    opam repo add rocq-released https://rocq-prover.org/opam/released
    ```

* `core-dev`:

    ```
    opam repo add rocq-core-dev https://rocq-prover.org/opam/core-dev
    ```

* `extra-dev`:

    ```
    opam repo add rocq-extra-dev https://rocq-prover.org/opam/extra-dev
    ```

## Adding packages

See the [general opam documentation](https://opam.ocaml.org/doc/Packaging.html) for how to prepare a package.
You can also look at existing [pull requests](https://github.com/rocq-prover/opam/pulls)
to see how others are adding packages.

## Rocq Platform

The `released` opam archive is a key component of the [Rocq Platform](https://github.com/rocq-prover/platform),
a distribution of the Rocq Prover together with a curated set of libraries and plugins.
After installing the Platform using scripts (as opposed to via a binary installer),
additional packages in the `released` opam archive can be installed manually without the
need for repository activation.

## Website and opam metadata

The `scripts/archive2web.ml` program generates the JSON file
`coq-packages.json` by looking at the `opam` files.

In particular, it uses the `tags` field of an `opam` file as follows:

 1. strings beginning with `keyword:` are considered as `keywords`
 2. strings beginning with `category:` are considered as `categories`
 3. a string beginning with `logpath:` is considered the Rocq logical path prefix
 4. a string beginning with `date:` is the date the software was last updated
    (not the package definition)

Example:

```
tags: [
  "keyword:cool"
  "keyword:stuff"
  "category:Miscellaneous/Coq Use Examples"
  "logpath:MyPrefix"
  "date:1992-12-22"
]
```

The `homepage:`, `author:`, `maintainer:`, and `doc:` fields are
also used to generate the package entry.

The JSON file is generated during continuous integration and
[copied to the website](https://rocq-prover.org/opam/coq-packages.json).
JavaScript code on the website then loads it to dynamically generate
the content of the website on the client side.

See also [RFC#3](https://github.com/rocq-prover/rfcs/blob/master/text/003-opam-metadata.md) and
the [Rocq package index](https://rocq-prover.org/packages).

## Continuous integration

Incoming pull requests are tested on GitLab CI. **@coqbot** pushes any opened
or synchonized pull request to a branch named `pr-<number>` on GitLab. It will
trigger a CI build. If the CI build runs for too long and times out, any
member of the Rocq organization of GitLab can start it again using the "Run
Pipeline" green button at <https://gitlab.inria.fr/coq/opam/-/pipelines>.
This will then build only on runners without pre-set timeouts (the Rocq Pyrolyse
server). It may still time out if the build takes longer than the GitLab
project's timeout setting (24 hours). To skip some packages the first PR
message can contain a line such as `ci-skip: p1.v1 p2 p3.v3 p4` where
`p1`, `p2`, `p3` and `p4` are package names, and `v1` and `v3` are
versions (when no versions are given, skip all versions).
