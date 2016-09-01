
## What is OPAM

OPAM is the package manager for the OCaml programming language, the language 
in which Coq is implemented.
Instructions on
[how to install OPAM](http://opam.ocaml.org/doc/Install.html)
itself are available on the OPAM website.

By following the instructions on this web page one installs the last stable
version of Coq and all additional packages in the directory `~/opam-coq.@COQV@`.
Instructions target an OPAM newcomer.

## Using OPAM to install Coq

Once the `opam` command is available, i.e. OPAM is installed, one can
proceed as follows:

    export OPAMROOT=~/opam-coq.@COQV@ # installation directory
    opam init -n --comp=@OCAMLV@ -j 2 # 2 is the number of CPU cores
    opam repo add coq-released http://coq.inria.fr/opam/released
    opam install coq.@COQV@ && opam pin add coq @COQV@

One may also want to install CoqIDE.  Note that this requires GTK+ development
files to be available on the system.

    opam install coqide

## Running Coq

Every time a new shell is opened one has to type in the following lines
in order to use Coq

    export OPAMROOT=~/opam-coq.@COQV@
    eval `opam config env`

After that `coqc -v` shall run and print the version of Coq.

## Using OPAM to install Coq packages

If Coq has been installed as described above, the list of available Coq
packages can be accessed as follows

    opam search coq

The command lists the Coq package names followed by a short description.
One can access a more detailed description of a package, say `coq-sudoku`,
by typing

    opam show coq-sudoku

One can install the package by typing

    opam install coq-sudoku

