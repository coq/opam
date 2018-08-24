COQWEB=~/COQ/www/
SUITES_COQPKGIDX = extra-dev  released
SUITES= $(SUITES_COQPKGIDX) core-dev
H=@
COQV=8.8.1
OCAMLV=4.02.3

pp = (cd $(COQWEB); yamlpp-0.3/yamlpp $(abspath $(1)) -o $(abspath $(2)))

define ppmd
(echo '<#def TITLE>$(1)</#def>';\
 echo '<#include "incl/header.html">';\
 markdown $(2).md;\
 echo '<#include "incl/footer.html">') > templates/$(3).html;\
$(call pp,templates/$(3).html,www/$(3).html);\
sed -i -e 's/@COQV@/$(COQV)/g' -e 's/@OCAMLV@/$(OCAMLV)/g' www/$(3).html
endef

ifeq "$(shell test ! -z '$(COQWEB)' -a -d $(COQWEB) || echo false)" "false"
$(error "Please use 'make COQWEB=path/to/coq/www'")
endif

# refresh opam indexes + generate website
all: check-deps
	@./scripts/refresh-opam-indexes $(SUITES)
	$(H)./scripts/archive2web templates/index.html.in $(SUITES_COQPKGIDX)
	$(H)$(call pp,templates/index.html,www/index.html)
	$(H)$(call ppmd,Creating and Submitting a Package,PACKAGING,packaging)
	$(H)$(call ppmd,Layout of the Coq Package Index,LAYOUT,layout)
	$(H)$(call ppmd,Installing Coq via OPAM,USING,using)
	$(H)ln -sf $(COQWEB)/styles www/styles
	$(H)ln -sf $(COQWEB)/files www/files

run: all
	$(H)echo "Starting a local web server for test"
	$(H)echo "It is accessible at: http://localhost:8000"
	$(H)cd www && python -m SimpleHTTPServer 8000

check-deps: \
	which-opam which-lua5.1 opam-config which-markdown yamlpp

yamlpp:
	cd $(COQWEB); make yamlpp-0.3/yamlpp incl/news/recent.html

which-%:
	$(H)which $* > /dev/null || (echo "Please install $*"; false)

pkg-%:
	$(H)dpkg -l $* > /dev/null 2>&1 || (echo "Please install $*"; false)

# opam admin fails if there is no ~/.opam/config
opam-config:
	$(H)[ -e $$HOME/.opam/config ] || (echo "Please run 'opam init'"; false)
