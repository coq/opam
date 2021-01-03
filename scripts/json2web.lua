#!/usr/bin/lua5.1

function add_uniq(set, e)
	if e and not(set[e]) then
    set[e]=true
		set[#set+1]=e
	end
end

require "json"

templ=arg[1] or error "1st argument: the template file"
data =arg[2] or error "2st argument: the json file"

function scan_version(info, pkg)
  local versions = info.versions or {}
  add_uniq(versions, pkg.version)
  info.versions = versions

  local suites = info.suites or {}
  add_uniq(suites, pkg.suite)
  info.suites = suites

  local dates = info.dates or {}
  add_uniq(dates, pkg.date)
  info.dates = dates

  local keywords = info.keywords or {}
  for _, k in ipairs(pkg.keywords) do add_uniq(keywords, k) end
  info.keywords = keywords

  local categories = info.categories or {}
  for _, c in ipairs(pkg.categories) do add_uniq(categories, c) end
  info.categories = categories

  local authors = info.authors or {}
  for _, a in ipairs(pkg.authors) do add_uniq(authors, a) end
  info.authors = authors

  info.homepage = info.homepage or pkg.homepage
  info.description = info.description or pkg.description
end

function plural(s,n,...)
	if n >= 2 then return string.format(s,"s",...)
	else return string.format(s,"",...) end
end
function pluraly(s,n,...)
	if n >= 2 then return string.format(s,"ies",...)
	else return string.format(s,"y",...) end
end

function print_pkg(name,info,print)
	print [[<tr class="package"><td>]]
	if info.homepage ~= "" then print(('<a href="%s">'):format(info.homepage or "#")) end
	print (([[<h3 class="name">%s</h3>]]):format(name))
	if info.homepage ~= "" then print "</a>" end
	print (([[<p class="description">%s</p>]]):format(info.description))
	print [[<div class="metadata">]]
	if #info.authors > 0 then
	  print(plural('<div class="authors">author%s: ',#info.authors))
	  	for _,k in ipairs(info.authors) do
	  		print (([[<span class="author">%s</span>]]):format(k))
	  	end
	  print [[</div>]]
	end
	if #info.dates > 0 then
	  print [[<div class="dates">date: ]]
	  	for _,k in ipairs(info.dates) do
	  		print (([[<span class="date">%s</span>]]):format(k))
	  	end
	  print [[</div>]]
	end
	if #info.categories > 0 then
	  print(pluraly('<div class="categories">categor%s: ',#info.categories))
	  	for _,k in ipairs(info.categories) do
	  		print (([[<span class="category">%s</span>]]):format(k))
	  	end
	  print [[</div>]]
	end
	if #info.keywords > 0 then
	  print(plural('<div class="keywords">keyword%s: ',#info.keywords))
	  	for _,k in ipairs(info.keywords) do
	  		print (([[<span class="keyword">%s</span>]]):format(k))
	  	end
	  print [[</div>]]
	end
	print(plural('<div class="versions">version%s: ',#info.versions))
	for _,k in ipairs(info.versions) do
	 	print (([[<span class="version">%s</span>]]):format(k))
	end
	print [[</div>]]
	print(plural('<div class="suites">suite%s: ',#info.suites))
	for _,k in ipairs(info.suites) do
	 	print (([[<span class="suite">%s</span>]]):format(k))
	end
	print [[</div>]]
	print [[</div>]]
	print "</td></tr>\n"
end

template = io.open(templ):read('*a')
packages = json.decode(io.open(data,'r'):read('*a'), {others = {null = false}})
output_fname = templ:gsub('%.in$','')
assert(template ~= output_fname, "template not ending in .in")
--print("Generating "..output_fname)
output = io.open(output_fname,'w')
output:write((template:gsub('@@PACKAGES@@', function()
	local t = {}
	local function print(s) t[#t+1] = s end
  for _, p in ipairs(packages) do
    local info = {}
    for _, v in ipairs(p[2].versions) do
      scan_version(info, v)
    end
    print_pkg(p[1], info, print)
  end
	return table.concat(t)
end)))

-- vim:set ts=2:
