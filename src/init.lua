-- An module based on CLDR, for readme, please go to the Support module
do local s = script; return
{
	Locale = require(s.Locale);
	Numbers = require(s.Numbers);
	Plural = require(s.Plural);
	Dates = require(s.Dates);
	Lists = require(s.Lists);
	Units = require(s.Units);
	Texts = require(s.Texts);
};
end;