local GlobalAddonName, J4FT = ...

J4FT = J4FT or {}
J4FT.View = J4FT.View or {}
J4FT.View.RaidLoot = J4FT.View.RaidLoot or {}
J4FT.View.RaidLoot.RaidLootSummaryFrame = J4FT.View.RaidLoot.RaidLootSummaryFrame or {}

local RaidLootSummaryFrame = J4FT.View.RaidLoot.RaidLootSummaryFrame

function RaidLootSummaryFrame:OnShow()
    if self.bidFrame then
        self:SetPoint("TOP", self.bidFrame, "BOTTOM")
    end
end

function RaidLootSummaryFrame:new()
    local frame = CreateFrame("Frame", nil, nil, "J4FT.View.RaidLoot.RaidLootSummaryFrame.Template")
    local obj = J4FT.Service.Object.MixinService.Get():DeepMixin(frame, RaidLootSummaryFrame)
    obj.bidFrame = nil
    obj:RegisterEvents()
	return obj
end

function RaidLootSummaryFrame:RegisterEvents()
    self:SetScript("OnShow", self.OnShow)
end

function RaidLootSummaryFrame:SetBidFrame(frame)
    self.bidFrame = frame
end

function RaidLootSummaryFrame:GetBidFrame()
    return self.bidFrame
end