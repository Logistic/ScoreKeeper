setfenv(1, ScoreKeeper)
SettingsObject = {}

addInit(function()
	Object.setup(SettingsObject)
end)

function SettingsObject:new(new)
	if not new then
		--Default Settings
		new = {
			disableCharacterScoreTooltip = {
			},
			disableItemScoreTooltip = {
				Total = true,
				Average = true
			},
			enableCombatEvents = false
		}
	end
	return self.parent.new(self, new)
end

function SettingsObject:isItemTooltipEnabled(algorithm)
	return self.disableItemScoreTooltip[algorithm]
end

function SettingsObject:isCharacterTooltipEnabled(algorithm)
	return self.disableCharacterScoreTooltip[algorithm]
end

function SettingsObject:isEventEnabled(event)
	return self.enableCombatEvents or not InCombatLockdown()
end