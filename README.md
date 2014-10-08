# Unstable Repository
The repository for development packages. Use it at your own risks. Powered by [OPAM](http://opam.ocamlpro.com/).

## Usage
First enable this repository:

    opam repo add coq https://github.com/coq/opam-coq-repo-unstable.git

To install a package:

    opam search coq-that-package
    opam install coq-that-package

## Publish
If you want to add your package, please do a pull-request to this repository. Any pull-request should be accepted, even bugged packages, since this the unstable repository.
