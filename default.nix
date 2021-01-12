{ pkgs ? (import <nixpkgs> {})
, ocamlPackages ? pkgs.ocamlPackages
}:

with pkgs;

stdenv.mkDerivation rec {

  name = "coq_website";
  src = null;

  buildInputs = [
    dune
    lua51Packages.lua
  ] ++ (with ocamlPackages; [
    ocaml
    findlib
    opam-file-format
    yojson
    ppx_deriving_yojson
    merlin
    ocp-indent
    opam
    opam-core
  ]);

}
