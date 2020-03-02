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

        -- Create View
        local raidLootBidFrame = J4FT.View.RaidLoot.RaidLootBidFrame:new()
        local raidLootSummaryFrame = J4FT.View.RaidLoot.RaidLootSummaryFrame:new()

        -- Create Controllers
        local chatController = J4FT.Controller.Chat.ChatController:new()
        local raidLootController = J4FT.Controller.RaidLoot.RaidLootController:new({["ChatController"] = chatController }, { ["RaidLootBidFrame"] = raidLootBidFrame, ["RaidLootSummaryFrame"] = raidLootSummaryFrame })
    end
end)
