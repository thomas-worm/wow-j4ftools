local GlobalAddonName, J4FT = ...

J4FT = J4FT or {}
J4FT.Controller = J4FT.Controller or {}
J4FT.Controller.RaidLoot = J4FT.Controller.RaidLoot or {}
J4FT.Controller.RaidLoot.RaidLootController = J4FT.Controller.RaidLoot.RaidLootController or {}

local RaidLootController = J4FT.Controller.RaidLoot.RaidLootController

----------------------------
-- Raid Loot Controller    -
----------------------------

function RaidLootController:OnRaidWarning(msg)
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
			if (mode == "roll") then
				self:StartRoll(item)
			elseif (mode == "gp") then
				self:StartGP(item)
			end
		end
	end
	if mode and (mode == "end") then
		if itemLink == "roll" or itemLink == "gp" then
			if self.active then
				self.countdownRemainingTime = 5000
				self.bidFrame:ResetCountdown(0, self.countdownRemainingTime)
				self.countdownActive = true
			else
				print "No loot in progress!"
			end
		end
	end
end

function RaidLootController:OnNeedClick()
	if self.rollMode == "roll" then
		RandomRoll(1, 100)
	elseif self.rollMode == "gp" then
		SendChatMessage("main", "RAID")
	end
	self.bidFrame:Hide()
end

function RaidLootController:OnGreedClick()
	if self.rollMode == "roll" then
		RandomRoll(1, 99)
	elseif self.rollMode == "gp" then
		SendChatMessage("second", "RAID")
	end
	self.bidFrame:Hide()
end

function RaidLootController:OnPassClick()
	self.bidFrame:Hide()
end

function RaidLootController:OnUpdate(elapsed)
	if self.countdownActive then
		local elapsedMilliseconds = elapsed * 1000
		local newValue = self.countdownRemainingTime - elapsedMilliseconds
		if newValue < 0 then
			self.countdownRemainingTime = 0
			self.countdownActive = false
			self.active = false
			self.bidFrame:Hide()
		else
			self.countdownRemainingTime = newValue
			self.bidFrame:SetCountdownValue(newValue)
		end
	end
end

function RaidLootController:new(controllers, views)
	local obj = J4FT.Service.Object.MixinService.Get():DeepMixin({}, RaidLootController)
	obj.active = false
	obj.rollMode = "roll"
	obj.bidFrame = views["RaidLootBidFrame"]
	obj.bidFrame:RegisterNeedClickHandler(function ()
		obj:OnNeedClick()
	end)
	obj.bidFrame:RegisterGreedClickHandler(function ()
		obj:OnGreedClick()
	end)
	obj.bidFrame:RegisterPassClickHandler(function ()
		obj:OnPassClick()
	end)
	obj.summaryFrame = views["RaidLootSummaryFrame"]
	obj.chatController = controllers["ChatController"]
	obj.chatController:RegisterRaidWarningHandler(function (...)
		obj:OnRaidWarning(...)
	end)
	obj.eventFrame = CreateFrame("Frame")
	obj.eventFrame:SetScript("OnUpdate", function (x, ...)
		obj:OnUpdate(...)
	end)
	return obj
end

function RaidLootController:StartRoll(item)
	self:StartLoot("roll", item)
end

function RaidLootController:StartGP(item)
	self:StartLoot("gp", item)
end

function RaidLootController:StartLoot(mode, item)
	if self.active then
		print "Currenctly ano ther loot in progress!"
	else
		self.active = true
		self.rollMode = mode
		self.bidFrame:ResetCountdown(0, 5000)
		self.bidFrame:SetItem(item)
		self.bidFrame.countdown = false
		self.bidFrame:Show()
		--self.summaryFrame:SetBidFrame(self.bidFrame)
		--self.summaryFrame:Show()
	end
end
