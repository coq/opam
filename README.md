# Unstable Repository
The repository for development packages. Use it at your own risks. Powered by [OPAM](http://opam.ocamlpro.com/).

## Usage
Enable this repository:

    opam repo add coq-unstable https://github.com/coq/repo-unstable.git

You might also want the stable and testing repositories:

    opam repo add coq-stable https://github.com/coq/repo-stable.git
    opam repo add coq-testing https://github.com/coq/repo-testing.git

To install a package:

    opam search coq-that-package
    opam install coq-that-package

## Publish
If you want to add your package, please do a pull-request to this repository. Any pull-request should be accepted, even bugged packages, since this is the unstable repository.
