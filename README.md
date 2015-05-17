# OPAM archive for Coq

All OPAM repositories for Coq packages live here.
Packages are organized according to the [policy](POLICY.md).


## Website and `opam` tags
The website is statically generated looking at the `opam` and `descr` files.
In particular we use the `tags` field of the `opam` file as follows:

 1. strings beginning with `keyword:` are considered as `keywords`
 2. strings beginning with `category:` are considered as `categories`
 3. a string beginning with `date:` is the date the software was last updated (not the package)
 
Example:

    tags: [ "keyword:cool" "keyword:stuff" "category:Some/Category" "date:1/1/1970" ]
 
The template in `www/index.html.in` is filled in with `<tr>` nodes for each pacakge
and the code in `www/filter.js` is used to interactively browse the archive.  The css
file `www/archive-style.css` is also part of the picture.  The script `scripts/repo2web` fills in
the template by crawling the OPAM repositories passed as arguments.
