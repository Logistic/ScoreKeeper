setfenv(1, ScoreKeeper)
Object = {}

addInit(function()
	Object:setup()
end)

function Object:setup()
	if not self.__index then
		self.__index = self
	end
	if not self.prototype then
		self.prototype = self
	end
	if self ~= Object then
		if not self.parent then
			self.parent = Object
		end
		setmetatable(self, self.parent)
	end
end

function Object:new(new)
	new = new or {}
	local oldMeta = getmetatable(new)
	if not oldMeta or oldMeta ~= self.prototype then
		setmetatable(new, self.prototype)
	end
	return new
end

function Object:clone(clone)
	clone = self:new(clone)
	return tcopy(self, clone)
end

function Object:deepClone(clone, depth)
	clone = self:new(clone)
	return tdeepcopy(self, clone, depth)
end