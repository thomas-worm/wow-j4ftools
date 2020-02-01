local GlobalAddonName, J4F = ...

function J4FTools_RaidLootBidFrame_OnShow(self)
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(self.itemID)
	if (itemName == nil) then
		J4FTools_RaidLootBidFrame:Hide()
		return;
  end
  
  self.IconFrame.Icon:SetTexture(itemTexture);
	self.Name:SetText(itemName);
	local color = ITEM_QUALITY_COLORS[itemRarity];
	self.Name:SetVertexColor(color.r, color.g, color.b);
end
