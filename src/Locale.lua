local l = {};
local mt = {};
local ld = require(script.Parent.LocaleData);
local plural = require(script.Parent.Plural);
local ls = game.LocalizationService;

local function _case_fix(str, field)
	if not str then
		return;
	end
	if field == 0 then
		return str:lower()
	elseif field == 1 then
		return str:gsub("^[a-z]", string.upper);
	elseif field == 2 then
		return str:upper();
	else
		return str;
	end;
end;

local function _insert_sep(str, field, sep)
    sep = sep or '_';
	if (str or '') == '' then
		return '';
	end
	return sep .. _case_fix(str, field);
end;

local function _parse_locale(identifier, sep)
	sep = sep or '_';

	-- This is likey the charset/encoding, which we don't care about
	identifier = identifier:gsub("[.].+", '');
	-- This is a locale modifier such as @euro, which we don't care about either
	identifier = identifier:gsub("@.+", '');

	local parts = { };
	for part in identifier:gmatch("[^" .. sep .. "]+") do
		table.insert(parts, part);
	end;

	local language = _case_fix(table.remove(parts, 1), 0);
	if language:match("%A") then
		error("expected only letters, got " .. language)
	end;

	local sscript, territory, variant;
	if #parts > 0 then
		if #parts[1] == 4 and not parts[1]:match('%A') then
			sscript = _case_fix(table.remove(parts, 1), 1);
		end;
	end;

	if #parts > 0 then
		if #parts[1] == 2 and not parts[1]:match('%A') then
			territory = _case_fix(table.remove(parts, 1), 2);
		elseif #parts[1] == 3 and not parts[1]:match('%D') then
			territory = table.remove(parts, 1);
		end;
	end;

	if #parts > 0 then
		if #parts[1] == 4 and parts[1]:sub(1, 1).isdigit() or #parts[1] >= 5 and parts[1]:sub(1, 1).isalpha() then
			variant = table.remove(parts);
		end;
	end;

	if #parts > 0 then
		error(identifier .. ' is not a valid locale identifier');
	end;
	return language, sscript, territory, variant;
end;

function mt.__index(self, index)
	local d = rawget(self, '_data');
	if d[index] then
		return d[index];
	elseif rawget(l, index) and index ~= 'new' then
		return rawget(l, index);
	else
		return 	error(index .. " is not a valid member of Locale");
	end;
end;

function mt.__tostring(self)
	return self.language .. _insert_sep(self.territory, 1) .. _insert_sep(self.script, 2) .. _insert_sep(self.variant or '', 3);
end;

function mt.__newindex(self, index, value)
	error(index .. " cannot be assigned to");
end;

mt.__metatable = "The metatable is locked";

function l.new(language, territory, sscript, variant)
	if type(language) == 'table' then territory = language.territory; sscript = language.sscript or language.script; variant = language.variant; language = language.language; end;
	local identifier = language .. _insert_sep(sscript, 1) .. _insert_sep(territory, 2) .. _insert_sep(variant or '', 3);

	if not ld.Exists(identifier) then
		error("Unknown locale: " .. identifier)
	end;
	local self = { };
	self._data = ld.Load(identifier);
	self.language = language;
	self.territory = _case_fix(territory, 2) or '';
	self.script = _case_fix(sscript, 1) or '';
	self.variant = variant or '';

	self._data.numbers.pluralForm = plural.PluralRule(self._data.numbers.pluralForm or { });
	self._data.numbers.ordinalForm = plural.PluralRule(self._data.numbers.ordinalForm or { });
	return setmetatable(self, mt);
end;

function l.Parse(identifier, sep)
	if type(identifier) == 'table' then
		return identifier;
	end;
	local language, sscript, territory, variant = _parse_locale(identifier, sep);
	if territory == 'ZZ' then territory = nil; end;
	if sscript == 'Zzzz' then sscript = nil; end;

	if territory == 'TW' and not sscript then sscript = "Hant"; end;
	if territory == 'CN' and not sscript then sscript = "Hans"; end;
	return l.new(language, territory, sscript, variant);
end;

function l.ToLocaleIdentifier(tup, sep)
	if #tup == 2 then
		return tup[1] .. _insert_sep(tup[2], 2, sep);
	else
		return tup[1] .. _insert_sep(tup[2], 1, sep) .. _insert_sep(tup[3], 2, sep) .. _insert_sep(tup[4] or '', 3, sep);
	end;
end;

function l.RobloxLocaleId()
	local success, ret = pcall(
		function()
			return l.Parse(ls.RobloxLocaleId, '-');
		end
	);
	if success then
		return ret;
	else
		return l.new('root');
	end;
end;

function l.SystemLocaleId()
	local success, ret = pcall(
		function()
			return l.Parse(ls.SystemLocaleId, '-');
		end
	);
	if success then
		return ret;
	else
		return l.new('root');
	end;
end;

l.Root = l.new('root');

function l.GetDisplayName(self, locale)
	locale = l.Parse(locale or self);
	local ldn = locale.localeDisplayNames;
	local ldn_t = ldn.territories[self.identity.territory];
	local ldn_s = ldn.scripts[self.identity.script];
	if ldn_t or ldn_s then
		local r = '';
		if ldn_t and ldn_s then
			r = ldn.localeDisplayPattern.localeSeparator:gsub('{0}', ldn_s):gsub('{1}', ldn_t)
		else
			r = ldn_t or ldn_s;
		end;
		return (ldn.localeDisplayPattern.localePattern:gsub('{0}', ldn.languages[self.identity.language]):gsub('{1}', r));
	else
		return ldn.languages[self.identity.language];
	end;
end;

return l;