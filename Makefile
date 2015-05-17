COQWEB=~/COQ/www/
SUITES= core-dev  extra-dev  released  stable-8.4  stable-8.5

pp = cd $(COQWEB); yamlpp-0.3/yamlpp $(abspath $(1)) -o $(abspath $(2))

# refresh opam indexes + generate website
all: check-deps
	@./scripts/refresh-opam-indexes $(SUITES)
	@./scripts/archive2web templates/archive.html.in $(SUITES)
	@$(call pp,templates/archive.html,www/archive.html)
	@(echo '<#def TITLE>Archive Policy</#def>';\
	  echo '<#include "incl/header.html">';\
	  markdown POLICY.md;\
	  echo '<#include "incl/footer.html">') > templates/policy.html
	@$(call pp,templates/policy.html,www/policy.html)
	@ln -sf $(COQWEB)/styles www/styles
	@ln -sf $(COQWEB)/files www/files

run: all
	@echo "Starting a local web server for test"
	@echo "It is accessible at: http://localhost:8000"
	@cd www && python -m SimpleHTTPServer 8000


check-deps: \
	which-opam which-lua5.1 pkg-lua-filesystem opam-config which-markdown

which-%:
	@which $* > /dev/null || (echo "Please install $*"; false)

pkg-%:
	@dpkg -l $* > /dev/null 2>&1 || (echo "Please install $*"; false)

# opam admin fails if there is no ~/.opam/config
opam-config:
	@[ -e $$HOME/.opam/config ] || (echo "Please run 'opam init'"; false)
