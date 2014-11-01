# Coq Repository
The repository for stable Coq packages. Powered by [OPAM](http://opam.ocamlpro.com/).

## Usage
Enable this repository:

    opam repo add coq-stable https://github.com/coq/repo-stable.git

To install a package:

    opam search coq:that-package
    opam install coq:that-package

## Publish
If you want to add your package, please do a pull-request to this repository. Note that only stable versions will be accepted. For development versions, you can use the [unstable repository](https://github.com/coq/opam-coq-repo-unstable).
