local function itemFunction(item)
	local score = ScoreKeeper.ItemObject.getLevel(item) or 0
	if score < 0 then
		score = 0
	end
	return score
end

local function characterFunction(character)
	local score = 0
	local gear = character:getGear()
	if type(gear) == 'table' then
		for index, item in pairs(gear) do
			local slotName = character:getSlotName(index)
			if slotName ~= 'AmmoSlot'
			   and slotName ~= 'TabardSlot'
			   and slotName ~= 'ShirtSlot'
			then
				score = score + itemFunction(item)
			end
		end
	end
	return score
end

ScoreKeeper.addScoreAlgorithm('Total', itemFunction)