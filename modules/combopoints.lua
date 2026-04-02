pfUI:RegisterModule("combopoints", "vanilla:tbc", function ()
  local rawborder, border = GetBorderSize()

  -- Hide Blizzard combo point frame and unregister all events to prevent it from popping up again
  ComboFrame:Hide()
  ComboFrame:UnregisterAllEvents()

  local _, class = UnitClass("player")
  local combo_width = C["unitframes"]["combowidth"]
  local combo_height = C["unitframes"]["comboheight"]
  pfUI.combopoints = {}
  -- new variables CPbackdrop, CPring, CPspark
  pfUI.CPbackdrop = {}
  pfUI.CPring = {}
  pfUI.CPspark = {}

  for point = 1, 5 do
    pfUI.combopoints[point] = CreateFrame("Frame", "pfCombo" .. point, UIParent)
    -- pfUI.combopoints[point]:SetFrameStrata("HIGH")
    pfUI.combopoints[point]:SetWidth(combo_width)
    pfUI.combopoints[point]:SetHeight(combo_height)
    pfUI.combopoints[point]:Hide()
	
    -- create frames for CPbackdrop, CPring, CPspark
    pfUI.CPbackdrop[point] = CreateFrame("Frame", "pfCPbackdrop" .. point, UIParent)
    pfUI.CPbackdrop[point]:SetWidth(combo_width)
    pfUI.CPbackdrop[point]:SetHeight(combo_height)
    pfUI.CPbackdrop[point]:Hide()

    pfUI.CPring[point] = CreateFrame("Frame", "pfCPring" .. point, UIParent)
    pfUI.CPring[point]:SetWidth(combo_width+2)
    pfUI.CPring[point]:SetHeight(combo_height+2)
    pfUI.CPring[point]:Hide()

    pfUI.CPspark[point] = CreateFrame("Frame", "pfCPspark" .. point, UIParent)
    pfUI.CPspark[point]:SetWidth(combo_width-8)
    pfUI.CPspark[point]:SetHeight(combo_height-5)
    pfUI.CPspark[point]:Hide()

    if pfUI.uf.target then
      pfUI.combopoints[point]:SetPoint("TOPLEFT", pfUI.uf.target, "TOPRIGHT", border*3, -(point - 1) * (combo_height + border*3))
    else
      pfUI.combopoints[point]:SetPoint("CENTER", UIParent, "CENTER", (point - 3) * (combo_width + border*3), 10 )
    end
    
    -- set locations for CPbackdrop, CPring, CPspark relative to combopoints frames
    pfUI.CPbackdrop[point]:SetPoint("CENTER", "pfCombo" .. point, "CENTER", 0, 0)
    pfUI.CPring[point]:SetPoint("CENTER", "pfCombo" .. point, "CENTER", 0, 0)
    pfUI.CPspark[point]:SetPoint("CENTER", "pfCombo" .. point, "CENTER", -1.5, 1)

    pfUI.combopoints[point].tex = pfUI.combopoints[point]:CreateTexture("BACKGROUND")
    pfUI.combopoints[point].tex:SetAllPoints(pfUI.combopoints[point])
    -- new texture for combopoint from ModifiedPowerAuras
    pfUI.combopoints[point].tex:SetTexture("Interface\\AddOns\\ModifiedPowerAuras\\Auras\\Aura45")
    
    -- set textures for CPbackdrop, CPring, CPspark
    pfUI.CPbackdrop[point].tex = pfUI.CPbackdrop[point]:CreateTexture("BACKGROUND")
    pfUI.CPbackdrop[point].tex:SetAllPoints(pfUI.CPbackdrop[point])
    pfUI.CPbackdrop[point].tex:SetTexture("Interface\\AddOns\\ModifiedPowerAuras\\Auras\\Aura72")
    pfUI.CPbackdrop[point].tex:SetVertexColor(0, 0, 0, .5)

    pfUI.CPring[point].tex = pfUI.CPring[point]:CreateTexture("BORDER")
    pfUI.CPring[point].tex:SetAllPoints(pfUI.CPring[point])
    pfUI.CPring[point].tex:SetTexture("Interface\\AddOns\\ModifiedPowerAuras\\Auras\\Aura73")

    pfUI.CPspark[point].tex = pfUI.CPspark[point]:CreateTexture("BORDER")
    pfUI.CPspark[point].tex:SetAllPoints(pfUI.CPspark[point])
    pfUI.CPspark[point].tex:SetTexture("Interface\\AddOns\\ModifiedPowerAuras\\Auras\\Aura22")
    pfUI.CPspark[point].tex:SetBlendMode("ADD")

    UpdateMovable(pfUI.combopoints[point])
	  -- no backdrop/shadow
    -- CreateBackdrop(pfUI.combopoints[point])
    -- CreateBackdropShadow(pfUI.combopoints[point])
  end

  function pfUI.combopoints:DisplayNum(num)
    -- set color for combopoints and CPspark based on number of combopoints (yellow -> red)
	  if num == 1 then
	  for point=1, num do
      pfUI.combopoints[point].tex:SetVertexColor(1, .851, 0, 1)
      pfUI.CPspark[point].tex:SetVertexColor(.5, .5, .5, .8)
    end
    elseif num == 2 then
      for point=1, num do
        pfUI.combopoints[point].tex:SetVertexColor(.961, .671, 0, 1)
		    pfUI.CPspark[point].tex:SetVertexColor(.55, .55, .55, .85)
      end
    elseif num == 3 then
      for point=1, num do
        pfUI.combopoints[point].tex:SetVertexColor(.902, .490, 0, 1)
		    pfUI.CPspark[point].tex:SetVertexColor(.6, .6, .6, .9)
      end
	  elseif num == 4 then
	    for point=1, num do
        pfUI.combopoints[point].tex:SetVertexColor(.820, .306, 0, 1)
		    pfUI.CPspark[point].tex:SetVertexColor(.65, .65, .65, .95)
      end
	  elseif num == 5 then
	    for point=1, num do
        pfUI.combopoints[point].tex:SetVertexColor(.718, .043, .055, 1)
        pfUI.CPspark[point].tex:SetVertexColor(.7, .7, .7, 1)
      end
  	end

	  if UnitCanAttack("player", "target") and UnitIsDead("target") == nil then
      -- show and color ACTIVE combo points
      for point=1, num do
        pfUI.combopoints[point]:Show()
  	    pfUI.CPbackdrop[point]:Hide()
        pfUI.CPring[point].tex:SetVertexColor(.66, .66, .66, .95)
        pfUI.CPring[point]:Show()
        pfUI.CPspark[point]:Show()
      end
  	  -- show and color INACTIVE combo points
      for point=num+1, 5 do
        pfUI.combopoints[point]:Hide()
  	    pfUI.CPbackdrop[point]:Show()
        pfUI.CPring[point].tex:SetVertexColor(.33, .33, .33, .8)
        pfUI.CPring[point]:Show()
        pfUI.CPspark[point]:Hide()
      end
  	else
	    -- hide everything if no target or target is dead
  	  for point=1, 5 do
  	    pfUI.combopoints[point]:Hide()
  	    pfUI.CPbackdrop[point]:Hide()
        pfUI.CPring[point]:Hide()
        pfUI.CPspark[point]:Hide()
      end
  	end
  end

  -- combo
  if class == "DRUID" or class == "ROGUE" then
    local combo = CreateFrame("Frame")
    combo:RegisterEvent("UNIT_COMBO_POINTS")
    combo:RegisterEvent("PLAYER_COMBO_POINTS")
    combo:RegisterEvent("PLAYER_TARGET_CHANGED")
    combo:RegisterEvent("PLAYER_ENTERING_WORLD")
    combo:SetScript("OnEvent", function()
      pfUI.combopoints:DisplayNum(GetComboPoints("target"))
    end)

  -- reck
  elseif class == "PALADIN" then
    local reck = CreateFrame("Frame")
    reck:RegisterEvent("CHARACTER_POINTS_CHANGED")
    reck:RegisterEvent("PLAYER_DEAD")
    reck:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
    reck:RegisterEvent("CHAT_MSG_COMBAT_SELF_CRITS")
    reck:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
    reck:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS")
    reck:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS")

    local COMBATHITCRITOTHERSELF = SanitizePattern(COMBATHITCRITOTHERSELF)
    local COMBATHITCRITSCHOOLOTHERSELF = SanitizePattern(COMBATHITCRITSCHOOLOTHERSELF)

    reck:SetScript("OnEvent", function()
      if not this.rank or event == "CHARACTER_POINTS_CHANGED" then
        _,_,_,_,this.rank = GetTalentInfo(2,13)
      end

      if event == "PLAYER_DEAD" or event == "CHAT_MSG_COMBAT_SELF_HITS" or event == "CHAT_MSG_COMBAT_SELF_CRITS" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
        this.stacks = 0
        pfUI.combopoints:DisplayNum(0)
      elseif arg1 and this.rank and this.rank == 5 and this.stacks and this.stacks < 4 then
        if strfind(arg1, COMBATHITCRITOTHERSELF) or strfind(arg1, COMBATHITCRITSCHOOLOTHERSELF) then
          this.stacks = this.stacks + 1
          pfUI.combopoints:DisplayNum(this.stacks)
        end
      end
    end)
  end
end)
