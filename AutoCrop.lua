if not AutoCropDB then
    AutoCropDB = { enabled = true, legacyMode = false, gasHelm = true, button = false, trinketSlot = true, buttonScale = 1.0, updateInterval = 0.2, version = "1.4.1" }
end

local timer = AutoCropDB.updateInterval

local f = CreateFrame("Frame")
  f:RegisterEvent('PLAYER_LOGIN')
  f:RegisterEvent('BAG_UPDATE')
  f:RegisterEvent('ADDON_LOADED')
f:SetScript("OnUpdate", function(self, elapsed)
  timer = timer - elapsed
  if(timer > 0) then return end
  if(not AutoCropDB.enabled or InCombatLockdown() or UnitIsDeadOrGhost("player")) then return end
  local inInstance, instanceType = IsInInstance()
  if(IsMounted() and not UnitOnTaxi("player") and (C_SummonInfo.GetSummonConfirmTimeLeft() == 0) and (not inInstance or instanceType == "pvp")) then
    if(not AutoCropDB.legacyMode) then
      --crop upper
      if(not AutoCropDB.trinketSlot) then
        local itemId = GetInventoryItemID("player", 13)
        if(itemId) then
          if(itemId ~= 25653) then
            AutoCropDB.trinketId = itemId
            EquipItemByName(25653, 13)
          end
        else
          EquipItemByName(25653, 13)
        end
      else
        --crop lower
        local itemId = GetInventoryItemID("player", 14)
        if(itemId) then
          if(itemId ~= 25653) then
            AutoCropDB.trinketId = itemId
            EquipItemByName(25653, 14)
          end
        else
          EquipItemByName(25653, 14)
        end
      end
      --Gas Helmet
      if(AutoCropDB.gasHelm and not IsResting() and instanceType ~= "pvp") then
        local itemId2 = GetInventoryItemID("player", 1)
        if(itemId2) then
          if(itemId2 ~= 23762) then
          AutoCropDB.gasHelmId = itemId2
          EquipItemByName(23762, 1)
          end
        else
          EquipItemByName(23762, 1)
        end
      end
      if(IsResting() or instanceType == "pvp") then
        if(AutoCropDB.gasHelm) then
          local itemId2 = GetInventoryItemID("player", 1)
          if(itemId2 and AutoCropDB.gasHelm) then
            if(itemId2 ~= 23762) then
              AutoCropDB.gasHelmId = itemId2
            elseif(AutoCropDB.gasHelmId) then
              EquipItemByName(AutoCropDB.gasHelmId, 1)
            end
          end
        end
      end
    else
      --carrot upper
      if(not AutoCropDB.trinketSlot) then
        local itemId = GetInventoryItemID("player", 13)
        if(itemId) then
          if(itemId ~= 11122) then
            AutoCropDB.trinketId = itemId
            EquipItemByName(11122, 13)
          end
        else
          EquipItemByName(11122, 13)
        end
      else
        --carrot lower
        local itemId = GetInventoryItemID("player", 14)
        if(itemId) then
          if(itemId ~= 11122) then
            AutoCropDB.trinketId = itemId
            EquipItemByName(11122, 14)
          end
        else
          EquipItemByName(11122, 14)
        end
      end
      --riding gear
      if(AutoCropDB.enchantHandsLink) then
        itemLink = GetInventoryItemLink("player", 10) -- hands
        if(itemLink) then
          local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
          if(enchantId ~= "930") then
            AutoCropDB.handsLink = "item:"..itemId..":"..enchantId..":"
            EquipItemByName(AutoCropDB.enchantHandsLink, 10)
          end
        else
          AutoCropDB.handsLink = nil
          EquipItemByName(AutoCropDB.enchantHandsLink, 10)
        end
      end
      if(AutoCropDB.enchantBootsLink) then    
        itemLink = GetInventoryItemLink("player", 8) -- feet
        if(itemLink) then
          local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
          if(enchantId ~= "464") then
            AutoCropDB.bootsLink = "item:"..itemId..":"..enchantId..":"
            EquipItemByName(AutoCropDB.enchantBootsLink, 8)
          end
        else
          AutoCropDB.bootsLink = nil
          EquipItemByName(AutoCropDB.enchantBootsLink, 8)
        end
      end
    end
  else
    if(not AutoCropDB.legacyMode) then
      --crop upper
      if(not AutoCropDB.trinketSlot) then
        local itemId = GetInventoryItemID("player", 13)
        if(itemId) then
          if(itemId ~= 25653) then
            AutoCropDB.trinketId = itemId
          elseif(AutoCropDB.trinketId) then
            EquipItemByName(AutoCropDB.trinketId, 13)
          end
        end
      else
        --crop lower
        local itemId = GetInventoryItemID("player", 14)
        if(itemId) then
          if(itemId ~= 25653) then
            AutoCropDB.trinketId = itemId
          elseif(AutoCropDB.trinketId) then
            EquipItemByName(AutoCropDB.trinketId, 14)
          end
        end
      end
      --Gas helmet
      if(AutoCropDB.gasHelm) then
        local itemId2 = GetInventoryItemID("player", 1)
        if(itemId2 and AutoCropDB.gasHelm) then
          if(itemId2 ~= 23762) then
            AutoCropDB.gasHelmId = itemId2
          elseif(AutoCropDB.gasHelmId) then
            EquipItemByName(AutoCropDB.gasHelmId, 1)
          end
        end
      end
    else
      --carrot upper
      if(not AutoCropDB.trinketSlot) then
        local itemId = GetInventoryItemID("player", 13)
        if(itemId) then
          if(itemId ~= 11122) then
            AutoCropDB.trinketId = itemId
          elseif(AutoCropDB.trinketId) then
            EquipItemByName(AutoCropDB.trinketId, 13)
          end
        end
      else
        --carrot lower
        local itemId = GetInventoryItemID("player", 14)
        if(itemId) then
          if(itemId ~= 11122) then
            AutoCropDB.trinketId = itemId
          elseif(AutoCropDB.trinketId) then
            EquipItemByName(AutoCropDB.trinketId, 14)
          end
        end
      end
      --riding gear
      if(AutoCropDB.enchantHandsLink) then
        itemLink = GetInventoryItemLink("player", 10) -- hands
        if(itemLink) then
          local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
          if(enchantId ~= "930") then
            AutoCropDB.handsLink = "item:"..itemId..":"..enchantId..":"
          elseif(AutoCropDB.handsLink) then
            EquipItemByName(AutoCropDB.handsLink, 10)
          end
        else
          AutoCropDB.handsLink = nil
        end
      end
      if(AutoCropDB.enchantBootsLink) then 
        itemLink = GetInventoryItemLink("player", 8) -- feet
        if(itemLink) then
          local itemId, enchantId = itemLink:match("item:(%d+):(%d*)")
          if(enchantId ~= "464") then
            AutoCropDB.bootsLink = "item:"..itemId..":"..enchantId..":"
          elseif(AutoCropDB.bootsLink) then
            EquipItemByName(AutoCropDB.bootsLink, 8)
          end
        else
          AutoCropDB.bootsLink = nil
        end
      end
    end
  end
  timer = timer + AutoCropDB.updateInterval
end)
--onload
f:SetScript('OnEvent', function(self, event, ...)
  if event == 'ADDON_LOADED' then
    local addon = ...
    if addon == 'AutoCrop' then
      AutoCrop_OnLoad()
    end
    if(AutoCropDB.enabled == nil) then
      AutoCropDB.enabled = true
    end
    if(AutoCropDB.legacyMode == nil) then
      AutoCropDB.legacyMode = false
    end
    if(AutoCropDB.gasHelm == nil) then
      AutoCropDB.gasHelm = false
    end
    if(AutoCropDB.button == nil) then
      AutoCropDB.button = false
    end
    if(AutoCropDB.trinketSlot == nil) then
      AutoCropDB.trinketSlot = true
    end
    if(AutoCropDB.buttonScale == nil) then
      AutoCropDB.buttonScale = 1.0
    end
    if(AutoCropDB.updateInterval == nil) then
      AutoCropDB.updateInterval = 0.2
    end
    if(AutoCropDB.version == nil) then
      AutoCropDB.version = "1.4.1"
    end
  else
    for bag = 0, NUM_BAG_SLOTS do
      for slot = 0, GetContainerNumSlots(bag) do
        local link = GetContainerItemLink(bag, slot)
        if(link) then
          local itemId, enchantId = link:match("item:(%d+):(%d+)")
          if(enchantId == "930") then -- riding gloves
            AutoCropDB.enchantHandsLink = "item:"..itemId..":930:"
          elseif(enchantId == "464") then -- mithril spurs
            AutoCropDB.enchantBootsLink = "item:"..itemId..":464:"
          end
        end
      end
    end
  end
end)

--normal gear
function AutoCrop_EquipNormalSet()
  if(InCombatLockdown() or UnitIsDeadOrGhost("player")) then 
    return 
  end
  if(not AutoCropDB.trinketSlot) then
    if(AutoCropDB.trinketId) then
      EquipItemByName(AutoCropDB.trinketId, 13)
    end
  else
    if(AutoCropDB.trinketId) then
      EquipItemByName(AutoCropDB.trinketId, 14)
    end
  end
  if(AutoCropDB.gasHelmId and AutoCropDB.gasHelm) then
    EquipItemByName(AutoCropDB.gasHelmId, 1)
  end
  if(AutoCropDB.handsLink and AutoCropDB.legacyMode) then
    EquipItemByName(AutoCropDB.handsLink, 10)
  end
  if(AutoCropDB.bootsLink and AutoCropDB.legacyMode) then
    EquipItemByName(AutoCropDB.bootsLink, 8)
  end
end

--prints
function AutoCrop_Print(msg)
	print("|cfffffcfcAuto|cff00ffffCrop|r: "..(msg or ""))
end

function AutoCrop_OnLoad()
  if AutoCropDB.enabled then
    AutoCropButton.overlay:SetColorTexture(0, 1, 0, 0.3)
  else
    AutoCropButton.overlay:SetColorTexture(1, 0, 0, 0.5)
  end
  if AutoCropDB.button then
    AutoCropButton:Show()
  else
    AutoCropButton:Hide()
  end
  AutoCropButton:SetScale(AutoCropDB.buttonScale or 1)
end

-- Slash commands
local function OnSlash(key, value, ...)
  if key and key ~= "" then
    if key == "enabled" then
      if value == "toggle" or tonumber(value) then
        local enable
        if value == "toggle" then
          enable = not AutoCropDB.enabled
        else
          enable = tonumber(value) == 1 and true or false
        end
        AutoCropDB.enabled = enable
        AutoCrop_Print("'enabled' set: "..( enable and "true" or "false" ))
        if not enable then AutoCrop_EquipNormalSet() end
          AutoCrop_OnLoad()
        else
          AutoCrop_Print("'enabled' = "..( AutoCropDB.enabled and "true" or "false" ))
        end
    elseif key == "slot" then
      if tonumber(value) then
        local enable = tonumber(value) == 1 and true or false
        AutoCropDB.trinketSlot = enable
        AutoCrop_Print("'trinket slot' set: "..( enable and "true" or "false" ))
      else
        AutoCrop_Print("'trinket slot' = "..( AutoCropDB.trinketSlot and "true" or "false" ))
      end
      elseif key == "legacy" then
        if tonumber(value) then
          local enable = tonumber(value) == 1 and true or false
          AutoCropDB.legacyMode = enable
          AutoCrop_Print("'legacy mode' set: "..( enable and "true" or "false" ))
        else
          AutoCrop_Print("'legacy mode' = "..( AutoCropDB.legacyMode and "true" or "false" ))
        end
    elseif key == "gas" then
      if tonumber(value) then
        local enable = tonumber(value) == 1 and true or false
        AutoCropDB.gasHelm = enable
        AutoCrop_Print("'gas goggles' set: "..( enable and "true" or "false" ))
      else
        AutoCrop_Print("'gas goggles' = "..( AutoCropDB.gasHelm and "true" or "false" ))
      end
      elseif key == "legacy" then
        if tonumber(value) then
          local enable = tonumber(value) == 1 and true or false
          AutoCropDB.legacyMode = enable
          AutoCrop_Print("'legacy mode' set: "..( enable and "true" or "false" ))
        else
          AutoCrop_Print("'legacy mode' = "..( AutoCropDB.legacyMode and "true" or "false" ))
        end
      elseif key == "interval" then
        if tonumber(value) then
          local interval = tonumber(value)
          AutoCropDB.updateInterval = interval
          AutoCrop_Print("'update interval' set: "..interval)
        else
          AutoCrop_Print("'update interval' = "..AutoCropDB.updateInterval)
        end
    elseif key == "button" then
      if tonumber(value) then
        local enable = tonumber(value) == 1 and true or false
        AutoCropDB.button = enable
        AutoCrop_Print("'button' set: "..( enable and "true" or "false" ))
        AutoCrop_OnLoad()
      elseif value == "reset" then
        AutoCropButton:ClearAllPoints()
        AutoCropButton:SetPoint("CENTER")
        AutoCropDB.buttonScale = 1
        AutoCrop_OnLoad()
        AutoCrop_Print("Button position/scale reset.")
      elseif value == "scale" then
        local arg2 = ...
        if tonumber(arg2) then
          AutoCropDB.buttonScale = arg2
          AutoCrop_Print("'buttonScale' set: "..AutoCropDB.buttonScale)
          AutoCrop_OnLoad()
        else
          AutoCrop_Print("'buttonScale' = "..AutoCropDB.buttonScale or 1)
          AutoCrop_Print("Usage: /autocrop button scale 1.0")
        end
      else
        AutoCrop_Print("'button' = "..( AutoCropDB.button and "true" or "false" ))
      end
    elseif key == "reset" then
      AutoCropDB = nil
      collectgarbage()
    end
  else
    AutoCrop_Print("Slash commands:")
    AutoCrop_Print("enabled - toggle addon on and off. Values: 0/1/toggle ("..(AutoCropDB.enabled and "1" or "0")..")")
    AutoCrop_Print("slot - toggle trinket slot you want to use Values: 0(upper)/1(lower) ("..(AutoCropDB.trinketSlot and "1" or "0")..")")
    AutoCrop_Print("gas - toggle equipping of the engi gas helmet. Values: 0/1 ("..(AutoCropDB.gasHelm and "1" or "0")..")")
    AutoCrop_Print("legacy - toggle between TBC riding gear and Classic riding gear. Values: 0/1 ("..(AutoCropDB.legacyMode and "1" or "0")..")")
    AutoCrop_Print("interval - set how often addon should check if gear needs switching. Default value: 0.2 [seconds] ("..AutoCropDB.updateInterval..")")
    AutoCrop_Print("button - settings of the button. Values: 0/1/reset/scale ("..(AutoCropDB.button and "1" or "0")..")")
    AutoCrop_Print("reset - reset saved settings, please reload ui with /rl command afterwards")
    print("|cfffffcfcAuto|cff00ffffCrop|r ver."..AutoCropDB.version.." by |cff00ffffChromie|r-NethergardeKeep")
  end
end

SLASH_AUTOCROP1 = "/autocrop";
SLASH_AUTOCROP2 = "/ac";
SlashCmdList["AUTOCROP"] = function(msg)
  msg = string.lower(msg)
  msg = { string.split(" ", msg) }
  if #msg >= 1 then
    local exec = table.remove(msg, 1)
    OnSlash(exec, unpack(msg))
  end
end

AutoCropButton = CreateFrame("Button", "AutoCropButton", UIParent, "ActionButtonTemplate")
AutoCropButton.icon:SetTexture(133803)
AutoCropButton:SetPoint("CENTER")
AutoCropButton.overlay = AutoCropButton:CreateTexture(nil, "OVERLAY")
AutoCropButton.overlay:SetAllPoints(AutoCropButton)
AutoCropButton:RegisterForDrag("LeftButton")
AutoCropButton:SetMovable(true)
AutoCropButton:SetUserPlaced(true)
AutoCropButton:SetScript("OnDragStart", function() if IsAltKeyDown() then AutoCropButton:StartMoving() end end)
AutoCropButton:SetScript("OnDragStop", AutoCropButton.StopMovingOrSizing)
AutoCropButton:SetScript("OnClick", function()
  if AutoCropDB.enabled then
    AutoCropButton.overlay:SetColorTexture(1, 0, 0, 0.5)
    AutoCropDB.enabled = false
    AutoCrop_EquipNormalSet()
  else
    AutoCropButton.overlay:SetColorTexture(0, 1, 0, 0.3)
    AutoCropDB.enabled = true
  end
end)