COQWEB=~/COQ/www/
SUITES_COQPKGIDX = released
SUITES= $(SUITES_COQPKGIDX) core-dev extra-dev
H=@
COQV=8.8.2
OCAMLV=4.02.3

pp = (cd $(COQWEB); yamlpp-0.3/yamlpp -l en $(abspath $(1)) -o $(abspath $(2)))

ifeq "$(shell test ! -z '$(COQWEB)' -a -d $(COQWEB) || echo false)" "false"
$(error "Please use 'make COQWEB=path/to/coq/www'")
endif

# refresh opam indexes + generate website
all: check-deps
	@./scripts/refresh-opam-indexes $(SUITES)
	$(H)dune exec scripts/archive2json.exe $(SUITES_COQPKGIDX) > coq-packages.json
	$(H)./scripts/json2web.lua templates/index.html.in coq-packages.json
	$(H)$(call pp,templates/index.html,www/index.html)

run: all
	$(H)echo "Starting a local web server for test"
	$(H)echo "It is accessible at: http://localhost:8000"
	$(H)cd www && python -m SimpleHTTPServer 8000

check-deps: \
	which-opam which-lua5.1 opam-config which-markdown yamlpp

yamlpp:
	$(H)ls $(COQWEB)/yamlpp-0.3/yamlpp > /dev/null || (echo "Cannot find yamlpp. Please build the website first"; false)

which-%:
	$(H)which $* > /dev/null || (echo "Please install $*"; false)

pkg-%:
	$(H)dpkg -l $* > /dev/null 2>&1 || (echo "Please install $*"; false)

# opam admin fails if there is no ~/.opam/config
opam-config:
	$(H)[ -e $$HOME/.opam/config ] || (echo "Please run 'opam init'"; false)
