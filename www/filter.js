var data = [];

function filter_init() {
  var data_root = document.getElementById('data');

  var categories_elems = data_root.getElementsByClassName('category');
  var categories = []; 
  for (var e in categories_elems) {
    if (categories_elems[e].innerHTML !== undefined)
    categories.push(categories_elems[e].innerHTML);
  }
  var keywords_elems = data_root.getElementsByClassName('keyword');
  var keywords = []; 
  for (var e in keywords_elems) {
    if (keywords_elems[e].innerHTML !== undefined)
      keywords.push(keywords_elems[e].innerHTML);
  }
  var suites_elems = data_root.getElementsByClassName('suite');
  var suites = []; 
  for (var e in suites_elems) {
    if (suites_elems[e].innerHTML !== undefined)
      suites.push(suites_elems[e].innerHTML);
  }
  var f_selected = document.getElementById('f-selected');
  
  function popup(action,prep,style,txt) {
    var popup = document.createElement('div');
    popup.appendChild(document.createTextNode(action + ' '));
    popup.appendChild(document.createElement('strong'));
    var txt = txt.replace(/\//g,'/ ');
    popup.lastChild.appendChild(document.createTextNode(txt));
    popup.appendChild(
      document.createTextNode(' '+prep+' the set of active filters'));
    popup.setAttribute('class',style);
    return popup;
  }
  function key(txt,classname){
    var key = document.createElement('span');
    key.appendChild(document.createTextNode(txt));
    key.setAttribute('class','key-'+classname);
    return key;
  }
  function shorten(txt){
    return document.createTextNode(txt
     .replace(/Computer Science/,'CS')
     .replace(/Miscellaneous/,'Misc')
     .replace(/Arithmetic and Number Theory/,'Arith')
     .replace(/Extracted Programs/,'Extracted')
     .replace(/Concurrent Systems and Protocols/,'Concurrency')
     .replace(/Decision Procedures and Certified Algorithms/,'Algo')
     .replace(/Mathematics/,'Math'));
  }
  
  categories = sort_unique(categories);
  var f_categories = document.getElementById('f-categories');
  for (var c in categories) {
    var span = document.createElement('div');
    span.appendChild(shorten(categories[c]));
    span.appendChild(key(categories[c],'category'));
    span.setAttribute('class','category-selector');
    span.setAttribute("onclick","move(this,'f-categories','f-selected')");
    span.appendChild(popup('Add','to','popup-add',categories[c]));
    span.appendChild(popup('Remove','from','popup-remove',categories[c]));
    f_categories.appendChild(span);
  }
  keywords = sort_unique(keywords);
  var f_keywords = document.getElementById('f-keywords');
  for (var c in keywords) {
    var span = document.createElement('div');
    span.appendChild(document.createTextNode(keywords[c]));
    span.appendChild(key(keywords[c],'keyword'));
    span.setAttribute('class','keyword-selector');
    span.setAttribute("onclick","move(this,'f-keywords','f-selected')");
    span.appendChild(popup('Add','to','popup-add',keywords[c]));
    span.appendChild(popup('Remove','from','popup-remove',keywords[c]));
    f_keywords.appendChild(span);
  }
  suites = sort_unique(suites);
  var f_suites = document.getElementById('f-suites');
  for (var c in suites) {
    var span = document.createElement('div');
    span.appendChild(document.createTextNode(suites[c]));
    span.appendChild(key(suites[c],'suite'));
    span.setAttribute('class','suite-selector');
    span.setAttribute("onclick","move(this,'f-suites','f-selected')");
    span.appendChild(popup('Add','to','popup-add',suites[c]));
    span.appendChild(popup('Remove','from','popup-remove',suites[c]));
    f_suites.appendChild(span);
  }

  for (var i in data_root.childNodes) {
    var elem = data_root.childNodes[i];
    if (elem.tagName === 'TR') {
      data.push(elem);
    }
  }
  data.sort(function(a,b) {
    return (a.querySelector('.name').innerHTML
		    .localeCompare(b.querySelector('.name').innerHTML));
  });
  update_filter();
}

function update_filter() {
  function array_exists(a,p) {
    var b = false;
    for (var i = 0; i < a.length && !b; i++) {
      b = p(a[i]); 
    }
    return b;
  }

  function any_field(node,re) {
    return (re.test(node.querySelector('.package .description').innerHTML) || 
	    re.test(node.querySelector('.package .name').innerHTML) ||
            array_exists(node.querySelectorAll('.package .category'),
		    function(c) { return re.test(c.innerHTML) }) ||
            array_exists(node.querySelectorAll('.package .date'),
		    function(c) { return re.test(c.innerHTML) }) ||
            array_exists(node.querySelectorAll('.package .version'),
		    function(c) { return re.test(c.innerHTML) }) ||
            array_exists(node.querySelectorAll('.package .suite'),
		    function(c) { return re.test(c.innerHTML) }) ||
	    array_exists(node.querySelectorAll('.package .keyword'),
		    function(c) { return re.test(c.innerHTML) }));
  }
  function only_class(node, classname, re) {
    return (array_exists(node.querySelectorAll('.package '+classname),
		    function(c) { return re.test(c.innerHTML) }));
  }

  var custom_input = document.getElementById('custom-filter');
  var custom_filters = [];
  if (custom_input.value !== undefined && custom_input.value !== "")
    custom_filters = (custom_input.value.split(" ")
		    .filter(function (x) { return (x !== ""); }));

  var selected = document.querySelectorAll('#f-selected span.key-keyword');
  var kwd_filters = []
  for (var i in selected) {
    if (selected[i].innerHTML !== undefined && selected[i].innerHTML !== "")
      kwd_filters.push(selected[i].innerHTML);
  }
  var selected = document.querySelectorAll('#f-selected span.key-category');
  var cat_filters = []
  for (var i in selected) {
    if (selected[i].innerHTML !== undefined && selected[i].innerHTML !== "")
      cat_filters.push(selected[i].innerHTML);
  }
  var selected = document.querySelectorAll('#f-selected span.key-suite');
  var suite_filters = []
  for (var i in selected) {
    if (selected[i].innerHTML !== undefined && selected[i].innerHTML !== "")
      suite_filters.push(selected[i].innerHTML);
  }

  function filter(node) {
    var b = true;
    for(var i = 0; i < custom_filters.length && b; i++) {
      var re = new RegExp(custom_filters[i],"im");
      b = any_field(node, re);
    }
    for(var i = 0; i < kwd_filters.length && b; i++) {
      var re = new RegExp('^'+kwd_filters[i]+'$',"i");
      b = only_class(node, '.keyword', re);
    }
    for(var i = 0; i < cat_filters.length && b; i++) {
      var re = new RegExp('^'+cat_filters[i]+'$',"im");
      b = only_class(node, '.category', re);
    }
    for(var i = 0; i < suite_filters.length && b; i++) {
      var re = new RegExp('^'+suite_filters[i]+'$',"im");
      b = only_class(node, '.suite', re);
    }
    return b;
  }

  var data_root = document.getElementById('data');
  while(data_root.firstChild) {
    data_root.removeChild(data_root.firstChild);
  }
  for (var i in data) {
    if (filter(data[i])) {
      data_root.appendChild(data[i]);
    }
  }  
}

function sort_childs(o) {
  var tmp = [];
  for (var i in o.childNodes) {
    var node = o.childNodes[i];
    if (node.tagName === 'DIV' || node.tagName === 'SPAN')
      tmp.push(node);
  }
  tmp.sort(function(a,b) {
    return a.innerHTML.localeCompare(b.innerHTML)
  });
  for (var i in tmp) {
    o.removeChild(tmp[i]);
    o.appendChild(tmp[i]);
  }
}

function move(span,origin,destination) {
  var origin = document.getElementById(origin);
  var destination = document.getElementById(destination);

  if (origin.contains(span) ){
    origin.removeChild(span);
    destination.appendChild(span);
    sort_childs(destination);
  } else {
    destination.removeChild(span);
    origin.appendChild(span);
    sort_childs(origin);
  }
  update_filter();
}

function sort_unique(arr) {
    arr = arr.sort(function (a, b) { return a.localeCompare(b); });
    var ret = [arr[0]];
    for (var i = 1; i < arr.length; i++) {
        if (arr[i-1] !== arr[i]) {
            ret.push(arr[i]);
        }
    }
    return ret;
}
