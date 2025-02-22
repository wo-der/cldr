-- semver 1.0.0
do local dtfi = require(script.DateTimeFormatInfo); return
{
	DateTime = require(script.DateTime);
	TimeSpan = require(script.TimeSpan);
	DateTimeFormatInfo = dtfi.dt;
	TimeSpanFormatInfo = dtfi.ts;
};
end;