do local ts = { }; local mt = { };

local p  = script.Parent;
local pf = require(p.PrivateFunction);
--
local floor = math.floor;

local div = function(a,b) return floor(a / b); end;
local divmod = function(a, b) return div(a, b), a % b; end;
--

function mt.__index(self, index)
	local _raw = rawget(self, '_raw');
	local td, h, m, s, ms = pf.from_raw(_raw);
	local prop =
	{
		TotalDays = _raw / 86400_000; 
		TotalHours = _raw / 3600_000; TotalMinutes = _raw / 60_000;
		TotalSeconds = _raw / 1_000; TotalMilliseconds = _raw;
		Days = td; Hours = h;
		Minutes = m; Seconds = s; Milliseconds = ms;
	};
	if prop[index] then
		return prop[index];
	elseif ts[index] and index ~= 'new' then
		return ts[index];
	else
		error(index .. " is not a valid member of TimeSpan");
	end;
end;

function mt.__add(a, b) return ts.new(pf.to_raw(a) + pf.to_raw(b)); end;
function mt.__sub(a, b) return ts.new(pf.to_raw(a) - pf.to_raw(b)); end;
function mt.__mul(a, b) return ts.new(pf.to_raw(a) * b); end;
function mt.__div(a, b) return ts.new(pf.to_raw(a) / b); end;
function mt.__unm(a) return ts.new(pf.to_raw(a) * -1) end;

function mt.__lt(a, b) return pf.to_raw(a) < pf.to_raw(b); end;
function mt.__le(a, b) return pf.to_raw(a) <= pf.to_raw(b); end;
function mt.__eq(a, b) return pf.to_raw(a) == pf.to_raw(b); end;

function mt.__tostring(self)
	return ("%d,%02d:%02d:%02d%s"):format(self.Days, self.Hours, self.Minutes, self.Seconds, self.Milliseconds == 0 and '' or (",%02d"):format(self.Milliseconds));
end;

mt.__newindex = pf.READONLY;
mt.__metatable = pf.METATABLE;

function ts.new(days, hours, minutes, seconds, millisecond)
	if not (hours or minutes or seconds or millisecond) then
		millisecond = days;
		days = 0; hours = 0; minutes = 0; seconds = 0;
	elseif not (seconds or millisecond) then
		seconds = minutes; minutes = hours; hours = days;
		days = 0; millisecond = 0;
	elseif not millisecond then
		millisecond = 0;
	end;
	return setmetatable({_raw = pf.to_raw(days, hours, minutes, seconds, millisecond)}, mt);
end;

function ts.FromMilliseconds(value)
	return ts.new(value);
end;

function ts.FromSeconds(value)
	return ts.new(0, 0, value);
end;

function ts.FromMinutes(value)
	return ts.new(0, value, 0);
end;

function ts.FromHours(value)
	return ts.new(value, 0, 0);
end;

function ts.FromDays(value)
	return ts.new(value, 0, 0, 0);
end;

local _TIMESPANPATTERN = "[dhmsf':,;]";
function ts:Format(format, tsfi)
	if tsfi then
		local specifier =
		{
			dhms = tsfi.DayHourMinuteSecondPattern; hms = tsfi.HourMinuteSecondPattern;
			hmsf = tsfi.HourMinuteSecondMillisecondPattern; ms = tsfi.MinuteSecondPattern;
			msf = tsfi.MinuteSecondMillisecondPattern; sf = tsfi.SecondMillisecondPattern;
			
			adhms = tsfi.AbbreviatedDayHourMinuteSecondPattern; ahms = tsfi.AbbreviatedHourMinuteSecondPattern;
			ahmsf = tsfi.AbbreviatedHourMinuteSecondMillisecondPattern; af = tsfi.AbbreviatedMinuteSecondPattern;
			amsf = tsfi.AbbreviatedMinuteSecondMillisecondPattern; asf = tsfi.AbbreviatedSecondMillisecondPattern;

			fdhms = tsfi.FullDayHourMinuteSecondPattern; fhms = tsfi.FullHourMinuteSecondPattern;
			fhmsf = tsfi.FullHourMinuteSecondMillisecondPattern; fms = tsfi.FullMinuteSecondPattern;
			fmsf = tsfi.FullMinuteSecondMillisecondPattern; fsf = tsfi.FullSecondMillisecondPattern;
		};
		format = specifier[format] or format;
	else
		tsfi = { };
	end;
	local is_neg = self < ts.new(0);
	if is_neg and not format:gsub("'[^']+'", ''):match(';') then
		format = format .. ';-' .. format;
	end;
	local prop = 
	{
		d = self.Days; dd = ('%02d'):format(self.Days); ddd = ('%03d'):format(self.Days); dddd = ('%04d'):format(self.Days);
		ddddd = ('%05d'):format(self.Days); dddddd = ('%06d'):format(self.Days); ddddddd = ('%07d'):format(self.Days); dddddddd = ('%08d'):format(self.Days);
		h = self.Hours; hh = ('%02d'):format(self.Hours);
		m = self.Minutes; mm = ('%02d'):format(self.Minutes);
		s = self.Seconds; ss = ('%02d'):format(self.Seconds);
		f = self.Milliseconds % 10; ff = ('%02d'):format(self.Milliseconds % 100); fff = ('%03d'):format(self.Milliseconds); ffff = self.Milliseconds;
	};
	local position_neg = false;
	local ret = { [true] = ""; [false] = ""; };
	local i = 1;
	repeat
		local c = format:sub(i, i);
		local ri = i + 1;
		local r = '';
		if c == '\'' then
			ri = ((format:find("'", i + 1)) or #format) + 1;
			r = format:sub(i + 1, ri - 2);
			r = r == '' and '\'' or r;
		elseif c == '%' then
			r = format:sub(ri, ri);
			if r:match(_TIMESPANPATTERN) then
				r = prop[r];
				ri = ri + 1;
			else
				r = '%';
			end;
		elseif c == ';' then
			position_neg = true;
		elseif c == ':' then
			r = tsfi.TimeSeparator or ':';
		elseif c == ',' then
			r = tsfi.MillisecondSeparator or ',';
		elseif c:match(_TIMESPANPATTERN) then
			_, ri = format:find(c .. '+', i);
			r = format:sub(i, ri);
			r = prop[r];
			r = r or '';
			
			ri = (ri or #format) + 1;
		else
			ri = (format:find(_TIMESPANPATTERN, i)) or #format + 1;
			r = format:sub(i, ri - 1);
		end;
		i = ri;
		ret[position_neg] = ret[position_neg] .. r;
	until c ==  '' or not i;
	return ret[is_neg];
end;

return ts;
end;