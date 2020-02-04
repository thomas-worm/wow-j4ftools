local GlobalAddonName, J4FT = ...

local MiniMapIcon = CreateFrame("Button", "J4T_MinimapIcon", Minimap)
J4FT.MiniMapIcon = MiniMapIcon
MiniMapIcon:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight") 
MiniMapIcon:SetSize(32,32) 
MiniMapIcon:SetFrameStrata("MEDIUM")
MiniMapIcon:SetFrameLevel(8)
MiniMapIcon:SetPoint("CENTER", -12, -80)
MiniMapIcon:SetDontSavePosition(true)
MiniMapIcon:RegisterForDrag("LeftButton")
MiniMapIcon.icon = MiniMapIcon:CreateTexture(nil, "BACKGROUND")
MiniMapIcon.icon:SetTexture("Interface\\AddOns\\" .. GlobalAddonName .. "\\media\\MiniMap")
MiniMapIcon.icon:SetSize(32,32)
MiniMapIcon.icon:SetPoint("CENTER", 0, 0)
MiniMapIcon.border = MiniMapIcon:CreateTexture(nil, "ARTWORK")
MiniMapIcon.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
MiniMapIcon.border:SetTexCoord(0,0.6,0,0.6)
MiniMapIcon.border:SetAllPoints()
MiniMapIcon:RegisterForClicks("anyUp")
MiniMapIcon:SetScript("OnEnter",function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_LEFT") 
	GameTooltip:AddLine(J4FT_TITLE)
	GameTooltip:AddLine(J4FT_LEFTCLICK,1,1,1) 
	GameTooltip:AddLine(J4FT_RIGHTCLICK,1,1,1) 
	GameTooltip:Show() 
end)
MiniMapIcon:SetScript("OnLeave", function(self)    
	GameTooltip:Hide()
end)

local minimapShapes = {
	["ROUND"] = {true, true, true, true},
	["SQUARE"] = {false, false, false, false},
	["CORNER-TOPLEFT"] = {false, false, false, true},
	["CORNER-TOPRIGHT"] = {false, false, true, false},
	["CORNER-BOTTOMLEFT"] = {false, true, false, false},
	["CORNER-BOTTOMRIGHT"] = {true, false, false, false},
	["SIDE-LEFT"] = {false, true, false, true},
	["SIDE-RIGHT"] = {true, false, true, false},
	["SIDE-TOP"] = {false, false, true, true},
	["SIDE-BOTTOM"] = {true, true, false, false},
	["TRICORNER-TOPLEFT"] = {false, true, true, true},
	["TRICORNER-TOPRIGHT"] = {true, false, true, true},
	["TRICORNER-BOTTOMLEFT"] = {true, true, false, true},
	["TRICORNER-BOTTOMRIGHT"] = {true, true, true, false},
}

local function IconMoveButton(self)
	if self.dragMode == "free" then
		local centerX, centerY = Minimap:GetCenter()
		local x, y = GetCursorPosition()
		x, y = x / self:GetEffectiveScale() - centerX, y / self:GetEffectiveScale() - centerY
		self:ClearAllPoints()
		self:SetPoint("CENTER", x, y)
		VCJ4FT.Addon.IconMiniMapLeft = x
		VCJ4FT.Addon.IconMiniMapTop = y
	else
		local mx, my = Minimap:GetCenter()
		local px, py = GetCursorPosition()
		local scale = Minimap:GetEffectiveScale()
		px, py = px / scale, py / scale
		
		local angle = math.atan2(py - my, px - mx)
		local x, y, q = math.cos(angle), math.sin(angle), 1
		if x < 0 then q = q + 1 end
		if y > 0 then q = q + 2 end
		local minimapShape = GetMinimapShape and GetMinimapShape() or "ROUND"
		local quadTable = minimapShapes[minimapShape]
		if quadTable[q] then
			x, y = x*80, y*80
		else
			local diagRadius = 103.13708498985 --math.sqrt(2*(80)^2)-10
			x = math.max(-80, math.min(x*diagRadius, 80))
			y = math.max(-80, math.min(y*diagRadius, 80))
		end
		self:ClearAllPoints()
		self:SetPoint("CENTER", Minimap, "CENTER", x, y)
		VCJ4FT.Addon.IconMiniMapLeft = x
		VCJ4FT.Addon.IconMiniMapTop = y
	end
end

MiniMapIcon:SetScript("OnDragStart", function(self)
	self:LockHighlight()
	self:SetScript("OnUpdate", IconMoveButton)
	self.isMoving = true
	GameTooltip:Hide()
end)
MiniMapIcon:SetScript("OnDragStop", function(self)
	self:UnlockHighlight()
	self:SetScript("OnUpdate", nil)
	self.isMoving = false
end)

MiniMapIcon:RegisterEvent("ADDON_LOADED")
MiniMapIcon:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addonName = ...
		if addonName ~= GlobalAddonName then
			return
		end
		if VCJ4FT and VCJ4FT.Addon and VCJ4FT.Addon.IconMiniMapLeft and VCJ4FT.Addon.IconMiniMapTop then
			J4FT.MiniMapIcon:ClearAllPoints()
			J4FT.MiniMapIcon:SetPoint("CENTER", VCJ4FT.Addon.IconMiniMapLeft, VCJ4FT.Addon.IconMiniMapTop)
		end
		J4FT.MiniMapIcon:Show()
	end
end)
