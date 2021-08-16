AutoCropDB_BACKUP = {
  enabled = true,
  pvp = false,
  gasHelmID = 0,
  bootsID = 0,
  golvesID = 0,
  button = false,
  trinketSlot = 13,
  buttonScale = 1.0,
  legacy = false,
  vaildGasHelmIDs = {0, 23762, 32479, 32473, 32474, 32495, 32480, 32475, 32472, 32476, 32461, 32494, 32478, 35183, 34356, 34353, 35184, 35181, 34354, 34355, 35185, 35182, 34357, 34847},
  validGasZones = {"Shadowmoon Valley", "Nagrand", "Zangarmarsh", "Netherstorm"},
  ignoredList = {},
  enabledIgnored = false,
  previousMountState = false,
  changeWhenExit = false,
  enteredCombatMounted = false,
  version = "2.5.1" }

--prints
function AutoCrop_Print(msg)
  print("|cfffffcfcAuto|cff00ffffCrop|r: "..(msg or ""))
end

-- Check if item is in an array
function AutoCrop_InArray(value, myArray)
  if myArray == nil then
    return
  end
  for _,i in ipairs(myArray) do
      if value == i then
          return true
      end
  end
  return false
end

function AutoCrop_PrintTable(myTable)
  if myTable == nil then
    return
  end
    for i,v in ipairs(myTable) do
        print(v)
    end
end

function AutoCrop_EquipRidingSet(saveNormal)
  if saveNormal == nil then
    saveNormal = true
  else
    saveNormal = false
  end

  if saveNormal then
    AutoCrop_SaveNormalSet()
  end

  if AutoCropDB.legacy then
    EquipItemByName(11122, AutoCropDB.trinketSlot)
    EquipItemByName(AutoCropDB.bootsID, 8)
    EquipItemByName(AutoCropDB.glovesID, 10)
  else
    EquipItemByName(25653, AutoCropDB.trinketSlot)
  end
  if AutoCrop_InArray(GetZoneText(), AutoCropDB.validGasZones) then
    EquipItemByName(AutoCropDB.gasHelmID, 1)
  end
end

function AutoCrop_SaveNormalSet()
  AutoCropDB.normalHelmID = GetInventoryItemID("player", 1)
  local itemID = GetInventoryItemID("player", AutoCropDB.trinketSlot)
  if (not AutoCropDB.legacy and itemID ~= 25653) or (AutoCropDB.legacy and itemID ~= 11122) then
    AutoCropDB.normalTrinketID = itemID
  end
  if AutoCropDB.legacy then
    local bootsID = GetInventoryItemID("player", 8)
    local glovesID = GetInventoryItemID("player", 10)
    if bootsID ~= AutoCropDB.bootsID then
      AutoCropDB.normalBootsID = bootsID
    end
    if glovesID ~= AutoCropDB.glovesID then
      AutoCropDB.normalGlovesID = glovesID
    end
  end
end

function AutoCrop_EquipNormalSet()
  if(InCombatLockdown() or UnitIsDeadOrGhost("player")) then 
    return 
  else
    EquipItemByName(AutoCropDB.normalTrinketID, AutoCropDB.trinketSlot)
    EquipItemByName(AutoCropDB.normalHelmID, 1)
    if AutoCropDB.legacy then
      EquipItemByName(AutoCropDB.normalBootsID, 8)
      EquipItemByName(AutoCropDB.normalGlovesID, 10)
    end
  end
end

-- Find item IDs that have spurs and riding enchant on them
function AutoCrop_SearchBootsGloves()
  AutoCropDB.bootsID = 0
  AutoCropDB.glovesID = 0
  for bag = 0, NUM_BAG_SLOTS do
    for slot = 0, GetContainerNumSlots(bag) do
      local link = GetContainerItemLink(bag, slot)
      if(link) then
        local itemID, enchantID = link:match("item:(%d+):(%d+)")
        if(enchantID == "930") then -- riding gloves
          AutoCropDB.glovesID = itemID
        elseif(enchantID == "464") then -- mithril spurs
          AutoCropDB.bootsID = itemID
        end
      end
    end
  end
end

function AutoCrop_OnLoad()
  if not AutoCropDB then --
    AutoCropDB = AutoCropDB_BACKUP
    AutoCrop_Print("Database reset; please update your settings (e.g. you gas helm item ID).")
  end
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
  if AutoCropDB.legacy then
    AutoCrop_SearchBootsGloves()
  end
  AutoCropButton:SetScale(AutoCropDB.buttonScale or 1)
end

-- Slash commands
local function OnSlash(key, value, ...)
  if key == "enable" and (value == "toggle" or tonumber(value)) then
    if value == "toggle" then
      AutoCropDB.enabled = not AutoCropDB.enabled
    else
      AutoCropDB.enabled = tonumber(value) == 1 and true or false
    end
    if not AutoCropDB.enabled then
      AutoCrop_EquipNormalSet()
    elseif AutoCropDB.enabled and IsMounted() then
      AutoCrop_EquipRidingSet()
    end
    AutoCrop_OnLoad()
    AutoCrop_Print("'enabled' = "..( AutoCropDB.enabled and "true" or "false" ))
  elseif key == "pvp" and (value == "toggle" or tonumber(value)) then
    if value == "toggle" then
      AutoCropDB.pvp = not AutoCropDB.pvp
    else
      AutoCropDB.pvp = tonumber(value) == 1 and true or false
    end
    if AutoCropDB.pvp then
      AutoCrop_EquipNormalSet()
    elseif not AutoCropDB.pvp and IsMounted() then
      AutoCrop_EquipRidingSet()
    end
    AutoCrop_OnLoad()
    AutoCrop_Print("'pvp' = "..( AutoCropDB.pvp and "true" or "false" ))
  elseif key == 'legacy' and (value == "toggle" or tonumber(value)) then
    if value == "toggle" then
      AutoCropDB.legacy = not AutoCropDB.legacy
    else
      AutoCropDB.legacy = tonumber(value) == 1 and true or false
    end
    AutoCrop_Print("'legacy' = "..( AutoCropDB.legacy and "true" or "false" ))
  elseif key == "enabledignored" then
    if value == "toggle" or tonumber(value) then
      local enable
      if value == "toggle" then
        enable = not AutoCropDB.enabledIgnored
      else
        enable = tonumber(value) == 1 and true or false
      end
      AutoCropDB.enabledIgnored = enable
      if AutoCropDB.enabledIgnored and AutoCrop_InArray(string.lower(GetZoneText()), AutoCropDB.ignoredList) then
        AutoCrop_EquipNormalSet()
      elseif not AutoCropDB.enabledIgnored and IsMounted() then
        AutoCrop_EquipRidingSet(false)
      end
      AutoCrop_Print("'enabledignored' set: "..( enable and "true" or "false" ))
    else
      AutoCrop_Print("'enabled' = "..( AutoCropDB.enabled and "true" or "false" ))
    end
  elseif key == "ignoredlist" then
    if value == 'reset' then
      AutoCrop_Print("'ignoredlist' has been reset.")
      AutoCropDB.ignoredList = AutoCropDB_BACKUP.ignoredList
    elseif value == 'print' and next(AutoCropDB.ignoredList) == nil then
      AutoCrop_Print("'ignoredlist' is empty.")
    elseif value == 'print' then
      AutoCrop_Print("The following instances are currently in the ignored list 'ignoredlist':")
      AutoCrop_PrintTable(AutoCropDB.ignoredList)
    else
      -- Join together instance names that have spaces in them
      if select('#',...) > 0 then
        for i = 1,select("#",...) do
          value = value..' '..select(i,...)
        end
      end
      -- Split based on commas
      for instance in string.gmatch(value, "[^,]+") do
        if not AutoCrop_InArray(instance, AutoCropDB.ignoredList) then
          AutoCrop_Print("Added instance to ignore list: "..instance)
          table.insert(AutoCropDB.ignoredList, instance)
        end
      end
      if AutoCropDB.enabledIgnored and AutoCrop_InArray(string.lower(GetZoneText()), AutoCropDB.ignoredList) then
        AutoCrop_EquipNormalSet()
      end
    end
  elseif key == "slot" and (tonumber(value) == 0 or tonumber(value) == 1) then
    AutoCropDB.tinketSlot = 13+tonumber(value) -- upper trinket slot is index 13
    AutoCrop_Print("Trinket slot set to: "..value)
  elseif key == "slot" then
    AutoCrop_Print("invalid value for 'slot' argument. Must be either 0(upper) or 1(lower); received: "..tostring(value))
  elseif key == "gas" and AutoCrop_InArray(tonumber(value), AutoCropDB.vaildGasHelmIDs) then
    AutoCropDB.gasHelmID = tonumber(value)    
    AutoCrop_Print("Gas helm set to item ID: "..value)
  elseif key == "gas" then
    AutoCrop_Print("invalid value for 'gas' argument. Must be valid gas helm item ID number or 0 to disable; received: "..tostring(value))
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
    AutoCropDB = AutoCropDB_BACKUP
    AutoCrop_Print("Database has been reset.")
  else
    AutoCrop_Print("Slash commands:")
    AutoCrop_Print("enabled - toggle addon on and off. Values: 0/1/toggle ("..(AutoCropDB.enabled and "1" or "0")..")")
    AutoCrop_Print("pvp - toggle addon on and off if in a BG or arena. Values: 0/1/toggle ("..(AutoCropDB.pvp and "1" or "0")..")")
    AutoCrop_Print("slot - toggle trinket slot you want to use Values: 0(upper)/1(lower) ("..tostring(AutoCropDB.trinketSlot)..")")
    AutoCrop_Print("gas - item ID number for the engi gas helmet; use 0 to disable  ("..tostring(AutoCropDB.gasHelmID)..")")
    AutoCrop_Print("button - settings of the button. Values: 0/1/reset/scale ("..(AutoCropDB.button and "1" or "0")..")")
    AutoCrop_Print("reset - reset saved settings, please reload ui with /rl command afterwards")
    AutoCrop_Print("ignoredlist reset/print/comma separated list of instance names to disable AutoCarrot in. Example:\n/ac ignoredlist reset\n/ac ignoredlist print\n/ac ignoredlist Ruins of Ahn'Qiraj,Ahn'Qiraj")
    AutoCrop_Print("enabledignored 0/1/toggle ("..(AutoCropDB.enabledIgnored and "1" or "0")..")")
    print("|cfffffcfcAuto|cff00ffffCrop|r ver."..AutoCropDB.version.." by |cff00ffffChromie|r-NethergardeKeep")
  end
end

local f = CreateFrame("Frame")
  f:RegisterEvent('PLAYER_LOGIN')
  f:RegisterEvent('BAG_UPDATE')
  f:RegisterEvent('ADDON_LOADED')
  f:RegisterEvent('PLAYER_MOUNT_DISPLAY_CHANGED')
  f:RegisterEvent('CHAT_MSG_CHANNEL_NOTICE') -- Used for knowning when player changed zones; ZONE_CHANGED had issues
  f:RegisterEvent('PLAYER_REGEN_DISABLED')
  f:RegisterEvent('PLAYER_REGEN_ENABLED') -- Used for knowing when player leaves combat; PLAYER_LEAVE_COMBAT had issues

f:SetScript("OnEvent", function(self, event, ...)
  
  if event == 'ADDON_LOADED' then
    local addon = ...
    if addon == 'AutoCrop' then
      AutoCrop_OnLoad()
      return
    end
  elseif (not AutoCropDB.enabled or UnitIsDeadOrGhost("player") or UnitOnTaxi("player")) then
    return
  end
  
  -- User wants to ignore chaning for pvp
  if AutoCropDB.pvp then
    local inInstance, instanceType = IsInInstance()
    if instanceType == 'pvp' or instanceType == 'arena' then
      return
    end
  end
  
  local inIgnored = AutoCrop_InArray(string.lower(GetZoneText()), AutoCropDB.ignoredList)
  local isMounted = IsMounted()
  
  -- Ignore changing if in a ignored zone
  if AutoCropDB.enabledIgnored and inIgnored then
    if not AutoCropDB.insideIgnored then
      AutoCrop_EquipNormalSet()
      AutoCropDB.insideIgnored = true
    end
    return
  else
    AutoCropDB.insideIgnored = false
    if isMounted then
      AutoCrop_EquipRidingSet(false)
    end
  end
  
  -- Changing gear after exiting combat if entered combat while mounted and dismounted
  if event == 'PLAYER_REGEN_DISABLED' and isMounted then
    AutoCropDB.enteredCombatMounted = true
  elseif event == 'PLAYER_REGEN_ENABLED' and not AutoCropDB.changeWhenExit then
    AutoCropDB.enteredCombatMounted = false
  elseif event == 'PLAYER_REGEN_ENABLED' and AutoCropDB.changeWhenExit then
    AutoCrop_EquipNormalSet()
    AutoCropDB.enteredCombatMounted = false
    AutoCropDB.changeWhenExit = false
  end
  
  -- player has either changed mount state or changed zones
  if (event == 'PLAYER_MOUNT_DISPLAY_CHANGED' or event == 'CHAT_MSG_CHANNEL_NOTICE') then
    local inGasZone = AutoCrop_InArray(GetZoneText(), AutoCropDB.validGasZones)
    -- player mounted
    if isMounted ~= AutoCropDB.previousMountState and isMounted and event == 'PLAYER_MOUNT_DISPLAY_CHANGED' then
      AutoCrop_EquipRidingSet()
      AutoCropDB.previousMountState = isMounted
    -- player dismounted
    elseif isMounted ~= AutoCropDB.previousMountState and not isMounted and event == 'PLAYER_MOUNT_DISPLAY_CHANGED' then
      if AutoCropDB.enteredCombatMounted then
        AutoCropDB.changeWhenExit = true
      else
        AutoCrop_EquipNormalSet()
      end
      AutoCropDB.previousMountState = isMounted
    -- player entered a zone with gas clounds
    elseif isMounted and event == 'CHAT_MSG_CHANNEL_NOTICE' and inGasZone then
      EquipItemByName(AutoCropDB.gasHelmID, 1)
    -- player entered a zone without gas clouds
    elseif isMounted and event == 'CHAT_MSG_CHANNEL_NOTICE' and not inGasZone then
      EquipItemByName(AutoCropDB.normalHelmID, 1)
    end
  -- item added to bags; check for legacy items
  elseif AutoCropDB.legacy and event == 'BAG_UPDATE' then
    AutoCrop_SearchBootsGloves()
  end
end)

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