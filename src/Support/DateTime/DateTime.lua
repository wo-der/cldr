do local dt = { }; local mt = { };

local p  = script.Parent;
local ts = require(p.TimeSpan);
local pf = require(p.PrivateFunction);

--
local floor = math.floor;
local min = math.min;

local div = function(a,b) return floor(a / b); end;
local divmod = function(a, b) return div(a, b), a % b; end;
--

function mt.__index(self, index)
	local _raw = rawget(self, '_raw');
	local td, h, n, s, ms = pf.from_raw(_raw);
	local y, m, d = pf.ord2ymd(td);
	local prop =
	{
		Year = y; Month = m; Day = d;
		Hour = h; Minute = n; Second = s;
		Millisecond = ms;
		Weekday = ((td - 1) % 7) + 1;
		Ordinal = pf.days_before_month(y, m) + d;
		TimeOfDay = ts.new(h, m, s);
	};
	if prop[index] then
		return prop[index];
	elseif dt[index] and index ~= 'new' then
		return dt[index];
	else
		error(index .. " is not a valid member of DateTime");
	end;
end;

function mt.__add(a, b)
	local r = pf.to_raw(a) + pf.to_raw(b);
	local d, h, n, s, ms = pf.from_raw(r);
	local y, m, d = pf.ord2ymd(d);
	return dt.new(y, m, d, h, n ,s);
end;

function mt.__sub(a, b)
	local r = pf.to_raw(a) - pf.to_raw(b);
	local success, _ = pcall(
		function()
			return b.TotalSeconds;
		end
	);
	if success then
		local d, h, n, s, ms = pf.from_raw(r);
		local y, m, d = pf.ord2ymd(d);
		return dt.new(y, m, d, h, n ,s);
	else
		return ts.new(r);
	end;
end;

function mt.__lt(a, b) return pf.to_raw(a) < pf.to_raw(b); end;
function mt.__le(a, b) return pf.to_raw(a) <= pf.to_raw(b); end;
function mt.__eq(a, b) return pf.to_raw(a) == pf.to_raw(b); end;

function mt.__tostring(self)
	return self:ISO8601();
end;

mt.__newindex = pf.READONLY;
mt.__metatable = pf.METATABLE;
--

function dt.new(year, month, day, hour, minute, second, millisecond)
	hour, minute, second, millisecond = hour or 0, minute or 0, second or 0, millisecond or 0;
	if year < pf.MINYEAR or year > pf.MAXYEAR or month < 1 or month > 12 or day < 1 or day > pf.days_in_month(year, month) then
		error("year, month, and day parameters describe an un-representable DateTime.");
	elseif hour < 0 or hour > 59 or minute < 0 or minute > 59 or second < 0 or second > 59 then
		error("hour, minute, and second parameters describe an un-representable DateTime.");
	elseif millisecond > 999 or millisecond < 0 then
		error("millisecond paramter describe an un-representable DateTime.")
	end;
	return setmetatable({_raw = pf.to_raw(year, month, day, hour, minute, second, millisecond)}, mt);
end;

function dt.FromEpoch(timestamp)
	return dt.new(1970, 1, 1) + ts.new(0, 0, timestamp);
end;

function dt.FromMillisecondsEpoch(timestamp)
	return dt.new(1970, 1, 1) + ts.new(timestamp);
end;

function dt.FromISO8601(format)
	return dt.new(format:match("(%d%d%d%d)-(%d%d)-(%d%d)T?(%d%d):(%d%d):(%d%d)Z?"));
end;

function dt.FromOsDate(osdate)
	return dt.new(osdate.year, osdate.month, osdate.day, osdate.hour, osdate.min, osdate.sec);
end;

function dt.Now()
	return dt.FromEpoch(floor(tick()));
end;

function dt.MillisecondsNow()
	return dt.FromMillisecondsEpoch(floor(tick() * 1000));
end;

function dt.UtcNow()
	return dt.FromEpoch(os.time());
end;

function dt.UtcMillisecondsNow()
	return dt.FromMillisecondsEpoch((os.time() * 1000) + floor((tick() * 1000) % 1000));
end;

function dt.Today()
	local n = dt.Now();
	return dt.new(n.Year, n.Month, n.Day);
end;

function dt.DaysInMonth(year, month)
	return pf.days_in_month(year, month);
end;

function dt.IsLeapYear(year)
	return pf.is_leap(year);
end;

function dt:AddMilliseconds(value)
	return self + ts.new(value);
end;

function dt:AddSeconds(value)
	return self + ts.new(0, 0, value);
end;

function dt:AddMinutes(value)
	return self + ts.new(0, value, 0);
end;

function dt:AddHours(value)
	return self + ts.new(value, 0, 0);
end;

function dt:AddDays(value)
	return self + ts.new(value, 0, 0, 0);
end;

function dt:AddMonths(value)
	local d, m, y = self.Day, self.Month + value, self.Year;
	y = y + div(m, 12);
	m = ((m - 1) % 12) + 1;
	d = min(pf.days_in_month(y, m),  d);
	return dt.new(y, m, d, self.Hour, self.Minute, self.Second);
end;

function dt:AddYears(value)
	local d, m, y = self.Day, self.Month, self.Year;
	y = y + value;
	d = min(pf.days_in_month(y, m), d);
	return dt.new(y, m, d, self.Hour, self.Minute, self.Second);
end;

function dt:ISO8601(sep)
	return ("%04d-%02d-%02d%s%02d:%02d:%02d%s"):format(self.Year, self.Month, self.Day, sep or ' ', self.Hour, self.Minute, self.Second, self.Millisecond == 0 and '' or (".%06d"):format(self.Millisecond));
end;

function dt:RFC2822()
	return ("%s, %02d %s %04d, %02d:%02d:%02d +0000"):format(pf.DAYNAMES[self.Weekday], self.Day, pf.MONTHNAMES[self.Month], self.Year, self.Hour, self.Minute, self.Second);
end;

function dt:ctime()
	return ("%s %s %2d %02d:%02d:%02d %04d"):format(pf.DAYNAMES[self.Weekday], pf.MONTHNAMES[self.Month], self.Day, self.Hour, self.Minute, self.Second, self.Year);
end;

function dt:Epoch()
	return (self - dt.new(1970, 1, 1)).TotalSeconds;
end;

function dt:EpochMilliseconds()
	return (self - dt.new(1970, 1, 1)).TotalMilliseconds;
end;

function dt:OsDate()
	return os.date('!*t', self:Epoch());
end;

local _DATEPATTERN = "[yMdEahHmsf':/]";
local _specifier =
{
	d = "y-MM-dd"; D = "EEEE, d MMMM y";
	f = "EEEE, d MMMM y HH:mm"; F = "EEEE, d MMMM y HH:mm:ss";
	g = "y-MM-dd HH:mm"; G = "y-MM-dd HH:mm:ss";
	m = "d MMMM"; M = "d MMMM";
	t = "HH:mm"; T = "HH:mm:ss";
	y = "MMMM y"; Y = "MMMM y";
};
local _names =
{
	mo = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" },
	wd = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" };
};
function dt:Format(format, dtfi)
	local specifier = _specifier;
	if dtfi then
		specifier =
		{
			d = dtfi.ShortDatePattern; D = dtfi.LongDatePattern;
			f = dtfi.LongDatePattern .. ' ' .. dtfi.ShortTimePattern; F = dtfi.FullDateTimePattern;
			g = dtfi.ShortDatePattern .. ' ' .. dtfi.ShortTimePattern; G = dtfi.ShortDatePattern .. ' ' .. dtfi.LongTimePattern;
			m = dtfi.MonthDayPattern; M = dtfi.MonthDayPattern;
			t = dtfi.ShortTimePattern; T = dtfi.ShortDatePattern;
			y = dtfi.YearMonthPattern; Y = dtfi.YearMonthPattern;
		};
	else
		dtfi = { };
	end;
	local names = { mo = dtfi.MonthNames or _names.mo; abmo = dtfi.AbbreviatedMonthNames or pf.MONTHNAMES; wd = dtfi.AbbreviatedMonthNames or _names.wd; abwd = dtfi.AbbreviatedDayNames or pf.DAYNAMES; dp = { [true] = pf.AMDesignator or 'AM'; [false] = pf.PMDesignator or 'PM' }; };
	format = specifier[format] or format;
	local prop = 
	{
		y = self.Year; yy = ('%02d'):format(self.Year % 100); yyy = ('%03d'):format(self.Year); yyyy = ('%04d'):format(self.Year); yyyyy = ('%05d'):format(self.Year); yyyyyy = ('%06d'):format(self.Year);
		M = self.Month; MM = ('%02d'):format(self.Month); MMM = names.abmo[self.Month]; MMMM = names.mo[self.Month];
		d = self.Day; dd = ('%02d'):format(self.Day);
		E = names.abwd[self.Weekday]; EE = names.abwd[self.Weekday]; EEE = names.abwd[self.Weekday]; EEEE = names.wd[self.Weekday];
		a = names.dp[self.Hour < 12]; aa = names.dp[self.Hour < 12];
		h = ((self.Hour - 1) % 12) + 1; hh = ('%02d'):format(((self.Hour - 1) % 12) + 1);
		H = self.Hour; HH = ('%02d'):format(self.Hour);
		m = self.Minute; mm = ('%02d'):format(self.Minute);
		s = self.Second; ss = ('%02d'):format(self.Second);
		f = self.Millisecond % 10; ff = ('%02d'):format(self.Millisecond % 100); fff = ('%03d'):format(self.Millisecond);
	};
	local ret = '';
	local i = 1;
	repeat
		local c = format:sub(i, i);
		local ri = i + 1;
		local r = '';
		if c == '\'' then
			ri = ((format:find("'", i + 1)) or #format) + 1;
			r = format:sub(i + 1, ri - 2);
			r = r == '' and '\'' or r;
		elseif c == '/' then
			r = dtfi.DateSeparator or '/';
		elseif c == ':' then
			r = dtfi.TimeSeparator or ':';
		elseif c:match(_DATEPATTERN) then
			_, ri = format:find(c .. '+', i);
			r = format:sub(i, ri);
			r = prop[r];
			r = r or '';
			
			ri = (ri or #format) + 1;
		else
			ri = (format:find(_DATEPATTERN, i)) or #format + 1;
			r = format:sub(i, ri - 1);
		end;
		i = ri;
		ret = ret .. r;
	until c ==  '' or not i;
	return ret;
end;

return dt;
end;