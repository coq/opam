#!/usr/bin/lua5.1

require "json"

t = json.decode(io.open(arg[1],'r'):read('*a'))

authors = {}

for name, data in pairs(t.Author) do
  authors[#authors+1] =
    ('"%s <%s>"'):format(name,data.Email or data.Homepage or "")
end

if #authors > 0 then
  print(string.format("authors: [ %s ]",table.concat(authors,' ')))
end

