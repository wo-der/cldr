local t = { };
local num = require(script.Parent.Numbers);
local ld = require(script.Parent.LocaleData);

function t.FormatPluralizedText(locale, data, value, format)
	local d = data[locale.numbers.pluralForm(value)] or data.other;
	return (d:gsub('{0}', num.FormatDecimal(locale, value, format, false)));
end;

function t.FormatText(text, ...)
	local arg = { ... };
	return (text:gsub("{(%d+)}", function(n) return arg[tonumber(n) + 1] or '{' .. n .. '}' end));
end;

t.LoadTable = ld.LoadTable;
t.LoadFolder = ld.LoadFolder;
return t;