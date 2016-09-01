
This page contains instructions covering the case of a simple Coq package
called `foo` with version `1.0.0`.
The full documentation on OPAM packages can be found on the [OPAM web site](http://opam.ocaml.org/).

## Creating a package

First, go to the github page of [opam-coq-archive](https://github.com/coq/opam-coq-archive) and [make a fork](https://help.github.com/articles/fork-a-repo/).

The repository is now available in your personal github space.
Clone it locally by typing the following, where `user` is your github user name.

    git clone git@github.com:user/opam-coq-archive.git
    cd opam-coq-archive

Note that the correct URL can also be found by clicking on the _clone_ _or_
_download_ button.  Then create a directory named as follows

    mkdir -p released/coq-foo/coq-foo.1.0.0

Remark that the package for `foo` is named `coq-foo` and that the directory
name is the package name followed by a dot followed by the version of the
package.  Such directory has to contain at least 3 files
     
First, a text file called `url` pointing to the sources archive.
In our case `released/coq-foo/coq-foo.1.0.0/url` contains:

    http: "https://github.com/user/foo/archive/1.0.0.tar.gz"
    checksum: "d41d8cd98f00b204e9800998ecf8427e"

The MD5 checksum is mandatory, and can be obtained with:

    curl -L https://github.com/user/foo/archive/1.0.0.tar.gz | md5sum

Second, a text file called `descr` containing a short
description of the package.  In our case the contents of
`released/coq-foo/coq-foo.1.0.0/descr` are:

    Foo is a Coq library doing wonders

Third, a text file called `opam` containing some metadata like build
instructions and dependencies.  In our case
`released/coq-foo/coq-foo.1.0.0/opam` contains:

    opam-version: "1.2"
    maintainer: "your@email.address"
    homepage: "https://github.com/you/foo"
    dev-repo: "https://github.com/you/foo.git"
    bug-reports: "https://github.com/you/foo/issues"
    authors: ["Your Name"]
    license: "MIT"
    build: [
      ["coq_makefile -R . Foo -o Makefile *.v"]
      [make "-j%{jobs}%"]
    ]
    install: [
      [make "install"]
    ]
    remove: ["rm" "-R" "%{lib}%/coq/user-contrib/Foo"]
    depends: [
      "coq" {>= "8.5" & < "8.6~"}
    ]
    tags: [
      "keyword:fooish"
      "category:Miscellaneous/Coq Extensions"
      "date:2016-09-01"
      "logpath:Foo"
    ]

One can now git commit the new package

    git add released/coq-foo/coq-foo.1.0.0
    git commit -m 'Packaging foo version 1.0.0'

## Testing your new package

The preliminary step is to lint your `opam` file as follows

    opam lint released/coq-foo/coq-foo.1.0.0/opam

Once no more errors are given, the best way to test your package is to add you
local clone of `opam-coq-archive` to opam as follows, and then run `opam
install` on your new package in verbose mode:

    opam repo add test ./released
    opam install -v coq-foo

If things go wrong, after having fixed the problem and before trying again
to install the package you shall run `opam update`.

## Submitting your new package

Submission happens by [creating a pull request](https://help.github.com/articles/creating-a-pull-request/)
 on the [coq-opam-archive repository](https://github.com/coq/opam-coq-archive).

First push your changes to you personal fork

    git push origin master

Then visit the github page of your personal fork and click on the
_new_ _pull_ _request_ button.

## Making good packages



### Conventions

 1. The archive follows a [layout](layout.html).
    Regular packages shall be placed in the `released` directory.
    One can also write packages that install development branches of
    a software.  In that case `extra-dev` directory has to be used
    and the version has to end in `dev` like `mybranch.dev`.
 1. The package name should start with `coq-`, for example `coq-color` or
    `coq-interval`.
 2. The `tags` field in the `OPAM` file can contain additional metadata
    (like a categorization or the Coq logical path the package populates)
    as described in [CEP3](https://github.com/coq/ceps/blob/master/text/003-opam-metadata.md)

### Rules of thumb

The released repository shall contain software that works with a stable version
of Coq.  Packages are maintained by their corresponding authors or by the Coq
team.  Dependencies must be expressed in a conservative way providing both
lower and upper bounds to version numbers.  This way all installable packages
(i.e. with satisfiable constraints) shall compile successfully.

We advise package authors to make sure that the following conditions are
met:

 1. _Maintained_ by the Coq team or by an external author (contact email
    address in the `author:` field in OPAM metadata)
 1. _Released_ with a version number and a tar ball (that is mirrored on the Coq
    OPAM archive website)
 1. Includes a _Changelog_ that lists the main changes between any
    two versions part of this archive
 1. The _License_ must allow free redistribution (even if it not a free
    software license)
 1. _No_ _Admitted_ proofs
 1. All _Axioms_ used are documented
 1. ML code is _reviewed_ by a Coq developer
 1. _Documentation_ should be available (see the `doc:` field in the
    OPAM metadata)

In any case the Coq development team keeps the right to refuse the integration
of a package or remove any package at any time.

### Updating a package to a new version

 1. Like the initial version, the new version of the package should be
    submitted in a pull request and is encouraged to follow the
    guidelines above
 1. We recommend to ease the transition from the old to the new version by
    providing a transition strategy (a document helping a user to perform the
    switch: e.g.  documenting all renamings).
 1. The old version stays in the repository.
