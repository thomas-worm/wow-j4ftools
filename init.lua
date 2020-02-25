local GlobalAddonName, J4FT = ...

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
		if addonName ~= GlobalAddonName then
			return
		end
        -- Initializes saved variables
        VJ4FT = VJ4FT or {}
        VJ4FT.Addon = VJ4FT.Addon or {}
        -- Initializes saved variables per character
        VCJ4FT = VCJ4FT or {}
        VCJ4FT.Addon = VCJ4FT.Addon or {}
        -- Opening loot frame first time for initialization
        J4FTools_RaidLootBidFrame_ResetCountdown(J4FTools_RaidLootBidFrame)
        J4FTools_RaidLootBidFrame.itemID = 0
        J4FTools_RaidLootBidFrame.rollMode = "roll"
        J4FTools_RaidLootBidFrame.countdown = false
        J4FTools_RaidLootBidFrame:Show()
        J4FTools_RaidLootBidFrame:Hide()
    end
end)
