local GlobalAddonName, J4F = ...

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
	SendChatMessage("main", "RAID")
	self:GetParent():Hide()
end

function J4FTools_RaidLootBidFrame_NeedButton_OnEnter(self)
	show_tooltip_with_text(self, "Main")
end

function J4FTools_RaidLootBidFrame_NeedButton_OnLeave(self)
	hide_tooltip()
end

-- RaidLootBidFrame.GreedButton events

function J4FTools_RaidLootBidFrame_GreedButton_OnClick(self)
	SendChatMessage("second", "RAID")
	self:GetParent():Hide()
end

function J4FTools_RaidLootBidFrame_GreedButton_OnEnter(self)
	show_tooltip_with_text(self, "Second")
end

function J4FTools_RaidLootBidFrame_GreedButton_OnLeave(self)
	hide_tooltip()
end

-- RaidLootBidFrame.PassButton events

function J4FTools_RaidLootBidFrame_PassButton_OnClick(self)
	self:GetParent():Hide()
end

function J4FTools_RaidLootBidFrame_PassButton_OnEnter(self)
	show_tooltip_with_text(self, "Pass")
end

function J4FTools_RaidLootBidFrame_PassButton_OnLeave(self)
	hide_tooltip()
end