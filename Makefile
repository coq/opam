SUITES= released core-dev extra-dev
H=@

# refresh opam indexes
all: which-opam opam-config
	$(H)./scripts/refresh-opam-indexes $(SUITES)

which-%:
	$(H)which $* > /dev/null || (echo "Please install $*"; false)

pkg-%:
	$(H)dpkg -l $* > /dev/null 2>&1 || (echo "Please install $*"; false)

# opam admin fails if there is no ~/.opam/config
opam-config:
	$(H)[ -e $$HOME/.opam/config ] || (echo "Please run 'opam init'"; false)
