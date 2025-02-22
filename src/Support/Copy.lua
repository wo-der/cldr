local c = {};

function c.Copy(x)
	local ret = { };
	for k, v in next, x do
		ret[k] = v;
	end;
	return ret;
end;

function c.DeepCopy(x)
	local ret = { };
	for k, v in next, x do
		if type(v) == 'table' then
			ret[k] = c.DeepCopy(v);
		else
			ret[k] = v;
		end;
	end;
	return ret;
end;

return c;