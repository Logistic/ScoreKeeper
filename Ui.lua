setfenv(1, ScoreKeeper)
Ui = {}

function Ui:updateCharacter(character, name, realm)
	realm = realm or GetRealmName()
	if ScoreKeeper_InspectFrame:IsShown()
	   and ScoreKeeper_InspectFrame.characterName == name
	   and ScoreKeeper_InspectFrame.characterRealm == realm
	then
		ScoreKeeper_InspectFrame.character = character
		ScoreKeeper_InspectFrame:GetScript('OnShow')(ScoreKeeper_InspectFrame)
	end
end

function Ui:inspectCharacter(character, name, realm)
	if name then
		local playerName, playerRealm = UnitName('player')
		playerRealm = playerRealm or GetRealmName()
		if name == 'playerName' and realm == playerRealm then
			self:showPlayer()
		else
			local targetName, targetRealm = UnitName('target')
			targetRealm = targetRealm or GetRealmName()
			if not UnitIsDeadOrGhost('player') and CanInspect('target')  and name == targetName and realm == targetRealm then
				InspectUnit('target')
			else
				self:showCharacter(character, name, realm)
			end
		end
	end
end

function Ui:showPlayer()
	ShowUIPanel(CharacterFrame)
	if not PaperDollFrame:IsShown() then
		PanelTemplates_Tab_OnClick(CharacterFrameTab1, CharacterFrame)
		CharacterFrameTab_OnClick(CharacterFrameTab1, CharacterFrameTab1)
	end
end

function Ui:showCharacter(character, name, realm)
	realm = realm or GetRealmName()
	
	HideUIPanel(ScoreKeeper_InspectFrame)
	ScoreKeeper_InspectFrame.character = character
	ScoreKeeper_InspectFrame.characterName = name
	ScoreKeeper_InspectFrame.characterRealm = realm
	SetPortraitToTexture(ScoreKeeper_InspectFramePortrait, character:getPortraitTexture())
	ScoreKeeper_SKInspectCharacterScoreFrame_Text:SetText(character:getScoreText())
	ShowUIPanel(ScoreKeeper_InspectFrame)
end