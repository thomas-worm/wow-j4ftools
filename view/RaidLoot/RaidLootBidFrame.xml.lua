local GlobalAddonName, J4FT = ...

J4FT = J4FT or {}
J4FT.View = J4FT.View or {}
J4FT.View.RaidLoot = J4FT.View.RaidLoot or {}
J4FT.View.RaidLoot.RaidLootBidFrame = J4FT.View.RaidLoot.RaidLootBidFrame or {}

local RaidLootBidFrame = J4FT.View.RaidLoot.RaidLootBidFrame

-- helper functions
local function show_tooltip_with_text(self, text)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(text)
end

local function hide_tooltip()
	GameTooltip:Hide()
end

-- RaidLootBidFrame events

function RaidLootBidFrame:OnShow()
end

function RaidLootBidFrame:OnHide()
end

-- RaidLootBidFrame.IconFrame events

J4FT.View.RaidLoot.RaidLootBidFrame.IconFrame = J4FT.View.RaidLoot.RaidLootBidFrame.IconFrame or {}

function RaidLootBidFrame.IconFrame:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetItemByID(self:GetParent().item:GetItemID())
	CursorUpdate(self)
end

function RaidLootBidFrame.IconFrame:OnUpdate()
	if ( GameTooltip:IsOwned(self) ) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetItemByID(self:GetParent().item:GetItemID())
	end
	CursorOnUpdate(self)
end

function RaidLootBidFrame.IconFrame:OnLeave()
	GameTooltip:Hide()
	ResetCursor()
end

function RaidLootBidFrame.IconFrame:OnClick()
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(self:GetParent().itemID)
	HandleModifiedItemClick(itemLink)
end

-- RaidLootBidFrame.NeedButton events

J4FT.View.RaidLoot.RaidLootBidFrame.NeedButton = J4FT.View.RaidLoot.RaidLootBidFrame.NeedButton or {}

function RaidLootBidFrame.NeedButton:OnClick()
	for index, handler in pairs(self:GetParent().needClickHandlers or {}) do
        handler()
    end
end

function RaidLootBidFrame.NeedButton:OnEnter()
	show_tooltip_with_text(self, J4FT_LOOTBIDFRAME_MAINBUTTON_TEXT)
end

function RaidLootBidFrame.NeedButton:OnLeave()
	hide_tooltip()
end

-- RaidLootBidFrame.GreedButton events

J4FT.View.RaidLoot.RaidLootBidFrame.GreedButton = J4FT.View.RaidLoot.RaidLootBidFrame.GreedButton or {}

function RaidLootBidFrame.GreedButton:OnClick()
	for index, handler in pairs(self:GetParent().greedClickHandlers or {}) do
        handler()
    end
end

function RaidLootBidFrame.GreedButton:OnEnter()
	show_tooltip_with_text(self, J4FT_LOOTBIDFRAME_SECONDBUTTON_TEXT)
end

function RaidLootBidFrame.GreedButton:OnLeave()
	hide_tooltip()
end

-- RaidLootBidFrame.PassButton events

J4FT.View.RaidLoot.RaidLootBidFrame.PassButton = J4FT.View.RaidLoot.RaidLootBidFrame.PassButton or {}

function RaidLootBidFrame.PassButton:OnClick()
	for index, handler in pairs(self:GetParent().passClickHandlers or {}) do
        handler()
    end
end

function RaidLootBidFrame.PassButton:OnEnter()
	show_tooltip_with_text(self, J4FT_LOOTBIDFRAME_PASSBUTTON_TEXT)
end

function RaidLootBidFrame.PassButton:OnLeave()
	hide_tooltip()
end

----------------------------------------------------------------------------------------

function RaidLootBidFrame:new()
	local frame = CreateFrame("Frame", nil, nil, "J4FT.View.RaidLoot.RaidLootBidFrame.Template")
	local obj = J4FT.Service.Object.MixinService.Get():DeepMixin(frame, RaidLootBidFrame)
	obj.needClickHandlers = {}
	obj.greedClickHandlers = {}
	obj.passClickHandlers = {}
	obj:RegisterEvents()
	return obj
end

function RaidLootBidFrame:RegisterEvents()
	self:SetScript("OnShow", self.OnShow)
	self:SetScript("OnHide", self.OnHide)
	self.IconFrame:SetScript("OnEnter", self.IconFrame.OnEnter)
	self.IconFrame:SetScript("OnUpdate", self.IconFrame.OnUpdate)
	self.IconFrame:SetScript("OnLeave", self.IconFrame.OnLeave)
	self.IconFrame:SetScript("OnClick", self.IconFrame.OnClick)
	self.NeedButton:SetScript("OnEnter", self.NeedButton.OnEnter)
	self.NeedButton:SetScript("OnLeave", self.NeedButton.OnLeave)
	self.NeedButton:SetScript("OnClick", self.NeedButton.OnClick)
	self.GreedButton:SetScript("OnEnter", self.GreedButton.OnEnter)
	self.GreedButton:SetScript("OnLeave", self.GreedButton.OnLeave)
	self.GreedButton:SetScript("OnClick", self.GreedButton.OnClick)
	self.PassButton:SetScript("OnEnter", self.PassButton.OnEnter)
	self.PassButton:SetScript("OnLeave", self.PassButton.OnLeave)
	self.PassButton:SetScript("OnClick", self.PassButton.OnClick)
end

function RaidLootBidFrame:ResetCountdown(min, max)
	local _min, _max = self.Timer:GetMinMaxValues()
	if min then
		_min = value
	end
	if max then
		_max = value
	end
	self.Timer:SetMinMaxValues(min, max)
	self.Timer:SetValue(max)
end

function RaidLootBidFrame:SetCountdownValue(value)
	self.Timer:SetValue(value)
end

function RaidLootBidFrame:GetCountdownValue()
	return self.Timer:GetValue()
end

function RaidLootBidFrame:SetItem(item)
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item:GetItemID())

	if (itemName == nil) then
		return
	end

	self.item = item
	self.IconFrame.Icon:SetTexture(itemTexture)
	self.Name:SetText(itemName)
	local color = ITEM_QUALITY_COLORS[itemRarity]
	self.Name:SetVertexColor(color.r, color.g, color.b)
end

function RaidLootBidFrame:GetItem()
	return self.item
end

function RaidLootBidFrame:RegisterNeedClickHandler(handler)
	table.insert(self.needClickHandlers, handler)
end

function RaidLootBidFrame:RegisterGreedClickHandler(handler)
	table.insert(self.greedClickHandlers, handler)
end

function RaidLootBidFrame:RegisterPassClickHandler(handler)
	table.insert(self.passClickHandlers, handler)
end