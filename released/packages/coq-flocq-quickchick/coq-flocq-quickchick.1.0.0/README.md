# flocq-quickchick

Flocq binary float generators for QuickChick

## Installation
### From OPAM
```
opam install coq-flocq-quickchick
```

### From source
Install dependencies:

```
opam repo add coq-released https://coq.inria.fr/opam/released
opam install coq coq-quickchick coq-flocq
```

Then:
```
coq_makefile -f _CoqProject -o Makefile 
make && make install
```

## Simple Example
[Example.v](Example.v)

### Sample output from example generator:
```
QuickChecking pair_fin32_gen
[(-0,0); (0,-4179340454199820288); (-0,0); (-0,-0); (0,500603246079901696); (0,0); (4469120042235068416,0); (-0,-0); (0,2076532935753728); (0,0); (0,-0)]
```

## Documentation
All generators and sub-generators have comments
with documentation and `Example.v` has usage examples.
