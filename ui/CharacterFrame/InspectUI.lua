UIPanelWindows["ScoreKeeper_InspectFrame"] = { area = "left", pushable = 0 }

function ScoreKeeper_InspectFrame_OnLoad(self)
	self.character = nil
	self.characterName = nil
	self.characterRealm = nil

	-- Tab Handling code
	PanelTemplates_SetNumTabs(self, 1);
	PanelTemplates_SetTab(self, 1);
end

function ScoreKeeper_InspectFrame_OnShow(self)
	if not self.character then
		return
	end
	PlaySound("igCharacterInfoOpen")	
	ScoreKeeper_InspectNameText:SetText(self.characterName)
end

function ScoreKeeper_InspectFrame_OnHide(self)
	self.character = nil
	self.characterName = nil
	self.characterRealm = nil
	PlaySound("igCharacterInfoClose")
end