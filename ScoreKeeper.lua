ScoreKeeper = setmetatable({_G = _G}, {__index = _G})
setfenv(1, ScoreKeeper)

scoreAlgorithms = {}
initialized = false
initFunctions = {}

function init()
	for k, initFunction in ipairs(initFunctions) do
		initFunction()
	end
	
	_G.ScoreKeeper_LocalizationCache = ScoreKeeper_LocalizationCache or {
		classes = {},
		races = {},
		factions = {}
	}
	_G.ScoreKeeper_LastVersion = getVersion()
	_G.ScoreKeeper_Database = DatabaseObject:new(_G.ScoreKeeper_Database)
	_G.ScoreKeeper_Settings = SettingsObject:new(_G.ScoreKeeper_Settings)
	
	LocalizationCache = _G.ScoreKeeper_LocalizationCache
	LastVersion = _G.ScoreKeeper_LastVersion
	Database = _G.ScoreKeeper_Database
	Settings = _G.ScoreKeeper_Settings
	
	Database:addCharacterFromUnitId('player')
	
	initialized = true
end

function addInit(initFunction)
	tinsert(initFunctions, initFunction)
end

function isInitialized()
	return initialized
end

function getVersion()
	return tonumber(getMetadata('Version'))
end

function getMetadata(value)
	return GetAddOnMetadata('ScoreKeeper', value)
end

function addScoreAlgorithm(name, itemFunction, characterFunction)
	if name then
		scoreAlgorithms[name] = {
			item = itemFunction,
			character = characterFunction
		}
	end
end

function resetDatabase()
	_G.ScoreKeeper_Database = DatabaseObject:new()
	Database = ScoreKeeper_Database
end

function restoreDefaultSettings()
	_G.ScoreKeeper_Settings = SettingsObject:new()
	Settings = ScoreKeeper_Settings
end