setfenv(1, ScoreKeeper)
eventFrame = CreateFrame('Frame')
events = {}

function events:PLAYER_TARGET_CHANGED()
	local character, name, realm = Database:addCharacterFromUnitId('target')
	if character and name and realm and ScoreKeeper_InspectFrame:IsShown() then
		Ui:inspectCharacter(character, name, realm)
	end
end

function events:EQUIPMENT_SWAP_FINISHED()
	Database:addCharacterFromUnitId('player')
end

function events:ADDON_LOADED(addon)
	if addon == 'ScoreKeeper' and not ScoreKeeper:isInitialized() then
		init()
	end
end

eventFrame:SetScript('OnEvent', function(self, event, ...)
	if event == 'ADDON_LOADED' or Settings and Settings:isEventEnabled(event) then
		local eventFunction = events[event]
		if type(eventFunction) == 'function' then
			eventFunction(self, ...)
		end
	end
end)
for event, func in pairs(events) do
	eventFrame:RegisterEvent(event);
end