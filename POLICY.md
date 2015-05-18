# Policy of the Archive of OPAM packages for Coq

## 1. Archive layout

The archive is organized in the following OPAM repositories.

### stable-$VERSION

The repository contains packages for all released versions of the Coq branch
$VERSION (i.e. the first stable release and all patch level releases) plus a
set of packages that comply with the policy described in section 2.
The repository is self contained , i.e. all packages' dependencies can be
resolved inside this repository or the standard OPAM repository.
The repository is intended to be used by regular Coq users, possibly via
the [opam coq shell](https://github.com/coq/opam-coq-shell).

### released

The repository contains packages for Coq and for Coq extensions that were
officially released by the Coq team or their corresponding authors.
All packages have a version number (i.e. no .dev packages).
The repository is self contained.
The repository is intended to be used by people familiar with the OPAM
tool.

### core-dev

The repository contains package for development versions of Coq.  Typically
.dev packages for Coq branches.  The repository is self contained.  The
repository is intended to be used by developers only. 

### extra-dev

The repository contains packages for development versions of external
contributions to Coq.  Typically .dev packages following the branches of the
extension.  The repository is not self contained, i.e. a package may depend on
a development version of Coq part of the `core-dev` repository.  The repository
is intended to be used by developers only. 

## 2. Policy for stable-$VERSION

In the following text "Coq developer" precisely means: someone with commit
rights in the main Coq software repository.

### 2.1 Rules of thumb

The repository shall contain software that works with Coq $VERSION and that
won't break for the whole lifetime of Coq $VERSION.  Coq extensions packages
are maintained by their corresponding authors or by the Coq team.  Updates are
accepted only if they don't break anything (like for Coq pl releases) or if a
transition strategy is provided by the authors of the extension.  
The repository is intended to be used by users preferring stability to bleeding
edge and users not familiar with the OPAM tool.

### 2.2 Requirements for entering the repository

A package is eligible if all the following constraints are satisfied.

 1. Maintained: by the Coq team or by an external author (contact email
    address in the `author:` field in OPAM metadata)
 1. Released: has a version number and a tar ball (that is mirrored on the Coq
    OPAM archive website)
 1. Change log: comes with a document that lists all changes between any
    two version part of this archive
 1. License: must allow free redistribution, not necessarily free as in free
    software or free beer
 1. The maintainer or author of the packaged software is informed his software
    is part of the archive and does not oppose
 1. Quality: no Admitted proofs
 1. Quality: all Axioms used are documented
 1. Quality: ML code should not use unsafe features and is reviewed by a Coq
    developer
 1. Quality: documentation should be available (see the `doc:` field in the
    OPAM metadata)

In any case the Coq developers keep the right to remove any package at any time.

### 2.3 Updating to a new version of a package already there

 1. The new version must satisfy all the requirements above
 1. The transition from the old to the new version must be eased by a
    transition strategy (a document helping a user to perform the switch)
 1. All packages in the repository depending on the old version
    must be ported to the new version and enter the repository
    at the same time.  These requirements apply, recursively, to
    these packages.
 1. The old version stays there

### 2.4 Going from stable-$VERSION to stable-$VERSION+1

 1. stable-$VERSION+1 is initially empty
 1. only 1 version of each package is in there initially, i.e.
    the most recent one in stable-$VERSION
    
