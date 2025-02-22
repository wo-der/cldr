local n = { };
local ci = { };
local ci_mt = { };

local ld = require(script.Parent.Locale);
local Support = require(script.Parent.Support);
local BigInteger = Support.BigInteger;
local Decimal = Support.Decimal;

local function _literal(str)
	return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%0");
end;

function ci_mt.__newindex(self, index, value)
	error(index .. " cannot be assigned to");
end;

function ci.new(displayName, symbol, currency_format)
	local self = displayName or 'XDR';
	if type(self) == 'string' then
		self = { ['displayName'] = self; ['other'] = self; };
	end;
	if not self.other then
		self.other = self.displayName;
	end
	self.symbol = symbol or '¤';
	if type(self.symbol) == 'string' then
		self.symbol = { ['symbol'] = self.symbol; };
	end;
	self.currencyFormat = currency_format;
	return setmetatable(self, ci_mt);
end;

local function _format_int(value, pattern, locale, ignore_minimum_grouping_digit)
	local ret = '';
	local gsize = { };
	for gs in pattern:gmatch(",([0#]*)") do
		table.insert(gsize, 1, #gs);
	end;
	local _, min = pattern:gsub('0', '0');
	if #value < min then
		value = ('0'):rep(min - #value) .. value;
	end;
	local i = 1;
	local sym = locale.numbers.latn.symbols.group;
	local gs = gsize[i] or 0;
	if #value < (gs + (ignore_minimum_grouping_digit and 1 or locale.numbers.minimumGroupingDigits)) then
		return value;
	end;
	while #value > gs and gs > 0 do
		ret = sym .. value:sub(-gs) .. ret;
		value = value:sub(1, -gs - 1);
		if gsize[i + 1] then
			i = i + 1;
			gs = gsize[i];
		end;
	end;
	return value .. ret;
end;

local function _format_frac(value, pattern, locale)
	local _, min = pattern:gsub('0', '0');
	local max = #pattern;
	if #value < min then
		value = value .. ('0'):rep(min - #value);
	end;
	if max == 0 or (min == 0 and value:gsub('0', '') == '') then
		return '';
	end;
	while #value > min and value:sub(-1) == '0' do
		value = value:sub(1, -2);
	end;
	return locale.numbers.latn.symbols.decimal .. _format_int(value:reverse(), pattern:reverse(), locale):reverse();
end;

local function _format_scientific(value, pattern, locale)
	local _, min = pattern:gsub('0', '0');
	if #value < min then
		value = value .. ('0'):rep(min - #value);
	end;
	while #value > min and value:sub(1, 1) == '0' do
		value = value:sub(2);
	end;
	if value == '' then
		return '';
	end;
	return locale.numbers.latn.symbols.exponential .. value;
end;

local function _parse(locale, pattern, value, decimal_quantization, ignore_minimum_grouping_digit, currency, currency_digits)
	value = tostring(value);
	pattern = pattern;

	decimal_quantization = decimal_quantization == nil or decimal_quantization;
	currency_digits = currency_digits == nil or currency_digits;

	local is_p = pattern:gsub("'[^']+'", ''):match('%%');
	if is_p then
		value = tostring(Decimal.new(value) * 100);
	else
		is_p = pattern:gsub("'[^']+'", ''):match('‰');

		if is_p then
			value = tostring(Decimal.new(value) * 1_000);
		end;
	end;

	if currency then

	end;

	local abs_value, is_neg = value:gsub("^-", '');
	is_neg = (is_neg == 1);

	if is_neg and not pattern:gsub('', ''):match(';') then
		pattern = pattern .. ';-' .. pattern;
	end;

	local position_neg = false;
	local ret = { [true] = ""; [false] = ""; };
	local i = 1;
	repeat
		local c = pattern:sub(i, i);
		local ri = i + 1;
		local r = '';
		if c == ';' then
			position_neg = true;
		elseif c:match("[#0,.E]") then
			ri = (pattern:find("[^#0,.E]", i)) or #pattern + 1;
			local rp = pattern:sub(i, ri - 1);

			if currency_digits and currency then
				if currency.currencyFormat == 1 then
					rp = rp:gsub("[.]([#0]+)", '');
				else
					rp = currency.currencyFormat or rp;
				end;
			end;
			local int_p, frac_p, e_p = rp:match("([^.E]*)[.]?([^E]*)E?(.*)");
			if decimal_quantization then
				if abs_value:gsub('e', '') == abs_value then
					abs_value = tostring(Decimal.new(abs_value):Round(#frac_p));
				else
					abs_value = ("%.0" .. #frac_p .. "f"):format(abs_value);
				end;
			end;
			if e_p ~= '' then
				if decimal_quantization then
					abs_value = ("%.0" .. #frac_p .. "e"):format(abs_value);
				else
					abs_value = ("%e"):format(abs_value);
				end;
			end;
			local int_v, frac_v, e_v = abs_value:match("(%d*)[.]?(%d*)e?+?(%d*)");

			r = _format_int(int_v, int_p, locale, ignore_minimum_grouping_digit) .. _format_frac(frac_v, frac_p, locale) .. _format_scientific(e_v, e_p, locale);
		elseif c == '\'' then
			ri = ((pattern:find('\'', i + 1)) or #pattern) + 1;
			r = pattern:sub(i + 1, ri - 2);
			if r == '' then r = '\''; end;
		else
			ri = (pattern:find("['#0,.;E]", i + 1)) or #pattern + 1;
			r = pattern:sub(i, ri - 1);

			if currency then
				r = r:gsub('¤¤¤¤', _literal(currency.symbol.narrow or currency.symbol.symbol));
				r = r:gsub('¤¤¤', _literal(currency.displayName[locale.numbers.pluralForm(value)] or currency.displayName.other or currency.symbol.symbol));
				r = r:gsub('¤¤', _literal(currency.symbol.international or currency.symbol.ISO or currency.symbol.symbol));
				r = r:gsub('¤', _literal(currency.symbol.symbol));
			end;
			r = r:gsub('%%', _literal(locale.numbers.latn.symbols.percentSign));
			r = r:gsub('-', _literal(locale.numbers.latn.symbols.minusSign));
			r = r:gsub("‰", locale.numbers.latn.symbols.perMille);
		end;
		ret[position_neg] = ret[position_neg] .. r;
		i = ri;
	until c == '' or not i;
	return ret[is_neg];
end;

function n.FormatCustom(locale, value, format, decimal_quantization, ignore_minimum_grouping_digit)
	locale = ld.Parse(locale);
	return _parse(locale, format, value, decimal_quantization, ignore_minimum_grouping_digit);
end;

function n.FormatDecimal(locale, value, decimal_quantization, ignore_minimum_grouping_digit)
	return n.FormatCustom(locale, value, locale.numbers.latn.decimalFormats.format, decimal_quantization, ignore_minimum_grouping_digit);
end;

function n.FormatScientific(locale, value, decimal_quantization, ignore_minimum_grouping_digit)
	return n.FormatCustom(locale, value, locale.numbers.latn.scientificFormats.format, decimal_quantization, ignore_minimum_grouping_digit);
end;

function n.FormatPercent(locale, value, decimal_quantization, ignore_minimum_grouping_digit)
	return n.FormatCustom(locale, value, locale.numbers.latn.percentFormats.format, decimal_quantization, ignore_minimum_grouping_digit);
end;

function n.FormatCurrency(locale, value, currency, format, currency_digits, decimal_quantization, ignore_minimum_grouping_digit)
	locale = ld.Parse(locale);
	format = locale.numbers.latn.currencyFormats.format[format or 'standard'] or format;
	return _parse(locale, format, value, decimal_quantization, ignore_minimum_grouping_digit, currency, currency_digits);
end;
n.CurrencyInfo = ci;

local function _parse_compact(locale, value, format, decimal_places, ignore_minimum_grouping_digit, currency, currency_digits)
	decimal_places = type(decimal_places) == 'table' and decimal_places or { decimal_places or 0 };
	local v_len = #tostring(value);
	local r_format = format[v_len] or format[#format];
	r_format = r_format.other or r_format;
	if r_format == '' or r_format == '0' then
		if currency then
			return n.FormatCurrency(locale, value, currency, 'standard', currency_digits, true, ignore_minimum_grouping_digit);
		else
			return n.FormatDecimal(locale, value, true, ignore_minimum_grouping_digit);
		end;
	end;
	local _, len = r_format:gsub('0', '0');
	len = len + math.max(v_len - #format, 0);
	local dp = decimal_places[len] or decimal_places[#decimal_places];
	local r_value;
	if type(value) == 'number' then
		r_value = math.floor((value / (10 ^ math.max(v_len - len, 0))) * (10 ^ dp)) / (10 ^ dp);
	else
		r_value = (value / (BigInteger.new(10) ^ (v_len - len))):Floor(dp);
	end;
	r_format = (format[v_len] or format[#format])[locale.numbers.pluralForm(r_value)] or r_format;
	r_format = (r_format:gsub('0+', ('0'):rep(math.max(v_len - #format, 0)) .. ',%1.' .. ('#'):rep(dp)));
	return _parse(locale, r_format, r_value, true, ignore_minimum_grouping_digit, currency, false);
end;

function n.FormatCompactDecimal(locale, value, format, decimal_places, imd)
	format = locale.numbers.latn.decimalFormats[format or 'short'] or format;
	return _parse_compact(locale, value, format, decimal_places, imd);
end;

function n.FormatCompactCurrency(locale, value, currency, currency_digits, format, decimal_places, imd)
	format = locale.numbers.latn.currencyFormats[format or 'short'] or format;
	return _parse_compact(locale, value, format, decimal_places, imd, currency, currency_digits);
end;

local function _getstr(locale, str, strict)
	local r = strict and str or str:gsub(' ', ' ');
	local gsym = locale.numbers.latn.symbols.group
	gsym = strict and gsym or gsym:gsub(' ', ' ');
	r = r:gsub(_literal(gsym), '');
	if locale.numbers.latn.symbols.decimal ~= '.' then
		-- Nice try :P
		r = r:gsub('[.]', ',');
	end;
	r = r:gsub(_literal(locale.numbers.latn.symbols.decimal), '.');
	if strict then
		if n.FormatDecimal(locale, r, false) == r then
			return r;
		else
			return nil;
		end;
	else
		return r;
	end;
end;

function n.ParseFloat(locale, str, strict)
	return tonumber(_getstr(locale, str, strict));
end;

function n.ParseDecimal(locale, str, strict)
	return Decimal.new(_getstr(locale, str, strict));
end;

return n;