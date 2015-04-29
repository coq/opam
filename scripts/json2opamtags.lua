#!/usr/bin/lua5.1

require "json"

t = json.decode(io.open(arg[1],'r'):read('*a'))

tags = {}

for k,v in pairs(t.Keywords or {}) do
	tags[#tags+1] = string.format('"keyword:%s"',v:gsub('%.*$',''))
end
for k,v in pairs(t.Category or {}) do
	tags[#tags+1] = string.format('"category:%s"',v:gsub('%.*$',''))
end
if t.Date then tags[#tags+1] = string.format('"date:%s"',t.Date:gsub('[\n ]*$','')) end

if #tags > 0 then
	print(string.format("tags: [ %s ]", table.concat(tags," ")))
end
