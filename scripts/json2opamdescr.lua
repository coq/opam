#!/usr/bin/lua5.1

require "json"

t = json.decode(io.open(arg[1],'r'):read('*a'))

print(((t.Title .. "\n\n" .. t.Description):gsub(' *\n[ \t][ \t]*','\n'):gsub('[ \t][ \t]*',' '):gsub('[\n ]*$','')))
