setfenv(1, ScoreKeeper)
string = setmetatable({}, {__index = _G.string})
table = setmetatable({}, {__index = _G.table})

addInit(function()
	local fenv = getfenv(1)
	for name, stringFunction in pairs(string) do
		fenv['str'..name] = stringFunction
	end
	for name, tableFunction in pairs(table) do
		fenv['t'..name] = tableFunction
	end
end)

function string:ucfirst()
	return string.upper(string.sub(self, 1, 1))..string.sub(self, 2)
end

function string:stripNonAlphaNumeric()
	return self:gsub('[^%w]', '')
end

function table:addValues(t2)
	for k, v in pairs(t2) do
		table.insert(self, v)
	end
end

function table:mergeValues(t2)
	local merged = {}
	table.addValues(merged, self)
	table.addValues(merged, t2)
	return merged
end

function table:add(t2)
	for k, v in pairs(t2) do
		self[k] = v
	end
end

function table:merge(t2)
	local merged = {}
	table.add(merged, self)
	table.add(merged, t2)
	return merged
end

function table:copy(new)
	new = new or {}
	for k, v in pairs(self) do
		new[k] = v
	end
	return new
end

function table:deepcopy(new, depth)
	if type(self) ~= 'table' then
		return self
	end
	if not depth then
		newdepth = nil
	elseif depth <= 0 then
		return self
	else
		newdepth = depth - 1
	end
	local new = new or {}
	for k, v in pairs(self) do
		new[k] = table.deepcopy(v, newdepth)
	end
	return new
end