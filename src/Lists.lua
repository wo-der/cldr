local l = {};
local num = require(script.Parent.Numbers);

function l.FormatList(locale, list, style)
	local s = locale.listPatterns[style] or locale.listPatterns['standard'];
	local ret = '';
	
	if #list == 1 then
		return list[1];
	elseif #list == 2 then
		return s['2']:gsub('{0}', list[1]):gsub('{1}', list[2]);
	else
		local ret = list[1];
		for i = 2, #list do
			ret = ((i == 2 and s.start) or (i == #list and s['end']) or s.middle):gsub('{0}', ret):gsub('{1}', list[i]);
		end;
		return ret;
	end;
end;

function l.FormatNumericalList(locale, list, include_end, format, dq)
	local s = locale.numbers.latn.symbols.list;
	local ret = '';
	for _, n in next, list do
		ret = ret .. num.FormatDecimal(locale, n, format, dq) .. s .. ' ';
	end;
	return include_end and ret or (ret:gsub('[' .. s .. '] $', '', 1));
end;

function l.ParseNumericalList(locale, str)
	local ret = {};
	for str_i in str:gmatch("[ ]?([^" .. locale.NumberSymbols.list .. "]+)") do
		table.insert(ret, num.ParseDecimal(locale, str_i));
	end;
	return ret;
end;

return l;