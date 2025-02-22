local d = {};
--local DateTime = require(script.Parent.Support).DateTime.DateTime;
local num = require(script.Parent.Numbers);
local floor = math.floor;
local ceil = math.ceil;
local abs = math.abs;

local _PATTERN_CHAR_ORDER = "GyYuUQqMLlwWdDFgEecabBChHKkjJmsSAzZOvVXx";

local function _get_prop(dt, locale)
	local d = locale.dates.calendars.gregorian;
	local _sd = dt.TimeOfDay.TotalSeconds;
	local _quarter = ceil(dt.Month / 3);
	local _cdp_a = dt.Hour < 12 and 'am' or 'pm';
	local _cdp_b = (_sd == 0 and 'midnight') or (_sd < 43200 and 'am') or (dt.Hour == 43200 and 'noon') or 'pm';
	local _cdp_B = (dt.Hour < 6 and 'night1') or (dt.Hour < 12 and 'morning1') or (dt.Hour < 18 and 'afternoon1') or 'evening1';
	local _dpname_a_f_a = d.dayPeriods.format.abbreviated[_cdp_a];
	local _dpname_a_f_b = d.dayPeriods.format.abbreviated[_cdp_b];
	local _dpname_a_f_B = d.dayPeriods.format.abbreviated[_cdp_B];
	return 
	{
		G = d.eras.Abbr['1']; GG = d.eras.Abbr['1']; GGG = d.eras.Abbr['1']; GGGG = d.eras.Names['1']; GGGGG = d.eras.Narrow['1'];
		y = dt.Year; yy = ('%02d'):format(dt.Year % 100); yyy = ('%03d'):format(dt.Year); yyyy = ('%04d'):format(dt.Year); yyyyy = ('%05d'):format(dt.Year); yyyyyy = ('%06d'):format(dt.Year);
		M = dt.Month; MM = ('%02d'):format(dt.Month); MMM = d.months.format.abbreviated[dt.Month]; MMMM = d.months.format.wide[dt.Month]; MMMMM = d.months.format.narrow[dt.Month];
		L = dt.Month; LL = ('%02d'):format(dt.Month); LLL = d.months['stand-alone'].abbreviated[dt.Month]; LLLL = d.months['stand-alone'].wide[dt.Month]; LLLLL = d.months['stand-alone'].narrow[dt.Month];
		Q = _quarter; QQ = ('%02d'):format(_quarter); QQQ = d.quarters.format.abbreviated[_quarter]; QQQQ = d.quarters.format.wide[_quarter]; MQQQQ = d.quarters.format.narrow[_quarter];
		d = dt.Day; dd = ('%02d'):format(dt.Day);
		E = d.days.format.abbreviated[dt.Weekday]; EE = d.days.format.abbreviated[dt.Weekday]; EEE = d.days.format.abbreviated[dt.Weekday]; EEEE = d.days.format.wide[dt.Weekday]; EEEEE = d.days.format.narrow[dt.Weekday]; EEEEEE = (d.days.format.short or d.days.format.narrow)[dt.Weekday];
		a = _dpname_a_f_a; aa = _dpname_a_f_a; aaa = _dpname_a_f_a; aaaa = d.dayPeriods.format.wide[_cdp_a]; aaaaa = d.dayPeriods.format.narrow[_cdp_a];
		b = _dpname_a_f_b; bb = _dpname_a_f_b; bbb = _dpname_a_f_b; bbbb = d.dayPeriods.format.wide[_cdp_b]; bbbbb = d.dayPeriods.format.narrow[_cdp_b];
		B = _dpname_a_f_B; bb = _dpname_a_f_B; bbb = _dpname_a_f_B; bbbb = d.dayPeriods.format.wide[_cdp_B]; bbbbb = d.dayPeriods.format.narrow[_cdp_B];
		h = ((dt.Hour - 1) % 12) + 1; hh = ('%02d'):format(((dt.Hour - 1) % 12) + 1);
		H = dt.Hour; HH = ('%02d'):format(dt.Hour);
		m = dt.Minute; mm = ('%02d'):format(dt.Minute);
		s = dt.Second; ss = ('%02d'):format(dt.Second);
		z = "UTC"; zzzz = "UTC";
	};
end

local _DATEPATTERN = "[AaBbCcDdEeFGgHhJjKkLlMmOQqrSsUuVvWwXxYyZz']";
local function _prase_date(pattern, dt, dt2, locale)
	local prop = _get_prop(dt, locale);
	local prop2 = { };
	if dt2 then
		prop2 = _get_prop(dt2, locale);
	end;
	local has_set = {};
	local ret = '';
	local i = 1;
	repeat
		local c = pattern:sub(i, i);
		local ri = i + 1;
		local r = '';
		if c == '\'' then
			ri = ((pattern:find("'", i + 1)) or #pattern) + 1;
			r = pattern:sub(i + 1, ri - 2);
			r = r == '' and '\'' or r;
		elseif c:match(_DATEPATTERN) then
			_, ri = pattern:find(c .. '+', i);
			r = pattern:sub(i, ri)
			if has_set[r] and dt2 then
				r = prop2[r];
			else
				has_set[r] = true;
				r = prop[r];
			end;
			r = r or '';

			ri = (ri or #pattern) + 1;
		else
			ri = (pattern:find(_DATEPATTERN, i)) or #pattern + 1;
			r = pattern:sub(i, ri - 1);
		end;
		i = ri;
		ret = ret .. r;
	until c ==  '' or not i;
	return ret;
end;

function d.FormatDateTime(locale, dt, format)
	local comb = locale.dates.calendars.gregorian.dateTimeFormats;
	if comb[format] then
		format = (comb[format]:gsub("{0}", locale.dates.calendars.gregorian.timeFormats[format])):gsub("{1}", locale.dates.calendars.gregorian.dateFormats[format]);
	else
		format = format or (comb["medium"]:gsub("{0}", locale.dates.calendars.gregorian.timeFormats["medium"])):gsub("{1}", locale.dates.calendars.gregorian.dateFormats["medium"]);
	end;
	return _prase_date(format, dt, nil, locale);
end;

function d.FormatDate(locale, dt, format)
	format = locale.dates.calendars.gregorian.dateFormats[format] or format or locale.dates.calendars.gregorian.dateFormats['medium'];
	return d.FormatDateTime(locale, dt, format);
end;

function d.FormatTime(locale, dt, format)
	format = locale.dates.calendars.gregorian.timeFormats[format] or format or locale.dates.calendars.gregorian.timeFormats['medium'];
	return d.FormatDateTime(locale, dt, format);
end;

local DURATION_ORDER = { "year", "month", "week", "day", "hour", "minute", "second", "millisecond" };
function d.FormatTimeSpan(locale, ts, granularity, threshold, add_direction, format)
	local ret;
	granularity = granularity or 'second';
	threshold = threshold or .85;
	local total_count =
	{
		year = ts.TotalMilliseconds / (31536000_000 * threshold);
		month = ts.TotalMilliseconds / (2620800_000 * threshold);
		week = ts.TotalMilliseconds / (604800_000 * threshold);
		day = ts.TotalMilliseconds / (86400_000 * threshold);
		hour = ts.TotalMilliseconds / (3600_000 * threshold);
		minute = ts.TotalMilliseconds / (60_000 * threshold);
		second = ts.TotalMilliseconds / (1000 * threshold);
		millisecond = ts.TotalMilliseconds;
	};
	local du_selected = granularity;
	local v = total_count[granularity];
	for _, du in next, DURATION_ORDER do
		if abs(total_count[du]) >= threshold then
			du_selected = du;
			v = total_count[du];
			break;
		end;
		if du == granularity then
			break;
		end;
	end;
	v = v < 0 and ceil(v) or floor(v);
	if add_direction then
		if (format or 'long') == 'long' then
			format = '';
		else
			format = '-' .. format;
		end;
		ret = locale.dates.fields[du_selected .. format][v < 0 and 'past' or 'future'][locale.numbers.pluralForm(v)];
	else
		ret = locale.units[format or 'long']["duration-" .. du_selected][locale.numbers.pluralForm(v)];
	end;
	return (ret:gsub('{0}', num.FormatDecimal(locale, abs(v), nil, true)));
end;

function d.FormatFlexible(locale, dt, format)
	format = locale.dates.calendars.gregorian.dateTimeFormats.availableFormats.dateFormatItem[format];
	if format then
		return _prase_date(format, dt, nil, locale);
	end;
	return nil;
end;

local function _format_fallback(locale, start, eend, format)
	local s = d.FormatFlexible(locale, start, format);
	local e = d.FormatFlexible(locale, eend, format);
	
	if s == e then
		return s;
	end
	return (locale.dates.calendars.gregorian.dateTimeFormats.intervalFormats.intervalFormatFallback:gsub('{0}', s):gsub('{1}', e));
end;

function d.FormatInterval(locale, start, eend, format)
	format = format or 'yMd';
	if start == eend then
		return d.FormatFlexible(locale, start, format);
	end;
	local gd;
	for c in _PATTERN_CHAR_ORDER:gmatch('[' .. format .. ']') do
		if _get_prop(start, locale)[c] ~= _get_prop(eend, locale)[c] and not gd then
			gd = c;
			break;
		end;
	end;
	-- Prevetning error from indexing nil
	local r_format = (locale.dates.calendars.gregorian.dateTimeFormats.intervalFormats.intervalFormatItem[format] or { })[gd];
	if r_format then
		return _prase_date(r_format, start, eend, locale);
	else
		return _format_fallback(locale, start, eend, format);
	end;
end;

function d.ParseDateTime(locale, str, format, strict)
	local comb = locale.dates.calendars.gregorian.dateTimeFormat;
	local pattern = (comb["full"]:gsub("{0}", locale.StandardDateFormats["full"]):gsub("{1}", locale.StandardTimeFormats["full"]));
	
	local index = { };
	for i = 1, #_PATTERN_CHAR_ORDER do
		local c = _PATTERN_CHAR_ORDER:sub(i, i);
		local r = (pattern:find(c));
		if r then
			table.insert(index, {r, c});
		end;
	end;
	table.sort(index, function(a, b) return a[1] < b[1] end);

	local numbers = {};
	for i in str:gsub("(%D+)", " %1 "):gmatch("%w+") do
		table.insert(numbers, i);
	end;
	
	local indexes = {};
	local idx_m = 0;
	for idx, item in pairs(index) do
		local r = numbers[idx - idx_m];
		if item[2]:match('E') then
			idx_m = idx_m + 1;
		elseif tonumber(r) then
			indexes[item[2]] = r;
		else
			if item[2]:match('a') then
				if r == locale.dates.calendars.gregorian.dayPeriods.format.abbreviated.am then
					indexes[item[2]] = 0;
				elseif r == locale.dates.calendars.gregorian.dayPeriods.format.abbreviated.pm then
					indexes[item[2]] = 12;
				end;
			elseif item[2]:match('M') then
				for _, format_n in next, locale.MonthNames do
					for i, mn in next, format_n.format do
						if mn == r then
							indexes['M'] = i;
						end;
					end;
				end;
			end;
		end;
	end;
	
	local y, M, d = tonumber(indexes.y), tonumber(indexes.M), tonumber(indexes.d);
	local h, m, s = tonumber(indexes.H) or (indexes.a or 0) + (tonumber(indexes.h) % 12), tonumber(indexes.m), tonumber(indexes.s);
	return DateTime.new(y or DateTime.Now().Year, M or 1, d or 1, h, m, s);
end;

return d;