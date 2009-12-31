setfenv(1, ScoreKeeper)

LoadAddOn('Blizzard_InspectUI')

GameTooltip:HookScript('OnTooltipSetUnit', function(self)
	local name, unitId = self:GetUnit()
	local character, name, realm = Database:addCharacterFromUnitId(unitId)
	if character then
		self:AddLine(character:getScoreText())
		self:Show()
	end
end)

GameTooltip:HookScript("OnTooltipSetItem", function(self)
	local name, link = self:GetItem()
	local item = ItemObject:loadFromLink(link)
	local equipLoc = ItemObject.getEquipLoc(item)
	if item and equipLoc and equipLoc ~= '' then
		self:AddLine(ItemObject.getScoreText(item))
		self:Show()
	end
end)

CharacterFrame:HookScript('OnShow', function(self)
	local character = Database:addCharacterFromUnitId('player')
	ScoreKeeper_CharacterScoreFrame_Text:SetText(character:getScoreText())
end)

local inspectUnitName, inspectUnitRealm
InspectFrame:HookScript('OnShow', function(self)
	if InspectFrame.unit then
		inspectUnitName, inspectUnitRealm = UnitName(InspectFrame.unit)
		inspectUnitRealm = inspectUnitRealm or GetRealmName()
	end
	
	HideUIPanel(ScoreKeeper_InspectFrame)
	local character = Database:getCharacterFromUnitId(self.unit)
	ScoreKeeper_InspectCharacterScoreFrame_Text:SetText(character:getScoreText())
end)

hooksecurefunc('InspectPaperDollFrame_SetLevel', function(unit)
	local unit = InspectFrame.unit
	local guild = GetGuildInfo(unit)
	if guild then
		local PLAYER_GUILD = '<%s>'
		InspectGuildText:SetFormattedText(PLAYER_GUILD, guild)
		InspectGuildText:Show()
	else
		InspectGuildText:Hide()
	end
end)

hooksecurefunc('PaperDollFrame_SetLevel', function(unit)
	local guild = GetGuildInfo('player')
	if guild then
		local PLAYER_GUILD = '<%s>'
		CharacterGuildText:SetFormattedText(PLAYER_GUILD, guild)
		CharacterGuildText:Show()
	else
		CharacterGuildText:Hide()
	end
end)

local oldInspectFrameOnUpdate = InspectFrame:GetScript('OnUpdate')
InspectFrame:SetScript('OnUpdate', function(self, ...)
	local wasVisible = UnitIsVisible(self.unit)
	local oldName, oldRealm = inspectUnitName, inspectUnitRealm
	local res = {oldInspectFrameOnUpdate(self, ...)}
	if not wasVisible
	   and oldName
	   and inspectUnitRealm
	   and not InspectFrame:IsShown()
	then
		local character = Database:getCharacter(oldName, oldRealm)
		if character then
			Ui:inspectCharacter(character, oldName, oldRealm)
		end
	end
	return unpack(res)
end)

local oldInspectFrameOnEvent = InspectFrame:GetScript('OnEvent')
InspectFrame:SetScript('OnEvent', function(self, event, ...)
	local wasShown = self:IsShown()
	local couldInspect = false
	local oldUnit = self.unit
	local oldName, oldRealm = inspectUnitName, inspectUnitRealm
	if self.unit then
		couldInspect = CanInspect(self.unit)
	end
	local res = {oldInspectFrameOnEvent(self, event, ...)}
	if wasShown
	   and (
	      (event == "PLAYER_TARGET_CHANGED" and oldUnit == "target")
	      or (event == "PARTY_MEMBERS_CHANGED" and oldUnit ~= "target")
	   )
	   and oldName
	   and oldRealm
	then
		if couldInspect then
			inspectUnitName, inspectUnitRealm = UnitName(self.unit)
			inspectUnitRealm = inspectUnitRealm or GetRealmName()
			
			local character = Database:getCharacterFromUnitId(self.unit)
			ScoreKeeper_InspectCharacterScoreFrame_Text:SetText(character:getScoreText())
		elseif not InspectFrame:IsShown() then
			local character, name, realm = Database:getCharacter(oldName, oldRealm)
			if character then
				Ui:inspectCharacter(character, name, realm)
			end
		end
	end
	return unpack(res)
end)