setfenv(1, ScoreKeeper)
Locales = {}
Localization = {}

addInit(function()
	Locale = Locales[GetLocale()]
end)

function Localization:getRace(englishRace)
	local localRace = LocalizationCache.races[englishRace]
	return localRace or englishRace or self:getUknown()
end

function Localization:getClass(englishClass)
	local localClass = LocalizationCache.classes[englishClass]
	return localClass or englishClass or self:getUknown()
end

function Localization:getFaction(englishFaction)
	local localFaction = LocalizationCache.factions[englishFaction]
	return localFaction or englishFaction or self:getUknown()
end

function Localization:getSex(englishSex)
	return Locale and englishSex and Locale[englishSex] or englishSex or self:getUknown()
end
function Localization:getString(name)
	return Locale and name and Locale[name] or name or self:getUknown()
end

function Localization:getUknown()
	return self:getString('Uknown')
end

function Localization:getCommandDescription(command)
	return Locale and command and Locale.commandDescription[command]
end

function Localization:getCommandHelp(command)
	return Locale and command and Locale.commandHelp[command]
end