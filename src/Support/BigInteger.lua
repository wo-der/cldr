local _DEFAULT_BASE = 94906265; -- 94.906.265 -- floor(2 ^ 26,5)
local _BASE = 10;

local bi = { };
local mt = { };

local abs = math.abs;
local sqrt = math.sqrt;
local min = math.min;
local max = math.max;
local floor = math.floor;
local div = function(left, right) return floor(left / right); end;
local divmod = function(left, right) return div(left, right), left % right; end;

local function _new(int, sign, base)
	return setmetatable({ _int = int; _sign = sign; _base = base or _BASE }, mt);
end;

local function _parse(val)
	if type(val) ~= 'string' then
		val = ('%.0f'):format(val);
	end;
	local ret = { };
	local ret_sign = 1;
	local ret_base = 10;
	if val:sub(1, 1) == '-' then
		ret_sign = -1;
		val = val:sub(2);
	end;
	local b_identifier = { b = 2; o = 8; x = 16; };
	local num_prop = { ['0'] = 0; ['1'] = 1; ['2'] = 2; ['3'] = 3; ['4'] = 4; ['5'] = 5; ['6'] = 6; ['7'] = 7; ['8'] = 8; ['9'] = 9; ['a'] = 10; ['b'] = 11; ['c'] = 12; ['d'] = 13; ['e'] = 14; ['f'] = 15; ['A'] = 10; ['B'] = 11; ['C'] = 12; ['D'] = 13; ['E'] = 14; ['F'] = 15; };
	if val:sub(1, 1) == '0' and b_identifier[val:sub(2, 2)] then
		ret_base = b_identifier[val:sub(2, 2)];
		val = val:sub(3);
	end;
	val = val:gsub("[.].+", ''):gsub('[_,.]', '');
	for v in val:gmatch('[0-9a-fA-F]') do
		table.insert(ret, 1, num_prop[v]);
	end;
	return _new(ret, ret_sign, ret_base);
end;

local function _zero(base) return _new({ 0 }, 0, base); end;
local function _one(base) return _new({ 1 }, 1, base); end;

function bi.new(val)
	return _parse(val);
end;

function bi.Zero()
	return bi.new(0);
end;

local function _update(bi)
	local r_int = rawget(bi, '_int');
	for i = #r_int, 1, -1 do
		if r_int[i] == 0 then
			table.remove(r_int, i);
		else
			break;
		end;
	end;
	if #r_int == 0 then
		rawset(bi, '_sign', 0);
	end;
	rawset(bi , '_int', r_int);
	return bi;
end;

local function _get(bi)
	return rawget(bi, '_int'), rawget(bi, '_sign'), rawget(bi, '_base');
end;

local function _lt(left, right)
	local l_int, l_sign, _ = _get(left);
	local r_int, r_sign, _ = _get(right);
	
	for i = max(#l_int, #r_int), 1, -1 do
		if (l_int[i] or 0) ~= (r_int[i] or 0) then
			return (l_int[i] or 0) < (r_int[i] or 0);
		end;
	end;
	return false;
end;

local function _le(left, right)
	return not _lt(right, left);
end;

local function _eq(left, right)
	return not (_lt(right, left) or _lt(left, right));
end;

local function _shift(value, shift, left)
	local int, sign, base = _get(value);
	if shift < 0 then
		error("Negative shift count")
	end;
	local count = 0--_new( { 0 }, 0, base);
	while count < shift do
		table.insert(int, left and 1 or nil, 0);
		count = count + 1;
	end;
	return _update(_new(int, sign, base));
end

local function _lshift(value, shift)
	return _shift(value, shift, true);
end;

local function _rshift(value, shift)
	return _shift(value, shift, false);
end;

local function _add(left, right)
	local l_int, l_sign, base = _get(left);
	local r_int, r_sign, _ = _get(right);
	
	local ret = { };
	local ret_sign = 1;
	local c = 0;
	for i = 1, max(#l_int, #r_int) do
		local r = c + ((l_int[i] or 0) * l_sign) + ((r_int[i] or 0) * r_sign);
		c, r = divmod(r, base);
		ret[i] = r;
	end;
	if c < 0 then
		ret_sign = ret_sign * -1;
		c = 0;
		for i = 1, #ret do
			local r = c - (ret[i] or 0);
			c, r = divmod(r, base);
			ret[i] = r;
		end;
	end;
	if c > 0 then
		table.insert(ret, c);
	end;
	return _update(_new(ret, ret_sign, base));
end;

local function _unm(self)
	local int, sign, base = _get(self);
	return _new(int, sign * - 1, base);
end;

local function _sub(left, right)
	return left + _unm(right);
end;

local function _mul(left, right)
	--[[
		Implemented from Wikipedia: https://en.wikipedia.org/wiki/Multiplication_algorithm#Optimizing_space_complexity
		multiply(a[1..p], b[1..q], base)                  // Operands containing rightmost digits at index 1
		    tot = 0
		    for ri = 1 to p + q - 1                       //For each digit of result
		        for bi = MAX(1, ri - p + 1) to MIN(ri, q) //Digits from b that need to be considered
		            ai = ri − bi + 1                      //Digits from a follow "symmetry"
		            tot = tot + (a[ai] * b[bi])
		        product[ri] = tot mod base
		        tot = floor(tot / base)
		    product[p+q] = tot mod base                   //Last digit of the result comes from last carry
		    return product
	]]--
	
	local l_int, l_sign, base = _get(left);
	local r_int, r_sign, _ = _get(right);
	
	local p, q = #l_int, #r_int;
	local ret = { };
	local tot = 0;
	for ri = 1, p + q do
		for bi = max(1, ri - p + 1), min(ri, q) do
			local ai = ri - bi + 1;
			tot = tot + (l_int[ai] * r_int[bi]);
		end;
		tot, ret[ri] = divmod(tot, base);
	end;
	ret[p + q + 1] = tot % base;
	return _update(_new(ret, l_sign * r_sign, base));
end;

local function _divmod(left, right)
	local l_int, l_sign, base = _get(left);
	local r_int, r_sign, a = _get(right);
	
	-- Elimiating the obvious
	if left == 1 then
		return _zero(base), _one(base);
	elseif left == 0 then
		return _zero(base), _zero(base);
	elseif right == 1 then
		return left, _zero(base);
	elseif right == 0 then
		error("Attempted to divide by zero.");
	elseif left == right then
		return _one(base), _zero(base);
	elseif left < right then
		return _zero(base), left;
	end;
	
	local p, q, ret, rem = #l_int, #r_int, _zero(base), _zero(base);
	for i = p, 1, -1 do
		rem = bi.new(base) * rem + bi.new(l_int[i]);
		if rem >= right then
			local beta = _zero(base);
			repeat
				beta = beta + _one(base);
				rem = rem - right;
			until rem < right;
			ret = bi.new(base) * ret + beta;
		else
			ret = bi.new(base) * ret;
		end;
	end;
	return ret, rem;
end;

local function _div(left, right)
	return (_divmod(left, right));
end;

local function _mod(left, right)
	local _, m = _divmod(left, right);
	return m;
end;

local function _pow(left, right)
	local base = rawget(left, '_base');
	local ret = _one(base);
	local count = _zero(base);
	while count < right do
		count = count + _one(base);
		ret = ret * left;
	end;
	return ret;
end;

local function _tryparse(self)
	local int, sign, base = _get(self);
	local ret = 0;
	for i = 1, #int do
		ret = ret + (int[i] * (base ^ (i - 1)));
	end;
	return ret * sign;
end;

local function _convert(self, base)
	local int, sign, self_base = _get(self);
	if self_base == base then
		return self;
	end;
	local ret = { };
	repeat
		local d;
		self, d = self:DivRem(_new({ base }, 1, self_base));
		table.insert(ret, _tryparse(d));
	until self == _zero(self_base);
	return _update(_new(ret, sign, base));
end;

local function _check(func)
	return function(left, right)
		if type(left) == 'number' then left = _parse(left); end;
		if type(right) == 'number' then right = _parse(right); end;
		--if rawget(left, '_base') ~= rawget(right, '_base') then right = _convert(right, rawget(left, '_base')) end;
		return func(left, right);
	end;
end;

--
mt.__lt = _check(_lt);
mt.__le = _check(_le);
mt.__eq = _check(_eq);

mt.__add = _check(_add);
mt.__sub = _check(_sub);
mt.__mul = _check(_mul);
mt.__div = _check(_div);
mt.__mod = _check(_mod);
mt.__unm = _check(_unm);
mt.__pow = _check(_pow);

function mt.__concat(left, right)
	return tostring(left) .. tostring(right);
end;

function mt.__tostring(self)
	local int, sign, base = _get(self);
	if sign == 0 then
		return '0';
	elseif base == 10 then
		return (sign == -1 and '-' or '') .. table.concat(int, ''):reverse();
	else
		return mt.__tostring(_convert(self, 10));
	end;
end;

function mt.__index(self, index)
	local _methods =
	{
		LeftShift = _lshift;
		RightShift = _rshift;
		DivRem = _divmod;
		TryParse = _tryparse;
	};
	if _methods[index] then
		return _check(_methods[index]);
	elseif index == 'Sign' then
		return rawget(self, '_sign');
	else
		error(index .. " is not a valid member of BigInteger");
	end;
end;
--

return bi;