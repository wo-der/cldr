local u = { };
local num = require(script.Parent.Numbers);

function u.FormatUnit(locale, value, measurement_unit, length, format)
	local p = (locale.units[length or 'long'][measurement_unit] or {})[locale.numbers.pluralForm(value)];
	if p then
		return (p:gsub('{0}', num.FormatDecimal(locale, value, format, false)));
	else
		return nil;
	end;
end;

function u.FormatCompoundUnit(locale, numerator_value, numerator_unit, denominator_value, denominator_unit, length, format)
	local pluralForm = locale.numbers.pluralForm;
	local units = locale.units[length or 'long'];
	local compound = units.per.compoundUnitPattern;
	local n_p = (units[numerator_unit] or {})[pluralForm(numerator_value)]:gsub('{0}', num.FormatDecimal(locale, numerator_value, format, false));
	local d_p;
	if pluralForm(denominator_value) == 'one' then
		d_p = (units[denominator_unit] or {}).perUnitPattern or (units[denominator_unit] or {})[pluralForm(denominator_value)];
		if not d_p then
			return nil;
		end;
	else
		d_p = (units[denominator_unit] or {})[pluralForm(denominator_value)];
		if not d_p then
			return nil;
		end;
		d_p = d_p:gsub('{0}', num.FormatDecimal(locale, denominator_value, format, false));
		d_p = compound:gsub('{1}', d_p);
	end;
	return (d_p:gsub('{0}', n_p));
end;

return u;