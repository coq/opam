# OPAM archive for Coq

All OPAM repositories for Coq packages live here.
Packages are organized in the following "suites".

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

## stable-$VERSION

All released versions of Coq $VERSION (i.e. pl released) plus a set of packages
that work with Coq $VERSION and won't break for the whole lifetime of Coq
$VERSION.  Coq extensions packages here are maintained by their corresponding
authors or by the Coq team.  Updates are accepted only if they don't break
anything (like for Coq pl releases) or if a transition strategy is provided by
the authors of the extension.  In any case upgrades are handled manually and
with care to make our users life easy.  The repository is intended to be used
by users preferring stability to bleeding edge and users not familiar with the
OPAM tool (see also the opam-coq simplified shell). No Admitted proofs, clear
listing of all Axiom used.

### policy for stable-$VERSION
This is an attempt to write down the guidelines, it is not final.

Quality requirements for being in:

 1. Maintained: by the Coq team or by an external author
 1. Released: has a version number
 1. Changelog: comes with a document that lists all changes
    involved in any version ever part of this archive
 1. License allowing redistribution
 1. The maintainer agrees
 2. No Admitted, document Axioms

Updating to a new version of a package already there:

 1. The new version must satisfy all the quality requirements
 1. The transition from the old to the new version must be
    eased by a transition strategy
 1. All packages in the suite depending on the old version
    must be ported to the new version and enter the suite
    at the same time.  These requirements apply, recursively, to
    these packages.
 1. The old version stays there

Going from stable-$VERSION to stable-$VERSION+1:

 1. stable-$VERSION+1 is initially empty
 1. it is populated re-checking the quality requirements
 1. only 1 version of each package is in there initially, i.e.
    the most recent on one in stable-$VERSION
    

## Website and `opam` tags
The website is statically generated looking at the `opam` and `descr` files.
In particular we use the `tags` field of the `opam` file as follows:

 1. strings beginning with `keyword:` are considered as `keywords`
 2. strings beginning with `category:` are considered as `categories`
 3. a string beginning with `date:` is the date the software was last updated (not the package)
 
Example:

    tags: [ "keyword:cool" "keyword:stuff" "category:Some/Category" "date:1/1/1970" ]
 
The template in `www/index.html.in` is filled in with `<tr>` nodes for each pacakge
and the code in `www/filter.js` is used to interactively browse the archive.  The css
file `www/style.css` is also part of the picture.  The script `scripts/repo2web` fills in
the template by crawling the OPAM repositories passed as arguments.
