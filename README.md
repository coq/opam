# OPAM archive for Coq

All [OPAM](https://opam.ocaml.org) repositories for Coq packages live here.
Packages are organized according to the [layout](https://coq.inria.fr/opam-layout.html).

## Repositories

To activate the repositories:
* all the released packages:

    ```
    opam repo add coq-released https://coq.inria.fr/opam/released
    ```

* development versions:

    ```
    opam repo add coq-extra-dev https://coq.inria.fr/opam/extra-dev
    ```

* development versions of Coq:

    ```
    opam repo add coq-core-dev https://coq.inria.fr/opam/core-dev
    ```

## Website and OPAM metadata

The `scripts/archive2web.ml` program generates a JSON file
`coq-packages.json` by looking at the `opam` files.

In particular, it uses the `tags` field of an `opam` file as follows:

 1. strings beginning with `keyword:` are considered as `keywords`
 2. strings beginning with `category:` are considered as `categories`
 3. a string beginning with `date:` is the date the software was last updated
    (not the package)
 4. a string beginning with `logpath:` is considered the Coq logical path prefix

Example:

```
tags: [
  "keyword:cool"
  "keyword:stuff"
  "category:Some/Category"
  "date:1992-12-22"
  "logpath:SomePrefix"
]
```

The `homepage:`, `author:`, `maintainer:`, and `doc:` fields are
also used to generate the package entry.

This JSON file is generated during continuous integration and copied to
the website. Some JavaScript code on the website then loads it to
dynamically generate the content of the webpage on client side.

See also [CEP3](https://github.com/coq/ceps/blob/master/text/003-opam-metadata.md) and
the [deployed website](https://coq.inria.fr/opam/www/).

## Continuous Integration

Incoming pull requests are tested on GitLab CI. **@coqbot** pushes any opened
or synchonized pull request to a branch named `pr-<number>` on GitLab. It will
trigger a CI build. If the CI build runs for too long and times out, any
member of the Coq organization of GitLab can start it again using the "Run
Pipeline" green button at <https://gitlab.com/coq/opam-coq-archive/pipelines>.
This will then build only on runners without pre-set timeouts (the Coq Pyrolyse
server). It may still time out if the build takes longer than the GitLab
project's timeout setting (24 hours). To skip some packages the first PR
message can contain a line such as `ci-skip: p1.v1 p2.v2` where `p1` and `p2` are package names, and `v1` and `v2` are versions.
