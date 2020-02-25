local GlobalAddonName, J4FT = ...

local function starts_with(str, start)
	return str:sub(1, #start) == start
end

function J4FTools_ChatListener_OnRaidWarning(self, event, msg)
	if event == "CHAT_MSG_RAID_WARNING" then
		local trimmedMsg = msg:trim()
		local mode, id = trimmedMsg:match("^([A-Za-z]*)%s[A-za-z0-9:|]-|Hitem:([0-9]+):[A-Za-z0-9:|]-|")
		if mode and (mode == "roll" or mode == "gp") then
			if id == nil then
				print "Item not recognized!"
			else
				if J4FTools_RaidLootBidFrame.active then
					print "Currenctly another loot in progress!"
				else
					J4FTools_RaidLootBidFrame_ResetCountdown(J4FTools_RaidLootBidFrame)
					J4FTools_RaidLootBidFrame.itemID = id
					J4FTools_RaidLootBidFrame.rollMode = mode
					J4FTools_RaidLootBidFrame.countdown = false
					J4FTools_RaidLootBidFrame:Show()
				end
			end
		end
		if starts_with(msg, "end roll") or starts_with(msg, "end gp") then
			if J4FTools_RaidLootBidFrame.active then
				J4FTools_RaidLootBidFrame_SetCountdownTime(J4FTools_RaidLootBidFrame, 5000)
				J4FTools_RaidLootBidFrame_StartCountdown(J4FTools_RaidLootBidFrame)
			else
				print "No loot in progress!"
			end
		end
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("CHAT_MSG_RAID_WARNING")
eventFrame:SetScript("OnEvent", J4FTools_ChatListener_OnRaidWarning)
