setfenv(1, ScoreKeeper)
--[[
	id          string  - The item id.
	enchant     integer - The item enchant.
	gem1        integer - Gem in socket 1.
	gem2        integer - Gem in socket 2.
	gem3        integer - Gem in socket 3.
	gem4        integer - Gem in socket 4.
	suffixId    integer - Id number for item suffix such as "of the bear".
	uniqueId    integer - Data pertaining to a specific instance of the item. 
--]]
ItemObject = {}

addInit(function()
	Object.setup(ItemObject)
end)

function ItemObject:new(new)
	return new or ''
end

function ItemObject:loadFromLink(link)
	local linkData = string.match(link, "|cff%x*|Hitem:(%d+:%d*:%d*:%d*:%d*:%d*:%-?%d*:%-?%d*):%d*|h%[[^%]]*]|h|r")
	return ItemObject.new(ItemObject, linkData or (self ~= ItemObject and self))
end

function ItemObject:getId()
	return tonumber(string.match(self, "(%d+):%d*:%d*:%d*:%d*:%d*:%-?%d*:%-?%d*"))
end

function ItemObject:getEnchant()
	return tonumber(string.match(self, "%d+:(%d*):%d*:%d*:%d*:%d*:%-?%d*:%-?%d*"))
end

function ItemObject:getGem1()
	return tonumber(string.match(self, "%d+:%d*:(%d*):%d*:%d*:%d*:%-?%d*:%-?%d*"))
end

function ItemObject:getGem2()
	return tonumber(string.match(self, "%d+:%d*:%d*:(%d*):%d*:%d*:%-?%d*:%-?%d*"))
end

function ItemObject:getGem3()
	return tonumber(string.match(self, "%d+:%d*:%d*:%d*:(%d*):%d*:%-?%d*:%-?%d*"))
end

function ItemObject:getGem4()
	return tonumber(string.match(self, "%d+:%d*:%d*:%d*:%d*:(%d*):%-?%d*:%-?%d*"))
end

function ItemObject:getSuffixId()
	return tonumber(string.match(self, "%d+:%d*:%d*:%d*:%d*:%d*:(%-?%d*):%-?%d*"))
end

function ItemObject:getUniqueId()
	return tonumber(string.match(self, "%d+:%d*:%d*:%d*:%d*:%d*:%-?%d*:(%-?%d*)"))
end

function ItemObject:getName()
	local name = GetItemInfo(ItemObject.getId(self))
	return name
end

function ItemObject:getRarity()
	local name, link, rarity = GetItemInfo(ItemObject.getId(self))
	return rarity
end

function ItemObject:getLevel()
	local name, link, rarity, level = GetItemInfo(ItemObject.getId(self))
	return level
end

function ItemObject:getMinLevel()
	local name, link, rarity, level, minLevel = GetItemInfo(ItemObject.getId(self))
	return minLevel
end

function ItemObject:getType()
	local name, link, rarity, level, minLevel, itype = GetItemInfo(ItemObject.getId(self))
	return itype
end

function ItemObject:getSubType()
	local name, link, rarity, level, minLevel, itype, subType = GetItemInfo(ItemObject.getId(self))
	return subType
end

function ItemObject:getStackCount()
	local name, link, rarity, level, minLevel, itype, subType, stackCount = GetItemInfo(ItemObject.getId(self))
	return stackCount
end

function ItemObject:getEquipLoc()
	local name, link, rarity, level, minLevel, itype, subType, stackCount, equipLoc = GetItemInfo(ItemObject.getId(self))
	return equipLoc
end

function ItemObject:getIcon()
	return GetItemIcon(ItemObject.getId(self))
end

function ItemObject:getSellPrice()
	local name, link, rarity, level, minLevel, itype, subType, stackCount, equipLoc, icon, sellPrice = GetItemInfo(ItemObject.getId(self))
	return sellPrice
end

local itemRarityColors = {
	[0] = '9d9d9d',
	[1] = 'ffffff',
	[2] = '1eff00',
	[3] = '0070dd',
	[4] = 'a335ee',
	[5] = 'ff8000',
	[6] = 'e6cc80',
	[7] = 'e6cc80'
}
function ItemObject:getColor()
	local rarity = ItemObject.getRarity(self)
	return rarity and itemRarityColors[rarity]
end

function ItemObject:getScore(algorithm)
	local functions = scoreAlgorithms[algorithm]
	return functions and type(functions.item) == 'function' and functions.item(self)
end

function ItemObject:getScoreText()
	local scoreString = ''
	local first = true
	for algorithm, functions in pairs(scoreAlgorithms) do
		if not Settings:isItemTooltipEnabled(algorithm) then
			local score = ItemObject.getScore(self, algorithm)
			if score then
				if first then
					first = false
				else
					scoreString = scoreString .. '\n'
				end
				scoreString = scoreString .. algorithm .. ': ' .. score
			end
		end
	end
	return scoreString
end

function ItemObject:getLink(linkLevel)
	local color       = ItemObject.getColor(self)
	linkLevel   = linkLevel or 0
	local name = ItemObject.getName(self)
	if not color or self == '' or not name then
		return ItemObject.getInfo(self, 2)
	end
	local linkString = '|cff%s|Hitem:%s:%d|h[%s]|h|r'
	return linkString:format(color, self, linkLevel, name)
end