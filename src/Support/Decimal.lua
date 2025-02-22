local _PREC = 27;
--[[
	0: 2,5 → 3; 1,5 → 2
	1: 2,5 → 2; 1,5 → 1
	2: 2,5 → 2; 1,5 → 2
	3: 2,5 → 3; 1,5 → 1
]]--
local _MIDPOINT_ROUNDING = 1;

local d = { };
local mt = { };

local max = math.max;
local abs = math.abs;

local BigInteger = require(script.Parent.BigInteger);

local function _new(int, exp)
	return setmetatable({ _int = int; _exp = exp; }, mt);
end;

local function _get(d)
	return rawget(d, '_int'), rawget(d, '_exp');
end;

function d.new(val)
	if type(val) == 'number' then
		val = ('%.99f'):format(val):gsub('0+$', '');
	elseif type(val) ~= 'string' then
		val = tostring(val);
	end;
	local exp = #val - ((val:find('[.,]')) or #val);
	return _new(BigInteger.new((val:gsub("[., '_]", ''))), exp);
end;

local function _round(self, decimals, midpoint_rounding)
	midpoint_rounding = midpoint_rounding or 0;
	local int, exp = _get(self);
	decimals = exp - (decimals or 0);
	if decimals <= 0 then
		return self;
	end
	local n_to_div = BigInteger.new(10) ^ decimals;
	local ret, rem = int:DivRem(n_to_div);
	local do_round = midpoint_rounding == 'ceil';
	if midpoint_rounding == 0 or (midpoint_rounding == 2 and ret % 2 == 0) or (midpoint_rounding == 3 and ret % 2 == 1) then
		do_round = do_round or (rem == (n_to_div / 2));
	end;
	if midpoint_rounding ~= 'floor' then
		do_round = do_round or (rem > (n_to_div / 2));
	end
	if do_round then
		ret = ret + 1;
	end;
	return _new(ret, exp - decimals);
end;

local function _add(left, right)
	local l_int, l_exp = _get(left);
	local r_int, r_exp = _get(right);
	if l_exp > r_exp then
		r_int = r_int * (BigInteger.new(10) ^ (l_exp - r_exp));
	elseif r_exp > l_exp then
		l_int = l_int * (BigInteger.new(10) ^ (r_exp - l_exp));
	end;
	return _new(l_int + r_int, max(l_exp, r_exp));
end;

local function _umn(self)
	local int, exp = _get(self);
	return _new(-int, exp);
end;

local function _sub(left, right)
	return _add(left, _umn(right));
end;

local function _mul(left, right)
	local l_int, l_exp = _get(left);
	local r_int, r_exp = _get(right);
	return _new(l_int * r_int, l_exp + r_exp);
end;

local function _div(left, right)
	local l_int, l_exp = _get(left);
	local r_int, r_exp = _get(right);
	if l_exp > r_exp then
		r_int = r_int * (BigInteger.new(10) ^ (l_exp - r_exp));
	elseif r_exp > l_exp then
		l_int = l_int * (BigInteger.new(10) ^ (r_exp - l_exp));
	end;
	l_int = l_int * (BigInteger.new(10) ^ (_PREC + 1));
	return _round(_new(l_int / r_int, _PREC + 1), _PREC);
end;

local function _tryparse(self)
	return tonumber(tostring(self));
end;

local function _check(func)
	return function(left, right)
		if type(left) == 'number' then left = d.new(left); end;
		if type(right) == 'number' then right = d.new(right); end;
		if not rawget(left, '_exp') then left = d.new(left); end;
		if not rawget(right, '_exp') then right = d.new(right); end;
		return func(left, right);
	end;
end;
--
mt.__add = _check(_add);
mt.__sub = _check(_sub);
mt.__mul = _check(_mul);
mt.__div = _check(_div);
mt.__umn = _umn;

function mt.__tostring(self)
	local int, exp = _get(self);
	local sign = '';
	int = tostring(int);
	if #int <= exp then
		int = ('0'):rep(exp - #int + 1) .. int;
	end;
	if exp == 0 then
		return int:sub(1, -exp - 1);
	end
	return (int:sub(1, -exp - 1) .. '.' .. int:sub(-exp)):gsub('[.]0+$', '');
end;

function mt.__index(self, index)
	local _methods =
	{
		Round = _round;
		TryParse = _tryparse;
		Floor = function(self, decimals) return _round(self, decimals, 'floor'); end;
		Ceiling = function(self, decimals) return _round(self, decimals, 'ceil'); end;
	};
	if _methods[index] then
		return _methods[index];
	else
		error(index .. " is not a valid member of BigInteger");
	end;
end;

return d;