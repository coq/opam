# OPAM archive for Coq

All OPAM repositories for Coq packages live here.
Packages are organized according to the [policy](POLICY.md).

## Website preprocessor

We follow the model of the Coq website.
One should invoke `make COQWEB=path/to/coq/www` to generate the web pages
using the same header, footer and `yamlpp` used by the Coq website (it is expected to be in `path/to/coq/www/yamlpp-0.3/yamlpp`.  The
destination folder is `www/`.

The templates are in `templates/`.  The file `archive.html.in` is first
processed by `scripts/archive2web` that fills in `<tr>` entries, then
`yamlpp` is used to insert the header and footer.

The code in `www/filter.js` is used to interactively browse the contents
of the packages table in `archive.html`.  The css file
`www/archive-style.css` is also part of the picture.

## Website and OPAM metadata

The website is statically generated looking at the `opam` and `descr` files.

In particular we use the `tags` field of the `opam` file as follows:

 1. strings beginning with `keyword:` are considered as `keywords`
 2. strings beginning with `category:` are considered as `categories`
 3. a string beginning with `date:` is the date the software was last updated
    (not the package)
 
Example:

    tags: [ "keyword:cool" "keyword:stuff" "category:Some/Category" "date:1/1/1970" ]

Finally the `homepage:`, `author:`, `maintainer:` and `doc:` fields are
also used to generate the package entry.
