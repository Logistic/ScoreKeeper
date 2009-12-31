local presetScores = {
--Teir 8 Tokens
	[45649] = 365,
	[45647] = 365,
	[45648] = 365,
    [45646] = 274,
	[45644] = 274,
	[45645] = 274,
	[45637] = 365,
	[45635] = 365,
	[45636] = 365,
	[45661] = 274,
	[45659] = 274,
	[45660] = 274,
	[45652] = 365,
	[45650] = 365,
	[45651] = 365,

--Teir 8.5 Tokens
	[45632] = 385,
	[45633] = 385,
	[45634] = 385,
	[45643] = 289,
	[45641] = 289,
	[45642] = 289,
	[45640] = 385,
	[45638] = 385,
	[45639] = 385,
	[45658] = 289,
	[45656] = 289,
	[45657] = 289,
	[45655] = 385,
	[45653] = 385,
	[45654] = 385,

--Teir 7 Tokens
	[40618] = 310,
	[40616] = 310,
	[40617] = 310,
   	[40615] = 233,
	[40613] = 233,
	[40614] = 233,
	[40612] = 310,
	[40610] = 310,
	[40611] = 310,
	[40624] = 233,
	[40622] = 233,
	[40623] = 233,
	[40621] = 310,
	[40619] = 310,
	[40620] = 310,

--Teir 7.5 Tokens
	[40633] = 348,
	[40631] = 348,
	[40632] = 348,
	[40630] = 261,
	[40628] = 261,
	[40629] = 261,
	[40627] = 348,
	[40625] = 348,
	[40626] = 348,
	[40639] = 261,
	[40637] = 261,
	[40638] = 261,
	[40636] = 348,
	[40634] = 348,
	[40635] = 348,
}

local slotMods = {
	["INVTYPE_RELIC"] = 0.3164,
	["INVTYPE_TRINKET"] = 0.5625,
	["INVTYPE_2HWEAPON"] = 2.000,
	["INVTYPE_WEAPONMAINHAND"] = 1.0000,
	["INVTYPE_WEAPONOFFHAND"] = 1.0000,
	["INVTYPE_RANGED"] = 0.3164,
	["INVTYPE_THROWN"] = 0.3164,
	["INVTYPE_RANGEDRIGHT"] = 0.3164,
	["INVTYPE_SHIELD"] = 1.0000,
	["INVTYPE_WEAPON"] = 1.0000,
	["INVTYPE_HOLDABLE"] = 1.0000,
	["INVTYPE_HEAD"] = 1.0000,
	["INVTYPE_NECK"] = 0.5625,
	["INVTYPE_SHOULDER"] = 0.7500,
	["INVTYPE_CHEST"] = 1.0000,
	["INVTYPE_ROBE"] = 1.0000,
	["INVTYPE_WAIST"] = 0.7500,
	["INVTYPE_LEGS"] = 1.0000,
	["INVTYPE_FEET"] = 0.75,
	["INVTYPE_WRIST"] = 0.5625,
	["INVTYPE_HAND"] = 0.7500,
	["INVTYPE_FINGER"] = 0.5625,
	["INVTYPE_CLOAK"] = 0.5625,
}

local function itemFunction(item)
	local rarity = ScoreKeeper.ItemObject.getRarity(item)
	local level = ScoreKeeper.ItemObject.getLevel(item)
	local id = ScoreKeeper.ItemObject.getId(item)
	local equipLoc = ScoreKeeper.ItemObject.getEquipLoc(item)
	
	if not level
	   or not rarity
	   or not id
	   or not equipLoc
	   or not slotMods[equipLoc]
	then
		return 0
	elseif presetScores[id] then
		return presetScores[id]
	end
	
	local qualityScale = 1
	local slotMod = slotMods[equipLoc]
	if rarity < 2 then
		qualityScale = 0.005
		rarity = 2
	elseif rarity == 5 then
		qualityScale = 1.3
		rarity = 4;
	elseif rarity == 7 then
    	rarity = 3
    	level = 187.05
    elseif rarity > 4 then
    	return 0
    end
    
    local constants
	if level > 120 then
		constants = {
			[4] = { ["A"] = 91.4500, ["B"] = 0.6500 },
			[3] = { ["A"] = 81.3750, ["B"] = 0.8125 },
			[2] = { ["A"] = 73.0000, ["B"] = 1.0000 }
		}
	else
		constants = {
			[4] = { ["A"] = 26.0000, ["B"] = 1.2000 },
			[3] = { ["A"] = 0.7500, ["B"] = 1.8000 },
			[2] = { ["A"] = 8.0000, ["B"] = 2.0000 },
		}
	end
	local score = math.floor(((level - constants[rarity].A) / constants[rarity].B) * slotMod * 1.8618 * qualityScale)
	if score > 0 then
		return score
	else
		return 0
	end
end

local function characterFunction(character)
	local score = 0
	local gear = character:getGear()
	if type(gear) == 'table' then
		local mainHandItem = character:getItem('MainHandSlot')
		local offHandItem = character:getItem('SecondaryHandSlot')
		local titanGripMultiplier = 1
		if (mainHandItem and offHandItem and ScoreKeeper.ItemObject.getEquipLoc(mainHandItem) == 'INVTYPE_2HWEAPON')
		   or (offHandItem and ScoreKeeper.ItemObject.getEquipLoc(offHandItem) == 'INVTYPE_2HWEAPON')
		then
			titanGripMultiplier = 0.5
		end
		for slotName, item in pairs(gear) do
			local itemScore = itemFunction(item)
			
			if slotName == 'SecondaryHandSlot' then
				itemScore = itemScore * titanGripMultiplier
				if character:getClass() == 'HUNTER' then
					itemScore = itemScore * 0.3164
				end
			elseif slotName == 'MainHandSlot' then
				itemScore = itemScore * titanGripMultiplier
				if character:getClass() == 'HUNTER' then
					itemScore = itemScore * 0.3164
				end
			elseif slotName == 'RangedSlot' then
				if character:getClass() == 'HUNTER' then
					itemScore = itemScore * 5.3224
				end
			end
			if slotName ~= 'AmmoSlot'
			   and slotName ~= 'TabardSlot'
			   and slotName ~= 'ShirtSlot'
			then
				score = score + itemScore
			end
		end
	end
	return floor(score)
end

ScoreKeeper.addScoreAlgorithm('GearScore', itemFunction, characterFunction)