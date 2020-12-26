local _, class = UnitClass('player')
local specific = {}

local backdrop = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	tile = false, tileSize = 0,
	insets = {top = -1, left = -1, bottom = -1, right = -1}
}

oUF.colors.smooth = {0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.15, 0.15, 0.15}

local statusbar = 'Interface\\Addons\\oUF_Kinmeic\\media\\statusbar'
local highlight = 'Interface\\Addons\\oUF_Kinmeic\\media\\highlightTex'
local buttonbar = 'Interface\\Addons\\oUF_Kinmeic\\media\\buttonTex'
local fontNumber = 'Interface\\AddOns\\oUF_Kinmeic\\media\\numberFont.ttf'
local fontNormal = 'Fonts\\FRIZQT__.ttf'

local fontString = function(parent, name, height, style)
	local fs = parent:CreateFontString(nil, 'OVERLAY')
	fs:SetFont(name, height, style)
	fs:SetJustifyH('LEFT')
	fs:SetShadowColor(0,0,0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end

local OnMenu = function(self)
		local unit = self.unit:sub(1, -2)
		local cunit = self.unit:gsub("^%l", string.upper)

		if(cunit == 'Vehicle') then
			cunit = 'Pet'
		end

		if(unit == "party" or unit == "partypet") then
			ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
		elseif(_G[cunit.."FrameDropDown"]) then
			ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
		end
end

local PostUpdateHealth = function(health, unit, min, max)
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		local class = select(2, UnitClass(unit))
		local color = UnitIsPlayer(unit) and oUF.colors.class[class] or {0.84, 0.75, 0.65}
		
		health:SetValue(0)
		health.bg:SetVertexColor(color[1] * 0.5, color[2] * 0.5, color[3] * 0.5)
		
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5".."Offline".."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5".."Dead".."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5".."Ghost".."|r")
		end
	else
		health.bg:SetVertexColor(0.15, 0.15, 0.15)
	end
end

local PostCreateAura = function(auras, button)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	button.cd:SetReverse()
	
	button.overlay:SetTexture("Interface\\AddOns\\oUF_Kinmeic\\media\\buttonTex")
	button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -2, 2)
	button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
	button.overlay:SetTexCoord(0, 1, 0, 1)
	
	button.ButtonOverlay = button:CreateTexture(nil, 'OVERLAY')
	button.ButtonOverlay:SetPoint('TOPLEFT', -2, 2)
	button.ButtonOverlay:SetPoint('BOTTOMRIGHT', 2, -2)
	button.ButtonOverlay:SetTexture('Interface\\AddOns\\oUF_Kinmeic\\media\\buttonTex')
	button.ButtonOverlay:SetVertexColor(.5,.5,.5)
end

local PostUpdateIcon = function(icons, unit, icon, index, offset)
	local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)
	if unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle" then
		if icon.debuff then
			icon.overlay:SetVertexColor(0.69, 0.31, 0.31)
		else
			icon.overlay:SetVertexColor(0.33, 0.59, 0.33)
		end
	else
		if UnitIsEnemy("player", unit) then
			if icon.debuff then
				icon.icon:SetDesaturated(true)
			end
		end
		icon.overlay:SetVertexColor(0.84, 0.75, 0.65)
	end
end

specific.player = function(self)
	self:SetSize(230, 61)
	
	self.Health:SetHeight(30)
	self:Tag(self.Health.value, '[k:curhp]')
	
	self.Power:SetHeight(10)
	self.Power.value.frequentUpdates = 0.1
	
	if class == 'ROGUE' or class == "HUNTER" or class == "WARRIOR" then
		self:Tag(self.Power.value, '[curpp]')
	else
		self:Tag(self.Power.value, '[k:curpp]')
	end
	
	self:Tag(self.Info.value, '[raidcolor][name]|r [level] [smartclass]')
	
--	self.Castbar:SetPoint("LEFT", self, "RIGHT", 3, 0)
--	self.Castbar:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 0, 13)
	self.Castbar.Icon:SetPoint("LEFT", self.Castbar, "RIGHT", 3, 0)
	
	self.Castbar.SafeZone = self.Castbar:CreateTexture(nil,'ARTWORK')
	self.Castbar.SafeZone:SetTexture(statusbar)
	self.Castbar.SafeZone:SetVertexColor(.69,.31,.31)

	if (class == 'ROGUE' or class == 'DRUID') then
		self.ClassPower = CreateFrame('StatusBar', nil, self, 'BackdropTemplate')
		self.ClassPower:SetStatusBarTexture(statusbar)
		self.ClassPower:SetStatusBarColor(0.15, 0.15, 0.15, 0.35)
		self.ClassPower:SetBackdrop(backdrop)
		self.ClassPower:SetBackdropColor(0, 0, 0, 1)
		self.ClassPower:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -1)
		self.ClassPower:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -1)
		self.ClassPower:SetHeight(7)
		
		self.ClassPower.unit = 'player'
		
		local cpointmax = UnitPowerMax("player", 4)
		cpointmax = 5
		
		for i = 1, cpointmax do
			self.ClassPower[i] = CreateFrame("StatusBar", nil, self.ClassPower)
			self.ClassPower[i]:SetHeight(7)
			self.ClassPower[i]:SetWidth((230 - 4) / cpointmax)
			
			self.ClassPower[i]:SetStatusBarTexture(statusbar)
			self.ClassPower[i]:SetStatusBarColor(1, 1 - i * 0.25 + 0.25, 0)
			self.ClassPower[i]:SetMinMaxValues(0, 1)
			self.ClassPower[i]:SetValue(1)
			
			if(i==1) then
				self.ClassPower[i]:SetPoint("TOPLEFT", self.ClassPower, "TOPLEFT", 0, 0)
			else
				self.ClassPower[i]:SetPoint("TOPLEFT", self.ClassPower[i-1], "TOPRIGHT", 1, 0)
			end
		end
	elseif class == 'PALADIN' then
		local numMax = UnitPowerMax('player', 9)
		
		local classicon = CreateFrame("Frame", nil, self, 'BackdropTemplate')
		classicon:SetBackdrop(backdrop)
		classicon:SetBackdropColor(0, 0, 0, 1)
		classicon:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -1)
		classicon:SetSize(230, 7)
		
		for i = 1, 5 do
			classicon[i] = CreateFrame("StatusBar", nil, self)
			classicon[i]:SetStatusBarTexture(statusbar)
			classicon[i]:SetHeight(7)
			classicon[i]:SetWidth((230 - numMax + 1) / numMax)
			classicon[i].SetVertexColor = classicon[i].SetStatusBarColor
			
			if i == 1 then
				classicon[i]:SetPoint("TOPLEFT", classicon, "TOPLEFT", 0, 0)
			else
				classicon[i]:SetPoint("TOPLEFT", classicon[i - 1], "TOPRIGHT", 1, 0)
			end
		end

		self.ClassIcons = classicon
	elseif class == 'WARLOCK' then
 		local ShardsFrame = CreateFrame("Frame", nil, self, 'BackdropTemplate')
	    ShardsFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
		ShardsFrame:SetBackdrop(backdrop)
		ShardsFrame:SetBackdropColor(0, 0, 0, 1)
	    ShardsFrame:SetSize(230, 7)
		
		local totalShards = 4 -- this is the maxium number
		
		for i= 1, totalShards do
            local Shards = CreateFrame("StatusBar", nil, self)
            Shards:SetStatusBarTexture(statusbar)
           	Shards:SetHeight(7)
			Shards:SetWidth((230 - totalShards + 1) / totalShards)
            Shards:SetStatusBarColor(0.67, 51/255, 188/255)
            
            if i == 1 then
				Shards:SetPoint("TOPLEFT", ShardsFrame, "TOPLEFT", 0, 0)
			else
				Shards:SetPoint("TOPLEFT", ShardsFrame[i - 1], "TOPRIGHT", 1, 0)
			end
			
            ShardsFrame[i] = Shards
    	end
		
		self.WarlockSpecBars = ShardsFrame
	elseif class == 'SHAMAN' then
		self.Totems = CreateFrame('StatusBar', nil, self, 'BackdropTemplate')
		self.Totems:SetStatusBarTexture(statusbar)
		self.Totems:SetStatusBarColor(0.15, 0.15, 0.15, 0.35)
		self.Totems:SetBackdrop(backdrop)
		self.Totems:SetBackdropColor(0, 0, 0, 1)
		self.Totems:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -1)
		self.Totems:SetSize(230, 7)
		
		for i = 1, MAX_TOTEMS do
			self.Totems[i] = CreateFrame("StatusBar", nil, self)
			self.Totems[i]:SetStatusBarTexture(statusbar)
			self.Totems[i]:SetHeight(7)
			self.Totems[i]:SetWidth((230 - 3) / 4)
			self.Totems[i]:SetStatusBarColor(1, 1 - i * 0.33 + 0.33, 0)
			
			if i == 1 then
				self.Totems[i]:SetPoint("TOPLEFT", self.Totems, "TOPLEFT", 0, 0)
			else
				self.Totems[i]:SetPoint("TOPLEFT", self.Totems[i - 1], "TOPRIGHT", 1, 0)
			end
		end
	elseif class == 'DEATHKNIGHT' then
		self.Runes = CreateFrame('StatusBar', nil, self, 'BackdropTemplate')
		self.Runes:SetStatusBarTexture(statusbar)
		self.Runes:SetStatusBarColor(0.15, 0.15, 0.15, 0.35)
		self.Runes:SetBackdrop(backdrop)
		self.Runes:SetBackdropColor(0, 0, 0, 1)
		self.Runes:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -1)
		self.Runes:SetSize(230, 7)
		
		for i = 1, 6 do
			self.Runes[i] = CreateFrame("StatusBar", nil, self)
			self.Runes[i]:SetStatusBarTexture(statusbar)
			self.Runes[i]:SetHeight(7)
			self.Runes[i]:SetWidth((230 - 3) / 4)
			self.Runes[i]:SetStatusBarColor(1, 1 - i * 0.33 + 0.33, 0)
			
			if i == 1 then
				self.Runes[i]:SetPoint("TOPLEFT", self.Runes, "TOPLEFT", 0, 0)
			else
				self.Runes[i]:SetPoint("TOPLEFT", self.Runes[i - 1], "TOPRIGHT", 1, 0)
			end
		end
	end
end

specific.target = function(self)
	self:SetSize(230, 61)
	
	self.Health:SetHeight(30)
	self:Tag(self.Health.value, '[k:curhp]')
	
	self.Power:SetHeight(10)
	self:Tag(self.Power.value, '[curpp]')
	
	self:Tag(self.Info.value, '[raidcolor][name]|r [smartlevel] [smartclass]')
	
	self.Castbar.Icon:SetPoint("RIGHT", self.Castbar, "LEFT", -3, 0)
	
	self.Buffs = CreateFrame("Frame", nil, self)
	self.Buffs:SetHeight(23)
	self.Buffs:SetWidth(23 * 6)
	self.Buffs.size = 23
	self.Buffs.spacing = 1
	self.Buffs:SetPoint("TOPLEFT", self, "TOPRIGHT", 3, 0)
	self.Buffs.initialAnchor = "TOPLEFT"
	self.Buffs["growth-y"] = "DOWN"
	self.Buffs.PostCreateIcon = PostCreateAura
	self.Buffs.PostUpdateIcon = PostUpdateIcon
	
	self.Debuffs = CreateFrame("Frame", nil, self)
	self.Debuffs:SetHeight(23 * 0.97)
	self.Debuffs:SetWidth(230)
	self.Debuffs.size = 23 * 0.97
	self.Debuffs.spacing = 1
	self.Debuffs:SetPoint('TOPLEFT', self.Power, 'BOTTOMLEFT', 0, -3)
	self.Debuffs.initialAnchor = "TOPLEFT"
	self.Debuffs["growth-y"] = "DOWN"
	self.Debuffs.onlyShowPlayer = false
	self.Debuffs.disableCooldown = false
	self.Debuffs.PostCreateIcon = PostCreateAura
	self.Debuffs.PostUpdateIcon = PostUpdateIcon
end

specific.pet = function(self)
	self:SetSize(113, 24)

	self.Health:SetHeight(18)
	self:Tag(self.Health.value, '[k:perhp]')
	
	self.Power:SetHeight(5)
	
	self.Info = fontString(self.Health, fontNormal, 11, 'THINOUTLINE')
	self.Info:SetPoint('LEFT', 2, 1)
	self.Info:SetPoint("RIGHT", self.Health, "RIGHT" , -50, 0)
	self.Info:SetJustifyH("LEFT")
	self:Tag(self.Info, '[name]')
	
	self.Buffs = CreateFrame("Frame", nil, self)
	self.Buffs:SetHeight(24)
	self.Buffs:SetWidth(24 * 6)
	self.Buffs.size = 24
	self.Buffs.spacing = 1
	self.Buffs.num = 8
	self.Buffs.onlyShowPlayer = true
	self.Buffs:SetPoint("TOPRIGHT", self, "TOPLEFT", -9, 0)
	self.Buffs.initialAnchor = "TOPRIGHT"
	self.Buffs["growth-x"] = "LEFT"
	self.Buffs.PostCreateIcon = PostCreateAura
	self.Buffs.PostUpdateIcon = PostUpdateIcon
end

specific.targettarget = function(self)
	self:SetSize(113, 24)
	self.Health:SetHeight(18)
	self:Tag(self.Health.value, '[k:perhp]')
	
	self.Power:SetHeight(5)
	
	self.Info = fontString(self.Health, fontNormal, 11, 'THINOUTLINE')
	self.Info:SetPoint('LEFT', 2, 1)
	self.Info:SetPoint("RIGHT", self.Health, "RIGHT" , -50, 0)
	self.Info:SetJustifyH("LEFT")
	self:Tag(self.Info, '[name]')
	
	self.Debuffs = CreateFrame("Frame", nil, self)
	self.Debuffs:SetHeight(24)
	self.Debuffs:SetWidth(24 * 6)
	self.Debuffs.size = 24
	self.Debuffs.spacing = 1
	self.Debuffs.num = 8
	self.Debuffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', 9, 1)
	self.Debuffs.initialAnchor = "TOPLEFT"
	self.Debuffs["growth-y"] = "UP"
	self.Debuffs.onlyShowPlayer = false
	self.Debuffs.PostCreateIcon = PostCreateAura
	self.Debuffs.PostUpdateIcon = PostUpdateIcon
end

local OnInitialize = function(self, unit)
	self.menu = OnMenu
	self:RegisterForClicks("AnyDown")
	self:SetAttribute("*type2", "menu")
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	
	Mixin(self, BackdropTemplateMixin)
	self:SetBackdrop(backdrop)
	self:SetBackdropColor(0, 0, 0, 1)
	self:SetFrameStrata("BACKGROUND")

	-- HP Bar
	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetStatusBarTexture(statusbar)
	self.Health:GetStatusBarTexture():SetHorizTile(false)
	self.Health:SetPoint("TOPLEFT")
	self.Health:SetPoint("TOPRIGHT")
	self.Health.frequentUpdates = false
	self.Health.colorTapping = true
	self.Health.colorDisconnected = true
	self.Health.colorSmooth = true
--	self.Health.colorClass = true
--	self.Health.colorReaction = true
	self.Health.Smooth = true
	
	self.Health.bg = self.Health:CreateTexture(nil, "BACKGROUND")
	self.Health.bg:SetAllPoints()
	self.Health.bg:SetAlpha(0.20)
	self.Health.bg:SetTexture(statusbar)
	
	if unit == "player" or unit == "target" then
		self.Health.value = fontString(self.Health, fontNumber, 18, 'THINOUTLINE')
	else
		self.Health.value = fontString(self.Health, fontNumber, 12, 'THINOUTLINE')
	end
	
	self.Health.value:SetPoint('RIGHT', -1, 1)
	
	-- Power Bar
	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetStatusBarTexture(statusbar)
	self.Power:GetStatusBarTexture():SetHorizTile(false)
	self.Power:SetPoint("BOTTOMLEFT")
	self.Power:SetPoint("BOTTOMRIGHT")
--	self.Power:SetBackdropColor(0.165,0.165,0.165)
	self.Power.frequentUpdates = true
	self.Power.colorClass = true
	self.Power.colorReaction = false
	self.Power.colorTapping = true
	self.Power.colorPower = true
	self.Power.colorDisconnected = true
	self.Power.Smooth = true

	self.Power.bg = self.Power:CreateTexture(nil, "BACKGROUND")
	self.Power.bg:SetAllPoints()
	self.Power.bg:SetTexture(statusbar)
	self.Power.bg:SetAlpha(0.20)
	
	self.Power.value = fontString(self.Power, fontNumber, 10, 'THINOUTLINE')
	self.Power.value:SetPoint('RIGHT', -1, 1)
	
	self.Health.PostUpdate = PostUpdateHealth
	
	if unit == "player" or unit == "target" then
		self.Info = CreateFrame("StatusBar", nil, self)
		self.Info:SetStatusBarTexture(statusbar)
		self.Info:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -1)
		self.Info:SetPoint("BOTTOMRIGHT", self.Power, "TOPRIGHT", 0, 1)
		self.Info:SetStatusBarColor(0.25, 0.25, 0.25)
		
		self.Info.value = fontString(self.Info, fontNormal, 11, 'THINOUTLINE')
		self.Info.value:SetPoint('CENTER', 2, 1)

		self.CombatFeedbackText = fontString(self.Health, fontNormal, 18, 'OUTLINE')
		self.CombatFeedbackText:SetPoint('CENTER', 0, 0)
		

		self.Castbar = CreateFrame('StatusBar', nil, self.Info)
		self.Castbar:SetStatusBarTexture(statusbar)
		self.Castbar:GetStatusBarTexture():SetHorizTile(false)
		self.Castbar:SetStatusBarColor(1, 0.65, 0.16)
		self.Castbar:SetSize(100, 35)
		self.Castbar:SetAllPoints(self.Info)

		Mixin(self.Castbar, BackdropTemplateMixin)
		self.Castbar:SetBackdrop(backdrop)
		self.Castbar:SetBackdropColor(0, 0, 0, 1)	
		
		self.Castbar.bg = self.Castbar:CreateTexture(nil, 'BORDER')
		self.Castbar.bg:SetAllPoints(self.Castbar)
		self.Castbar.bg:SetTexture(statusbar)
		self.Castbar.bg:SetVertexColor(0.15, 0.15, 0.15, 0.8)
		
		self.Castbar.Spark = self.Castbar:CreateTexture(nil, "OVERLAY")
		self.Castbar.Spark:SetSize(2, self.Castbar:GetHeight() - 2)
		self.Castbar.Spark:SetVertexColor(1, 1, 1)
		self.Castbar.Spark:SetBlendMode("ADD")

--		self.Castbar.Text = fontString(self.Castbar, fontNormal, 12, "OUTLINE")
		self.Castbar.Text = fontString(self.Castbar, fontNormal, 12, 'THINOUTLINE')
		self.Castbar.Text:SetPoint("LEFT", self.Castbar, 2, 1)
		self.Castbar.Text:SetPoint("RIGHT", self.Castbar, "RIGHT" , 0, 0)
		self.Castbar.Text:SetTextColor(0.84, 0.75, 0.65)
		self.Castbar.Text:SetJustifyH("LEFT")
		
		self.Castbar.Time = fontString(self.Castbar, fontNormal, 12, 'THINOUTLINE')
--		self.Castbar.Time:SetPoint('BOTTOMLEFT', 2, 2)
		self.Castbar.Time:SetPoint('RIGHT', -2, 1)
		self.Castbar.Time:SetTextColor(0.84, 0.75, 0.65)
		self.Castbar.Time:SetJustifyH('RIGHT')
		
		if unit ~= "focus" then
			self.Castbar.CustomTimeText = function(_, t)
				self.Castbar.Time:SetText(("%.2f / %.2f"):format(self.Castbar.castIsChanneled and t or self.Castbar.max - t, self.Castbar.max))
			end
			self.Castbar.CustomDelayText = function(_, t)
				self.Castbar.Time:SetText(("%.2f |cFFFF5033%s%.2f|r"):format(self.Castbar.castIsChanneled and t or self.Castbar.max - t, self.Castbar.castIsChanneled and "-" or "+", self.Castbar.delay))
			end
		end
		
		self.Castbar.Icon = self.Castbar:CreateTexture(nil, 'ARTWORK')
		self.Castbar.Icon:SetHeight(42)
		self.Castbar.Icon:SetWidth(42)
		self.Castbar.Icon:SetTexCoord(0, 1, 0, 1)

		self.IconOverlay = self.Castbar:CreateTexture(nil, 'OVERLAY')
		self.IconOverlay:SetPoint('TOPLEFT', self.Castbar.Icon, 'TOPLEFT', -1, 1)
		self.IconOverlay:SetPoint('BOTTOMRIGHT', self.Castbar.Icon, 'BOTTOMRIGHT', 1, -1)
		self.IconOverlay:SetTexture(buttonbar)
		self.IconOverlay:SetVertexColor(0.25, 0.25, 0.25)
	end
	
	self.RaidIcon = self:CreateTexture(nil, "OVERLAY")
	self.RaidIcon:SetParent(self.Health)
	self.RaidIcon:SetSize(16, 16)
	self.RaidIcon:SetPoint("TOP", 0, 10)
	
	self.DebuffHighlight = self.Health:CreateTexture(nil, 'OVERLAY')
	self.DebuffHighlight:SetAllPoints(self.Health)
	self.DebuffHighlight:SetTexture('Interface\\Addons\\oUF_Kinmeic\\media\\highlightTex')
	self.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
	self.DebuffHighlight:SetBlendMode('ADD')
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightFilter = false

	if specific[unit] then
		return specific[unit](self)
	end
end


oUF:RegisterStyle('Kinmeic', OnInitialize)

oUF:Factory(function(self)
	self:SetActiveStyle('Kinmeic')
	self:Spawn("player"):SetPoint("BOTTOM", UIParent, -258.5, 269.5)
	self:Spawn("target"):SetPoint("BOTTOM", UIParent, 258.5, 269.5)
	self:Spawn("pet"):SetPoint("BOTTOMLEFT", oUF_Kinmeic_player, "TOPLEFT", 0, 13)
	self:Spawn("targettarget"):SetPoint("BOTTOMRIGHT", oUF_Kinmeic_target, "TOPRIGHT", 0, 13)
end)