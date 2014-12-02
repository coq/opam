# Coq Repository
The repository for stable Coq packages. Powered by [OPAM](http://opam.ocamlpro.com/).

## Usage
Enable this repository:

    opam repo add coq-stable https://github.com/coq/repo-stable.git

To install a package:

    opam search coq:that-package
    opam install coq:that-package

## Publish
If you want to add your package, please do a pull-request to this repository. Read this [tutorial](http://coq-blog.clarus.me/make-a-coq-package.html) to get an example.

## Bench
The central place for benchmarks is [Coq bench](https://coq-bench.github.io/). We test different versions of Coq and machine configurations, and update the results as often as possible.
