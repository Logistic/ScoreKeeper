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
	local count = 0
	if type(gear) == 'table' then
		for index, item in pairs(gear) do
			local slotName = character:getSlotName(index)
			if slotName ~= 'AmmoSlot'
			   and slotName ~= 'TabardSlot'
			   and slotName ~= 'ShirtSlot'
			then
				score = score + itemFunction(item)
				count = count + 1
			end
		end
		if count == 0 then
			return 0
		end
		score = floor(score / count)
	end
	return score
end
ScoreKeeper.addScoreAlgorithm('Average', itemFunction, characterFunction)