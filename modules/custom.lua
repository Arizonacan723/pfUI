--[[ startup code ]]--

pfUI:RegisterModule("custom", function ()
  --[[ module code ]]--
  table.insert(pfUI.gui.dropdowns["uf_texts"], "custom1:" .. T["Custom1"])

  local oldFunc = pfUI.uf.GetStatusValue
  function pfUI.uf.GetStatusValue(self, unit, pos)
    -- setup some basic variables used
    if not pos or not unit then return end
    local config = unit.config["txt"..pos]
    local unitstr = unit.label .. unit.id
    local frame = unit[pos .. "Text"]

    -- as a fallback, draw the name
    if pos == "center" and not config then
      config = "unit"
    end

    -- custom classification
    if config == "cclass" then
      if UnitIsPlayer(unitstr) and UnitIsPVP(unitstr) then
        return "|cffb62220" .. "PvP"
      elseif UnitClassification(unitstr) ~= "normal" then
        if UnitClassification(unitstr) == "rareelite" then
          return "|cffe2e1df" .. "Rare" .. "|cfff1d56b" .. "Elite"
        elseif UnitClassification(unitstr) == "elite" then
          return "|cfff1d56b" .. "Elite"
        elseif UnitClassification(unitstr) == "rare" then
          return "|cffe2e1df" .. "Rare"
        elseif UnitClassification(unitstr) == "worldboss" then
          return "|cffe32636" .. "Boss"
        end
      elseif UnitCreatureType(unitstr) == "Critter" then
        return "|cffaaaaaa" .. "Critter"
      else
        return ""
      end
    end
 
    -- run the original function
    return oldFunc(self, unit, pos)
  end

end)