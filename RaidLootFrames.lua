local GlobalAddonName, J4FT = ...

-- helper functions
local function show_tooltip_with_text(self, text)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(text)
end

local function hide_tooltip()
	GameTooltip:Hide()
end

-- RaidLootBidFrame events

function J4FTools_RaidLootBidFrame_OnShow(self)
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(self.itemID)

	if (itemName == nil) then
		self:Hide()
		return
	end
  
	self.IconFrame.Icon:SetTexture(itemTexture)
	self.Name:SetText(itemName)
	local color = ITEM_QUALITY_COLORS[itemRarity]
	self.Name:SetVertexColor(color.r, color.g, color.b)
	self.countdown = false
end

-- RaidLootBidFrame.IconFrame events

function J4FTools_RaidLootBidFrame_IconFrame_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetItemByID(self:GetParent().itemID)
	CursorUpdate(self)
end

function J4FTools_RaidLootBidFrame_IconFrame_OnUpdate(self)
	if ( GameTooltip:IsOwned(self) ) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetItemByID(self:GetParent().itemID)
	end
	CursorOnUpdate(self)
end

function J4FTools_RaidLootBidFrame_IconFrame_OnLeave(self)
	GameTooltip:Hide()
	ResetCursor()
end

function J4FTools_RaidLootBidFrame_IconFrame_OnClick(self)
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(self:GetParent().itemID)
	HandleModifiedItemClick(itemLink)
end

-- RaidLootBidFrame.NeedButton events

function J4FTools_RaidLootBidFrame_NeedButton_OnClick(self)
	if self:GetParent().rollMode == "roll" then
		RandomRoll(1, 100)
	elseif self:GetParent().rollMode == "gp" then
		SendChatMessage("main", "RAID")
	end
	self:GetParent():Hide()
end

function J4FTools_RaidLootBidFrame_NeedButton_OnEnter(self)
	show_tooltip_with_text(self, J4FT_LOOTBIDFRAME_MAINBUTTON_TEXT)
end

function J4FTools_RaidLootBidFrame_NeedButton_OnLeave(self)
	hide_tooltip()
end

-- RaidLootBidFrame.GreedButton events

function J4FTools_RaidLootBidFrame_GreedButton_OnClick(self)
	if self:GetParent().rollMode == "roll" then
		RandomRoll(1, 99)
	elseif self:GetParent().rollMode == "gp" then
		SendChatMessage("second", "RAID")
	end
	self:GetParent():Hide()
end

function J4FTools_RaidLootBidFrame_GreedButton_OnEnter(self)
	show_tooltip_with_text(self, J4FT_LOOTBIDFRAME_SECONDBUTTON_TEXT)
end

function J4FTools_RaidLootBidFrame_GreedButton_OnLeave(self)
	hide_tooltip()
end

-- RaidLootBidFrame.PassButton events

function J4FTools_RaidLootBidFrame_PassButton_OnClick(self)
	self:GetParent():Hide()
end

function J4FTools_RaidLootBidFrame_PassButton_OnEnter(self)
	show_tooltip_with_text(self, J4FT_LOOTBIDFRAME_PASSBUTTON_TEXT)
end

function J4FTools_RaidLootBidFrame_PassButton_OnLeave(self)
	hide_tooltip()
end

-- RaidLootBidFrame Timer events

function J4FTools_RaidLootBidFrame_SetCountdownTime(self, value)
	self.remainingTime = value
	self.Timer:SetMinMaxValues(0, value)
end

function J4FTools_RaidLootBidFrame_StartCountdown(self)
	self.countdown = true
end

function J4FTools_RaidLootBidFrame_Timer_OnUpdate(self, elapsed)
	local elapsedMilliseconds = elapsed * 1000;
	local countdown = self:GetParent().countdown
	if countdown then
		local currentValue = self:GetParent().remainingTime
		local newValue = currentValue - elapsedMilliseconds
		if (newValue < 0) then
			self:GetParent().remainingTime = 0
			self:GetParent():Hide()
		else
			self:GetParent().remainingTime = newValue
			self:SetValue(newValue)
		end
	end
end
