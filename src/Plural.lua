local p = {};

local function _isin(a, b)
	local ret = false;
	for n in b:gmatch("[^,]+") do
		local n1, p, n2 = n:match("(%d+)([.]*)(%d*)");
		if p == '..' then
			ret = ret or (tonumber(a) >= tonumber(n1) and tonumber(a) <= tonumber(n2));
		else
			ret = ret or (tonumber(a) == tonumber(n));
		end;
	end;
	return ret;
end;

local function _operand(n)
	local f = tostring(n):match("[.]([0-9]*)");
	f = f or '';
	local t = (f:gsub('0+$', ''));
	t = t == '' and '0' or t;
	return
	{
		n = tostring(n);
		i = tostring(n):gsub("[.].+", '');
		v = #f;
		w = #t;
		f = f == '' and '0' or f:gsub('^0+', '0');
		t = t;
	};
end;

local function _parse_rule(rule)
	rule = rule:gsub('and', '&'):gsub('or', '|'):gsub('mod', '%%'):gsub('is%s+not', '!='):gsub('is', '='):gsub('in', '='):gsub("%s*%%%s*", "%%");
	local function a(n)
		local ret = false;
		for t, r in rule:gmatch("([&|]?)([^|&]+)") do
			local cf, cr, ct = r:match("%s*([niftvw%%0-9.]+)%s*([!]?=)%s*([0-9., \t\n]+)%s*");
			local op, op_m = cf:match("([niftwv])%s*[%%]%s*([0-9.]+)");
			op = op or cf;
			local op_r = _operand(n)[op];
			if op_m then
				op_r = op_r % op_m;
			end;
			local c_ret = not((cr == '!=') == _isin(op_r, ct))
			ret = (t == '&' and (ret and c_ret)) or (t ~= '&' and (ret or c_ret));
		end;
		return ret;
	end;
	return a;
end;

function p.PluralRule(rules)
	return setmetatable(
		{ rules = rules },
		{
			__call = function(self, n)
				if _parse_rule(rules.zero or '')(n) then
					return 'zero';
				elseif _parse_rule(rules.one or '')(n) then
					return 'one';
				elseif _parse_rule(rules.two or '')(n) then
					return 'two';
				elseif _parse_rule(rules.few or '')(n) then
					return 'few';
				elseif _parse_rule(rules.many or '')(n) then
					return 'many'
				else
					return 'other';
				end;
			end;
		}
	);
end;

return p;