# OPAM archive for Coq

All OPAM repositories for Coq packages live here.
Packages are organized in the following repositories.

## released

Coq and Coq extensions that were officially released by the Coq team or their
corresponding authors.  All packages have a version number, i.e. not .dev
packages.  The repository is self contained, i.e. all packages' dependencies
can be resolved inside the `released` repository or the standard OPAM
repository.
The repository is intended to be used by people familiar with the OPAM
tool.

## core-dev

Packages for development versions of Coq.  Typically .dev packages.
The repository is self contained.
The repository is intended to be used by developers only. 

## extra-dev

Packages for development versions of external contributions to Coq.  Typically
.dev packages.  The repository is not self contained, i.e. a package may
depend on a development version of Coq part of the `core-dev` repository.
The repository is intended to be used by developers only. 

## stable-8.5

All released versions of Coq 8.5 (i.e. pl released) plus a set of packages
that work with Coq 8.5 and won't break for the whole lifetime of Coq 8.5.
Coq extensions packages here are maintained by their corresponding authors
or by the Coq team.  Updates are accepted only if they don't break anything
(like for Coq pl releases) or if a transition strategy is provided by the
authors of the extension.  In any case upgrades are handled manually and
with care to make our users life easy.
The repository is intended to be used by users preferring stability to
bleeding edge and users not familiar with the OPAM tool (see also the
opam-coq simplified shell).

