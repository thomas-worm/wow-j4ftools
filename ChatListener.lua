local GlobalAddonName, J4FT = ...

local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function starts_with(str, start)
	return str:sub(1, #start) == start
end

local function get_itemid_from_rollmsg(msg)
	local replaced = (msg:gsub("^roll%s*|(.-)item:(.-):(.-)|(.*)$", "%2"))
	if replaced == msg then
		return nil
	else
		return replaced
	end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("CHAT_MSG_RAID_WARNING")
eventFrame:SetScript("OnEvent", function(self, event, msg)
	if event == "CHAT_MSG_RAID_WARNING" then
		local trimmedMsg = trim(msg)
		if starts_with(msg, "roll") then
			local id = get_itemid_from_rollmsg(msg)
			if id == nil then
				print "Item not recognized!"
			else
				J4FTools_RaidLootBidFrame.itemID = id
				J4FTools_RaidLootBidFrame:Show()
			end
		end
		if starts_with(msg, "end roll") then
			J4FTools_RaidLootBidFrame:Hide()
		end
    end
end)
