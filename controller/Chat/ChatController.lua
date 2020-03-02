local GlobalAddonName, J4FT = ...

J4FT = J4FT or {}
J4FT.Controller = J4FT.Controller or {}
J4FT.Controller.Chat = J4FT.Controller.Chat or {}
J4FT.Controller.Chat.ChatController = J4FT.Controller.Chat.ChatController or {}

local ChatController = J4FT.Controller.Chat.ChatController

local function starts_with(str, start)
	return str:sub(1, #start) == start
end

function ChatController:OnRaidWarning(...)
    for index, handler in pairs(self.raidWarningHandlers or {}) do
        handler(...)
    end
end

function ChatController:RegisterRaidWarningHandler(handler)
    table.insert(self.raidWarningHandlers,handler)
end

function ChatController:OnSay(...)
    for index, handler in pairs(self.sayHandlers or {}) do
        handler(...)
    end
end

function ChatController:RegisterSayHandler(handler)
    table.insert(self.sayHandlers,handler)
end

function ChatController:OnEvent(event, ...)
    if event == "CHAT_MSG_RAID_WARNING" then
        self:OnRaidWarning(...)
    elseif event == "CHAT_MSG_SAY" then
        self:OnSay(...)
    end
end

function ChatController:new()
    local obj = J4FT.Service.Object.MixinService.Get():DeepMixin({}, ChatController)
    obj.raidWarningHandlers = {}
    obj.sayHandlers = {}
    obj.eventFrame = CreateFrame("Frame")
    obj.eventFrame:RegisterEvent("CHAT_MSG_RAID_WARNING")
    obj.eventFrame:RegisterEvent("CHAT_MSG_SAY")
    obj.eventFrame:SetScript("OnEvent", function(self, ...)
        obj:OnEvent(...)
    end)
	return obj
end

function J4FTools_ChatListener_OnRaidWarning(self, event, msg)
	if event == "CHAT_MSG_RAID_WARNING" then
		local trimmedMsg = msg:trim()
		local mode, itemLink, tail = strsplit(" ", msg:trim(), 3)
		local item = nil
		if (type(itemLink) == "string") then
			item = Item:CreateFromItemLink(itemLink)
		end
		if mode and (mode == "roll" or mode == "gp") then
			if item == nil then
				print "Item not recognized!"
			else
				if J4FT.Loot.BidFrame:IsActive() then
					print "Currenctly another loot in progress!"
				else
					J4FT.Loot.BidFrame:Show(mode, item)
				end
			end
		end
		if starts_with(msg, "end roll") or starts_with(msg, "end gp") then
			if J4FT.Loot.BidFrame:IsActive() then
				J4FT.Loot.BidFrame:Hide(5000)
			else
				print "No loot in progress!"
			end
		end
    end
end
