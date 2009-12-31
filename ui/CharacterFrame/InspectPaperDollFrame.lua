function ScoreKeeper_InspectModelFrame_OnUpdate(self, elapsedTime)
	if ( ScoreKeeper_InspectModelRotateLeftButton:GetButtonState() == "PUSHED" ) then
		self.rotation = self.rotation + (elapsedTime * 2 * PI * ROTATIONS_PER_SECOND)
		if ( self.rotation < 0 ) then
			self.rotation = self.rotation + (2 * PI)
		end
		ScoreKeeper_InspectModelFrame:SetRotation(self.rotation)
	end
	if ( ScoreKeeper_InspectModelRotateRightButton:GetButtonState() == "PUSHED" ) then
		self.rotation = self.rotation - (elapsedTime * 2 * PI * ROTATIONS_PER_SECOND)
		if ( self.rotation > (2 * PI) ) then
			self.rotation = self.rotation - (2 * PI)
		end
		ScoreKeeper_InspectModelFrame:SetRotation(self.rotation)
	end
end

function ScoreKeeper_InspectModelFrame_OnLoad(self)
	self.rotation = 0.61
	ScoreKeeper_InspectModelFrame:SetRotation(self.rotation)
end

function ScoreKeeper_InspectModelRotateLeftButton_OnClick()
	ScoreKeeper_InspectModelFrame.rotation = ScoreKeeper_InspectModelFrame.rotation - 0.03
	ScoreKeeper_InspectModelFrame:SetRotation(ScoreKeeper_InspectModelFrame.rotation)
	PlaySound("igInventoryRotateCharacter")
end

function ScoreKeeper_InspectModelRotateRightButton_OnClick()
	ScoreKeeper_InspectModelFrame.rotation = ScoreKeeper_InspectModelFrame.rotation + 0.03
	ScoreKeeper_InspectModelFrame:SetRotation(ScoreKeeper_InspectModelFrame.rotation)
	PlaySound("igInventoryRotateCharacter")
end

function ScoreKeeper_InspectPaperDollFrame_SetLevel()
	local character = ScoreKeeper_InspectFrame.character
	local level = character:getLevel()
	if ( not level or level == -1 ) then
		level = "??"
	end
	ScoreKeeper_InspectLevelText:SetFormattedText(PLAYER_LEVEL, level, character:getLocalizedRace(), character:getLocalizedClass())
	
	local guild = character:getGuild()
	if guild then
		local PLAYER_GUILD = '<%s>'
		ScoreKeeper_InspectGuildText:SetFormattedText(PLAYER_GUILD, guild)
		ScoreKeeper_InspectGuildText:Show()
	else
		ScoreKeeper_InspectGuildText:Hide()
	end
end

function ScoreKeeper_InspectPaperDollFrame_OnShow()
	ScoreKeeper_InspectModelFrame:SetUnit('player')
	ScoreKeeper_InspectModelFrame:Undress()
	ScoreKeeper_InspectPaperDollFrame_SetLevel()
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectHeadSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectNeckSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectShoulderSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectBackSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectChestSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectShirtSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectTabardSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectWristSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectHandsSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectWaistSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectLegsSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectFeetSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectFinger0Slot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectFinger1Slot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectTrinket0Slot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectTrinket1Slot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectMainHandSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectSecondaryHandSlot)
	ScoreKeeper_InspectPaperDollItemSlotButton_Update(ScoreKeeper_InspectRangedSlot)
end

function ScoreKeeper_InspectPaperDollItemSlotButton_OnLoad(self)
	local name = self:GetName()
	self.slotName = strsub(name, 20)
	local id, textureName, checkRelic = GetInventorySlotInfo(self.slotName)
	self:SetID(id)
	local texture = _G[name.."IconTexture"]
	texture:SetTexture(textureName)
	self.backgroundTextureName = textureName
	self.checkRelic = checkRelic
end

function ScoreKeeper_InspectPaperDollItemSlotButton_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	local set = false
	local character = ScoreKeeper_InspectFrame.character
	if character then
		local item = character:getItem(self.slotName)
		if item then
			local link = ScoreKeeper.ItemObject.getLink(item, character:getLevel())
			if link then
				GameTooltip:SetHyperlink(link)
				set = true
			end
		end
	end
	
	if not set then
		local text = _G[strupper(self.slotName)]
		if self.checkRelic and character:hasRelicSlot() then
			text = _G["RELICSLOT"]
		end
		GameTooltip:SetText(text)
	end
	CursorUpdate(self)
end

function ScoreKeeper_InspectPaperDollItemSlotButton_Update(button)
	local character = ScoreKeeper_InspectFrame.character
	if not character then
		return
	end
	local slotName = button.slotName
	local item = character:getItem(slotName)
	if not item then
		if button.checkRelic and character:hasRelicSlot() then
			textureName = "Interface\\Paperdoll\\UI-PaperDoll-Slot-Relic.blp"
		end
		SetItemButtonTexture(button, button.backgroundTextureName)
		SetItemButtonCount(button, 0)
		button.hasItem = false
	else
		ScoreKeeper_InspectModelFrame:TryOn(ScoreKeeper.ItemObject.getLink(item, character:getLevel()))
		SetItemButtonTexture(button, ScoreKeeper.ItemObject.getIcon(item))
		SetItemButtonCount(button, 1)
		button.hasItem = true
	end
	if GameTooltip:IsOwned(button) then
		if button.hasItem then
			local link = ScoreKeeper.ItemObject.getLink(item, character:getLevel())
            if not link then
				GameTooltip:SetText(_G[strupper(slotName)])
			else
				GameTooltip:SetHyperlink(link)
			end
		else
			GameTooltip:Hide()
		end
	end
end
