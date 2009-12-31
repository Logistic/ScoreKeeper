setfenv(1, ScoreKeeper)
--[[
	class        string
	sex          string
	race         string
	level        integer
	guildIndex   integer
	gear         table
	scanTime     integer
--]]

CharacterObject = {}

addInit(function()
	Object.setup(CharacterObject)
end)

local slotNames = {
	'AmmoSlot',
	'BackSlot',
	'ChestSlot',
	'FeetSlot',
	'Finger0Slot',
	'Finger1Slot',
	'HandsSlot',
	'HeadSlot',
	'LegsSlot',
	'MainHandSlot',
	'NeckSlot',
	'RangedSlot',
	'SecondaryHandSlot',
	'ShirtSlot',
	'ShoulderSlot',
	'TabardSlot',
	'Trinket0Slot',
	'Trinket1Slot',
	'WaistSlot',
	'WristSlot',
}

function CharacterObject:loadFromUnitId(unitId)
	self = self ~= CharacterObject and self or self:new()
	if UnitIsPlayer(unitId) and CanInspect(unitId) then
		local localizedClass, englishClass = UnitClass(unitId)
		LocalizationCache.classes[englishClass] = localizedClass
		self.class = englishClass
		
		self.sex = UnitSex(unitId)
		
		local localizedRace, englishRace = UnitRace(unitId)
		LocalizationCache.races[englishRace] = localizedRace
		self.race = englishRace
		
		self.level = UnitLevel(unitId)
		
		--Faction is obtainable from race, no need to store it
		local englishFaction, localizedFaction = UnitFactionGroup(unitId)
		LocalizationCache.factions[englishFaction] = localizedFaction
		
		self.guild = GetGuildInfo(unitId)
		
		NotifyInspect(unitId)
		self.gear = {}
		for k, slotName in pairs(slotNames) do
			local slotId = GetInventorySlotInfo(slotName)
			local link = GetInventoryItemLink(unitId, slotId)
			if link then
				local item = ItemObject:loadFromLink(link)
				if item and item ~= '' then
					self.gear[slotName] = item
				end
			end
		end
		self.scanTime = time()
	end
	return self
end

function CharacterObject:getClass()
	return self.class
end

function CharacterObject:getLocalizedClass()
	return Localization:getClass(self:getClass())
end

function CharacterObject:getSex()
	return self.sex
end

function CharacterObject:getSexName()
	local sex = self:getSex()
	if sex == 3 then
		return 'Female'
	else
		return 'Male'
	end
end

function CharacterObject:getLocalizedSex()
	return Localization:getSex(self:getSexName())
end

function CharacterObject:getRace()
	return self.race
end

function CharacterObject:getLocalizedRace()
	return Localization:getRace(self:getRace())
end

function CharacterObject:getLevel()
	return self.level
end

function CharacterObject:getGuild()
	return self.guild
end

function CharacterObject:getGear()
	return self.gear
end

function CharacterObject:getScanTime()
	return self.scanTime
end

function CharacterObject:getFaction()
	local race = self:getRace()
	if race == 'Orc'
	   or race == 'BloodElf'
	   or race == 'Tauren'
	   or race == 'Troll'
	   or race == 'Scourge'
	then
		return 'Horde'
	else
		return 'Alliance'
	end
end

function CharacterObject:getLocalizedFaction()
	return Localization:getFaction(self:getFaction())
end

function CharacterObject:getPortraitTexture()
	local race = self:getRace()
	local sexName = self:getSexName()
	return 'Interface\\CHARACTERFRAME\\TemporaryPortrait-'..sexName..'-'..race
end

function CharacterObject:getScore(algorithm)
	local functions = scoreAlgorithms[algorithm]
	return functions and type(functions.character) == 'function' and functions.character(self)
end

function CharacterObject:hasRelicSlot()
	local class = self:getClass()
	return class == 'DEATHKNIGHT'
	    or class == 'DRUID'
	    or class == 'PALADIN'
	    or class == 'SHAMAN'
end

function CharacterObject:getItem(slot)
	local gear = self:getGear()
	return gear and self.gear[slot]
end

function CharacterObject:getScoreText()
	local scoreString = ''
	local first = true
	for algorithm, functions in pairs(scoreAlgorithms) do
		if not Settings:isCharacterTooltipEnabled(algorithm) then
			local score = self:getScore(algorithm)
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