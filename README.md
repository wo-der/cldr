# Original Lua CLDRTools

[CLDRTools, a tool for formatting/shortening numbers, getting plurals etc. (Undocumented!)](https://devforum.roblox.com/t/cldrtools-a-tool-for-formattingshortening-numbers-getting-plurals-etc-undocumented/539614)

```luau
local CLDR = require(path.to.CLDR)

local locale = CLDR.Locale.new("de", "DE")

print(CLDR.Numbers.FormatDecimal(locale, 2000))
print(CLDR.Numbers.FormatCompactDecimal(CLDR.Locale.new("en", "US"), 25125, nil, { 2, 1, 0 }))
print(CLDR.Numbers.FormatPercent(CLDR.Locale.new("fr", "FR"), 0.75))
print(CLDR.Units.FormatUnit(CLDR.Locale.new("en", "IN"), 123456, "length-meter", "long"))
print(CLDR.Units.FormatUnit(CLDR.Locale.new("en", "IN"), 1, "length-inch", "long"))
print(CLDR.Units.FormatCompoundUnit(CLDR.Locale.new("ja", "JP"), 3, "length-mile", 2, "duration-second", "long"))
print(CLDR.Lists.FormatList(locale, { locale.localeDisplayNames.territories.GB, locale.localeDisplayNames.territories.DE, locale.localeDisplayNames.territories.JP }, "or"))
print(CLDR.Dates.FormatDateTime(CLDR.Locale.new("da", "DK"), CLDR.DateTimes.DateTime.new(1998, 5, 28, 34, 38, 21), "long"))
print(CLDR.Dates.FormatDate(CLDR.Locale.new("de", "DE"), CLDR.DateTimes.DateTime.new(2020, 1, 31), "medium"))
print(CLDR.Dates.FormatDate(CLDR.Locale.new("en", "US"), CLDR.DateTimes.DateTime.new(2020, 1, 31), "medium"))
print(CLDR.Dates.FormatFlexible(CLDR.Locale.new("en", "US"), CLDR.DateTimes.DateTime.new(2020, 2, 5), "Md"))
print(CLDR.Dates.FormatTime(CLDR.Locale.new("id", "ID"), CLDR.DateTimes.DateTime.new(1, 1, 1, 14, 15, 16)))
```
```
2.000
25.1K
75 %
1,23,456 metres
1 inch
3 マイル毎2 秒
Vereinigtes Königreich, Deutschland oder Japan
29. maj 1998 kl. 10.38.21 UTC
31.01.2020
Jan 31, 2020
2/5
14.15.16
1.00
```