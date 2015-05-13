SUITES= core-dev  extra-dev  released  stable-8.4  stable-8.5

# refresh opam indexes + generate website
all: check-deps
	@./scripts/post-update.hook
	@./scripts/repo2web www/archive.html.in $(SUITES)

check-deps: which-opam which-lua5.1 pkg-lua-filesystem opam-config
	@echo "all dependencies are installed"

which-%:
	@which $* > /dev/null || (echo "Please install $*"; false)

pkg-%:
	@dpkg -l $* > /dev/null 2>&1 || (echo "Please install $*"; false)

# opam admin fails if there is no ~/.opam/config
opam-config:
	@[ -e $$HOME/.opam/config ] || (echo "Please run 'opam init'"; false)
