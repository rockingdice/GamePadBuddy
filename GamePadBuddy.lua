------------------
--LOAD LIBRARIES--
------------------

--load LibAddonsMenu-2.0
local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0");

----------------------
--INITIATE VARIABLES--
----------------------

--create Addon UI table
GamePadBuddyData = {};
--define name of addon
GamePadBuddyData.name = "GamePadBuddy";
--define addon version number
GamePadBuddyData.version = 1.00;
-- Value Define
TCC_QUEST_GAMES_DOLLS_STATUES = 1
TCC_QUEST_RITUAL_ODDITIES = 2
TCC_QUEST_WRITINGS_MAPS = 3
TCC_QUEST_COSMETICS_LINENS_ACCESSORIES = 4
TCC_QUEST_DRINKWARE_UTENSILS_DISHES = 5
TCC_QUEST_UNKNOWN = -1

-- Constant maps for trait researching
GamePadBuddy = {}
GamePadBuddy.CONST = {}
GamePadBuddy.CONST.CraftingSkillTypes = { CRAFTING_TYPE_BLACKSMITHING, CRAFTING_TYPE_CLOTHIER, CRAFTING_TYPE_WOODWORKING }
GamePadBuddy.CONST.armorCraftMap = { [ARMORTYPE_LIGHT] = CRAFTING_TYPE_CLOTHIER, [ARMORTYPE_MEDIUM] = CRAFTING_TYPE_CLOTHIER, [ARMORTYPE_HEAVY] = CRAFTING_TYPE_BLACKSMITHING }
GamePadBuddy.CONST.weaponCraftMap = { [WEAPONTYPE_AXE] = CRAFTING_TYPE_BLACKSMITHING, [WEAPONTYPE_HAMMER] = CRAFTING_TYPE_BLACKSMITHING, [WEAPONTYPE_SWORD] = CRAFTING_TYPE_BLACKSMITHING, [WEAPONTYPE_TWO_HANDED_AXE] = CRAFTING_TYPE_BLACKSMITHING,
          [WEAPONTYPE_TWO_HANDED_HAMMER] = CRAFTING_TYPE_BLACKSMITHING, [WEAPONTYPE_TWO_HANDED_SWORD] = CRAFTING_TYPE_BLACKSMITHING, [WEAPONTYPE_DAGGER] = CRAFTING_TYPE_BLACKSMITHING,
          [WEAPONTYPE_BOW] = CRAFTING_TYPE_WOODWORKING, [WEAPONTYPE_FIRE_STAFF] = CRAFTING_TYPE_WOODWORKING, [WEAPONTYPE_FROST_STAFF] = CRAFTING_TYPE_WOODWORKING, [WEAPONTYPE_LIGHTNING_STAFF] = CRAFTING_TYPE_WOODWORKING,
          [WEAPONTYPE_HEALING_STAFF] = CRAFTING_TYPE_WOODWORKING, [WEAPONTYPE_SHIELD] = CRAFTING_TYPE_WOODWORKING, [WEAPONTYPE_PROP] = -1
        }

GamePadBuddy.CONST.armorRImap = { [ARMORTYPE_LIGHT] = { [EQUIP_TYPE_CHEST] = 1, [EQUIP_TYPE_FEET] = 2, [EQUIP_TYPE_HAND] = 3, [EQUIP_TYPE_HEAD] = 4, [EQUIP_TYPE_LEGS] = 5, [EQUIP_TYPE_SHOULDERS] = 6, [EQUIP_TYPE_WAIST] = 7 },
          [ARMORTYPE_MEDIUM] = { [EQUIP_TYPE_CHEST] = 8, [EQUIP_TYPE_FEET] = 9, [EQUIP_TYPE_HAND] = 10, [EQUIP_TYPE_HEAD] = 11, [EQUIP_TYPE_LEGS] = 12, [EQUIP_TYPE_SHOULDERS] = 13, [EQUIP_TYPE_WAIST] = 14 },
          [ARMORTYPE_HEAVY] = { [EQUIP_TYPE_CHEST] = 8, [EQUIP_TYPE_FEET] = 9, [EQUIP_TYPE_HAND] = 10, [EQUIP_TYPE_HEAD] = 11, [EQUIP_TYPE_LEGS] = 12, [EQUIP_TYPE_SHOULDERS] = 13, [EQUIP_TYPE_WAIST] = 14 }
        }
GamePadBuddy.CONST.weaponRImap = { [WEAPONTYPE_AXE] = 1, [WEAPONTYPE_HAMMER] = 2, [WEAPONTYPE_SWORD] = 3, [WEAPONTYPE_TWO_HANDED_AXE] = 4, [WEAPONTYPE_TWO_HANDED_HAMMER] = 5, [WEAPONTYPE_TWO_HANDED_SWORD] = 6, [WEAPONTYPE_DAGGER] = 7,
          [WEAPONTYPE_BOW] = 1, [WEAPONTYPE_FIRE_STAFF] = 2, [WEAPONTYPE_FROST_STAFF] = 3, [WEAPONTYPE_LIGHTNING_STAFF] = 4, [WEAPONTYPE_HEALING_STAFF] = 5, [WEAPONTYPE_SHIELD] = 6, [WEAPONTYPE_PROP] = -1
        }
GamePadBuddy.CONST.ItemFlags = { ITEM_FLAG_TRAIT_RESEARABLE = 1, ITEM_FLAG_TRAIT_DUPLICATED = 2, ITEM_FLAG_TRAIT_KNOWN = 3, ITEM_FLAG_TRAIT_RESEARCHING = 4, ITEM_FLAG_TRAIT_INTRICATE = 5, ITEM_FLAG_TRAIT_ORNATE = 6, ITEM_FLAG_TCC_QUEST = 100, ITEM_FLAG_TCC_USABLE = 101, ITEM_FLAG_TCC_USELESS = 102, ITEM_FLAG_NONE = -1}
GamePadBuddy.CONST.TCCQuestType = { TCC_QUEST_GAMES_DOLLS_STATUES, TCC_QUEST_RITUAL_ODDITIES, TCC_QUEST_WRITINGS_MAPS, TCC_QUEST_COSMETICS_LINENS_ACCESSORIES, TCC_QUEST_DRINKWARE_UTENSILS_DISHES}
GamePadBuddy.CONST.TCCQuestTags = { 
	[TCC_QUEST_GAMES_DOLLS_STATUES] = {["Games"] = true, ["Dolls"] = true, ["Statues"] = true},
	[TCC_QUEST_RITUAL_ODDITIES] = {["Ritual Objects"] = true, ["Oddities"] = true},
	[TCC_QUEST_WRITINGS_MAPS] = {["Writings"] = true, ["Maps"] = true, ["Scrivener Supplies"] = true},
	[TCC_QUEST_COSMETICS_LINENS_ACCESSORIES] = {["Cosmetics"] = true, ["Linens"] = true, ["Wardrobe Accessories"] = true},
	[TCC_QUEST_DRINKWARE_UTENSILS_DISHES] = {["Drinkware"] = true, ["Utensils"] = true, ["Dishes and Cookware"] = true}
	}

function IsResearchableTrait(itemType, traitType)
  return (itemType == ITEMTYPE_WEAPON or itemType == ITEMTYPE_ARMOR)
     and (traitType == ITEM_TRAIT_TYPE_ARMOR_DIVINES
    or traitType == ITEM_TRAIT_TYPE_ARMOR_PROSPEROUS
    or traitType == ITEM_TRAIT_TYPE_ARMOR_IMPENETRABLE
    or traitType == ITEM_TRAIT_TYPE_ARMOR_INFUSED
    or traitType == ITEM_TRAIT_TYPE_ARMOR_REINFORCED
    or traitType == ITEM_TRAIT_TYPE_ARMOR_STURDY
    or traitType == ITEM_TRAIT_TYPE_ARMOR_TRAINING
    or traitType == ITEM_TRAIT_TYPE_ARMOR_WELL_FITTED
    or traitType == ITEM_TRAIT_TYPE_ARMOR_NIRNHONED
    or traitType == ITEM_TRAIT_TYPE_WEAPON_CHARGED
    or traitType == ITEM_TRAIT_TYPE_WEAPON_DEFENDING
    or traitType == ITEM_TRAIT_TYPE_WEAPON_INFUSED
    or traitType == ITEM_TRAIT_TYPE_WEAPON_POWERED
    or traitType == ITEM_TRAIT_TYPE_WEAPON_PRECISE
    or traitType == ITEM_TRAIT_TYPE_WEAPON_SHARPENED
    or traitType == ITEM_TRAIT_TYPE_WEAPON_TRAINING
    or traitType == ITEM_TRAIT_TYPE_WEAPON_DECISIVE
    or traitType == ITEM_TRAIT_TYPE_WEAPON_NIRNHONED)
end
local function IsBlacksmithWeapon(weaponType)
  return weaponType == WEAPONTYPE_AXE
      or weaponType == WEAPONTYPE_HAMMER
      or weaponType == WEAPONTYPE_SWORD
      or weaponType == WEAPONTYPE_TWO_HANDED_AXE
      or weaponType == WEAPONTYPE_TWO_HANDED_HAMMER
      or weaponType == WEAPONTYPE_TWO_HANDED_SWORD
      or weaponType == WEAPONTYPE_DAGGER
end
local function IsWoodworkingWeapon(weaponType)
  return weaponType == WEAPONTYPE_BOW
      or weaponType == WEAPONTYPE_FIRE_STAFF
      or weaponType == WEAPONTYPE_FROST_STAFF
      or weaponType == WEAPONTYPE_LIGHTNING_STAFF
      or weaponType == WEAPONTYPE_HEALING_STAFF
      or weaponType == WEAPONTYPE_SHIELD
end
function ItemToCraftingSkillType(itemType, armorType, weaponType)
  --GetItemLinkCraftingSkillType didn't return what I expected
  --ToDo: Investigate GetItemLinkRecipeCraftingSkillType(*string* _itemLink_)
  if itemType == ITEMTYPE_ARMOR then
    if armorType == ARMORTYPE_HEAVY then
      return CRAFTING_TYPE_BLACKSMITHING
    elseif armorType == ARMORTYPE_MEDIUM or armorType == ARMORTYPE_LIGHT then
      return CRAFTING_TYPE_CLOTHIER
    end
  elseif itemType == ITEMTYPE_WEAPON then
    if IsBlacksmithWeapon(weaponType) then
      return CRAFTING_TYPE_BLACKSMITHING
    elseif IsWoodworkingWeapon(weaponType) then
      return CRAFTING_TYPE_WOODWORKING
    end
  end
  return nil
end

function ItemToTraitIndex(traitType)
  if traitType >= 1 and traitType <= 8 then
    return traitType
  elseif traitType == 26 then
    return 9
  elseif traitType >= 11 and traitType <= 18 then
    return traitType - 10
  elseif traitType == 25 then
    return 9
  end
  return nil
end

function ItemToResearchLineIndex(itemType, armorType, weaponType, equipType)
  --Figure out which research index this item is. Hope to find a function to do this
  if itemType == ITEMTYPE_ARMOR then
    if armorType == ARMORTYPE_HEAVY then
      if equipType == EQUIP_TYPE_CHEST then --Cuirass
        return 8
      elseif equipType == EQUIP_TYPE_FEET then --Sabatons
        return 9
      elseif equipType == EQUIP_TYPE_HAND then --Gauntlets
        return 10
      elseif equipType == EQUIP_TYPE_HEAD then --Helm
        return 11
      elseif equipType == EQUIP_TYPE_LEGS then --Greaves
        return 12
      elseif equipType == EQUIP_TYPE_SHOULDERS then --Pauldron
        return 13
      elseif equipType == EQUIP_TYPE_WAIST then --Girdle
        return 14
      end
    elseif armorType == ARMORTYPE_MEDIUM then
      if equipType == EQUIP_TYPE_CHEST then --Jack
        return 8
      elseif equipType == EQUIP_TYPE_FEET then --Boots
        return 9
      elseif equipType == EQUIP_TYPE_HAND then --Bracers
        return 10
      elseif equipType == EQUIP_TYPE_HEAD then --Helmet
        return 11
      elseif equipType == EQUIP_TYPE_LEGS then --Guards
        return 12
      elseif equipType == EQUIP_TYPE_SHOULDERS then --Arm Cops
        return 13
      elseif equipType == EQUIP_TYPE_WAIST then --Belt
        return 14
      end
    elseif armorType == ARMORTYPE_LIGHT then
      if equipType == EQUIP_TYPE_CHEST then --Robe+Shirt = Robe & Jerkin
        return 1
      elseif equipType == EQUIP_TYPE_FEET then --Shoes
        return 2
      elseif equipType == EQUIP_TYPE_HAND then --Gloves
        return 3
      elseif equipType == EQUIP_TYPE_HEAD then --Hat
        return 4
      elseif equipType == EQUIP_TYPE_LEGS then --Breeches
        return 5
      elseif equipType == EQUIP_TYPE_SHOULDERS then --Epaulets
        return 6
      elseif equipType == EQUIP_TYPE_WAIST then --Sash
        return 7
      end
    end
  elseif itemType == ITEMTYPE_WEAPON then
    if weaponType == WEAPONTYPE_AXE then
      return 1
    elseif weaponType == WEAPONTYPE_HAMMER then
      return 2
    elseif weaponType == WEAPONTYPE_SWORD then
      return 3
    elseif weaponType == WEAPONTYPE_TWO_HANDED_AXE then
      return 4
    elseif weaponType == WEAPONTYPE_TWO_HANDED_HAMMER then
      return 5
    elseif weaponType == WEAPONTYPE_TWO_HANDED_SWORD then
      return 6
    elseif weaponType == WEAPONTYPE_DAGGER then
      return 7
    elseif weaponType == WEAPONTYPE_BOW then
      return 1
    elseif weaponType == WEAPONTYPE_FIRE_STAFF then
      return 2
    elseif weaponType == WEAPONTYPE_FROST_STAFF then
      return 3
    elseif weaponType == WEAPONTYPE_LIGHTNING_STAFF then
      return 4
    elseif weaponType == WEAPONTYPE_HEALING_STAFF then
      return 5
    elseif weaponType == WEAPONTYPE_SHIELD then
      return 6
    end
  end
  return 0
end

---------------------
--TRIGGER FUNCTIONS--
---------------------
 
-- Credit to ScotteYx for this! thanks for this improvement
function CacheItemTraits()
    local bagsToCheck = {
        [1] = BAG_BACKPACK,
        [2] = BAG_BANK,
        --[3] = BAG_GUILDBANK,
    }
    for _, bagToCheck in pairs(bagsToCheck) do
      -- Get bag size
      local bagSize = GetBagSize(bagToCheck)
     
      -- Iterate through BAG
      for i = 0, bagSize do
          -- Get current item
          local itemLink = GetItemLink(bagToCheck, i)
          local itemType = GetItemLinkItemType(itemLink)
          local traitType, _ = GetItemLinkTraitInfo(itemLink)
          --Only check researchable items
          if IsResearchableTrait(itemType, traitType) then
            -- Check items for trait researching
            local armorType = GetItemLinkArmorType(itemLink)
            local weaponType = GetItemLinkWeaponType(itemLink)
            local equipType = GetItemLinkEquipType(itemLink)
			local quality = GetItemLinkQuality(itemLink)

            local craftType = ItemToCraftingSkillType(itemType, armorType, weaponType)
            local rIndex = ItemToResearchLineIndex(itemType, armorType, weaponType, equipType)
            local traitIndex = ItemToTraitIndex(traitType)
            local statusTable = GamePadBuddy.ResearchTraits[craftType][rIndex][traitIndex]
			local status = statusTable[1]
            if status == -2 then
              --already researched, do nothing
            elseif status == -1 then
              --not researched, and no items recorded, record it                            
              local uniqueId = getItemId(bagToCheck, i)
			  local itemLevel = GetItemLevel(bagToCheck, i)
              GamePadBuddy.ResearchTraits[craftType][rIndex][traitIndex] = {uniqueId, quality, itemLevel}
            else 
              --already have a recorded item, duplicated
            end
          end   
      end
    end
 
    -- return number of matches
    return itemMatches;
end


function RefreshResearchData()
  GamePadBuddy.ResearchTraits = {}  -- craftType / itemType / traitType
  for i,craftType in pairs(GamePadBuddy.CONST.CraftingSkillTypes) do
    GamePadBuddy.ResearchTraits[craftType] = {}
    for researchIndex = 1, GetNumSmithingResearchLines(craftType) do
      local name, icon, numTraits, timeRequiredForNextResearchSecs = GetSmithingResearchLineInfo(craftType, researchIndex)
      GamePadBuddy.ResearchTraits[craftType][researchIndex] = {}
      for traitIndex = 1, numTraits do
        local traitType, _, known = GetSmithingResearchLineTraitInfo(craftType, researchIndex, traitIndex)
        local durationSecs, _ = GetSmithingResearchLineTraitTimes(craftType, researchIndex, traitIndex) --can be nil
        if durationSecs then
          GamePadBuddy.ResearchTraits[craftType][researchIndex][traitIndex] = {-3}  --researching
        elseif known then
          GamePadBuddy.ResearchTraits[craftType][researchIndex][traitIndex] = {-2}  --already researched
        else
          GamePadBuddy.ResearchTraits[craftType][researchIndex][traitIndex] = {-1}
        end
      end
    end
  end
end

  
function getItemId(bagId, slotIndex)
  local itemId = zo_getSafeId64Key(GetItemUniqueId(bagId, slotIndex))
  return itemId
end

function GamePadBuddy:RefreshTCCQuestData()
	--d("Refresh TCC QuestData")
	GamePadBuddy.CurrentTCCQuest = TCC_QUEST_UNKNOWN
	local quests = QUEST_JOURNAL_MANAGER:GetQuestListData()
    -- If we're showing the options list, make sure we still have the quest that we're viewing options for
	for i, quest in ipairs(quests) do
		if quest.name == "The Covetous Countess" then
			--parse quest info 
			local _, backgroundText, activeStepText = GetJournalQuestInfo(quest.questIndex)
			--d(activeStepText)
			if string.find(activeStepText, "games") then
				GamePadBuddy.CurrentTCCQuest = TCC_QUEST_GAMES_DOLLS_STATUES
			elseif string.find(activeStepText, "ritual") then
				GamePadBuddy.CurrentTCCQuest = TCC_QUEST_RITUAL_ODDITIES
			elseif string.find(activeStepText, "writings and maps") then
				GamePadBuddy.CurrentTCCQuest = TCC_QUEST_WRITINGS_MAPS
			elseif string.find(activeStepText, "cosmetics") then
				GamePadBuddy.CurrentTCCQuest = TCC_QUEST_COSMETICS_LINENS_ACCESSORIES
			elseif string.find(activeStepText, "drinkware, utensils, and dishes") then
				GamePadBuddy.CurrentTCCQuest = TCC_QUEST_DRINKWARE_UTENSILS_DISHES
			else
			end
		end
	end

end

function GamePadBuddy:IsTCCQuestItemTag(tag)
	for k, v in pairs(GamePadBuddy.CONST.TCCQuestType) do
		if GamePadBuddy.CONST.TCCQuestTags[v][tag] ~= nil then
			return true
		end
	end
	return false
end
 
function GamePadBuddy:GetItemFlagStatus(bagId, slotIndex)
  -- Get current item
  local itemLink = GetItemLink(bagId, slotIndex)
  local itemType = GetItemLinkItemType(itemLink)
  local traitType, _ = GetItemLinkTraitInfo(itemLink)
  local returnStatus = GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_NONE
  local name = ""
  --check if treasure type
  local itemType = GetItemLinkItemType(itemLink)
  local treasureType = itemType == ITEMTYPE_TREASURE
  if treasureType then  
	local quality = GetItemLinkQuality(itemLink)
	if quality >= 2 then 
		return GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_ORNATE
	end
	if GamePadBuddy.CurrentTCCQuest == TCC_QUEST_UNKNOWN then
		return returnStatus, name
	end
    local numItemTags = GetItemLinkNumItemTags(itemLink)
	--d("Name:" .. GetItemLinkName(itemLink) .." SlotIndex:" .. slotIndex)
    if numItemTags > 0 then 
		local useful = false
        for i = 1, numItemTags do
            local itemTagDescription, itemTagCategory = GetItemLinkItemTagInfo(itemLink, i)
			local itemTagString = zo_strformat(SI_TOOLTIP_ITEM_TAG_FORMATER, itemTagDescription)	
			--d("itemTagString:"..itemTagString)
			if GamePadBuddy.CONST.TCCQuestTags[GamePadBuddy.CurrentTCCQuest][itemTagString] ~= nil then
				return GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TCC_QUEST, name
			end
			if GamePadBuddy:IsTCCQuestItemTag(itemTagString) then
				useful = true
			end
		end
		if useful == false then
			return GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TCC_USELESS, name
		else
			return GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TCC_USABLE, name
		end
	end
  --Only check researchable items
  else
	  if IsResearchableTrait(itemType, traitType) then
		-- Check items for trait researching
		local armorType = GetItemLinkArmorType(itemLink)
		local weaponType = GetItemLinkWeaponType(itemLink)
		local equipType = GetItemLinkEquipType(itemLink)

		local craftType = ItemToCraftingSkillType(itemType, armorType, weaponType)
		local rIndex = ItemToResearchLineIndex(itemType, armorType, weaponType, equipType)
		local traitIndex = ItemToTraitIndex(traitType)
		local statusTable = GamePadBuddy.ResearchTraits[craftType][rIndex][traitIndex]
		local status = statusTable[1]
		local curQuality = statusTable[2]
		local curLevel = statusTable[3]
		name, _, _, _ = GetSmithingResearchLineInfo(craftType, rIndex)
		if status == -3 then
		  --is researching now
		  returnStatus = GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_RESEARCHING
		elseif status == -2 then
		  --already researched      
		  returnStatus = GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_KNOWN
		elseif status == -1 then
		  --not researched, and no items recorded, record it                            
		  local uniqueId = getItemId(bagId, slotIndex)
		  local quality = GetItemLinkQuality(itemLink)
		  local itemLevel = GetItemLevel(bagId, slotIndex)
		  
		  --update cache      
		  GamePadBuddy.ResearchTraits[craftType][rIndex][traitIndex] = {uniqueId, quality, itemLevel} 
		  returnStatus = GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_RESEARABLE
		else 
		  --already have a recorded item, check if the same
		  local uniqueId = getItemId(bagId, slotIndex)
		  local quality = GetItemLinkQuality(itemLink)
		  local itemLevel = GetItemLevel(bagId, slotIndex)
		  if status == uniqueId then
			returnStatus = GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_RESEARABLE
		  else
			--checck quality and level
			if quality < curQuality then
				--replace
				GamePadBuddy.ResearchTraits[craftType][rIndex][traitIndex] = {uniqueId, quality, itemLevel} 
				returnStatus = GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_RESEARABLE
			elseif quality == curQuality then
				--check itemLevel
				if itemLevel < curLevel then
					GamePadBuddy.ResearchTraits[craftType][rIndex][traitIndex] = {uniqueId, quality, itemLevel} 
					returnStatus = GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_RESEARABLE
				else
					returnStatus = GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_DUPLICATED
				end
			else
				returnStatus = GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_DUPLICATED
			end
		  end
		end
	  else
		if traitType == ITEM_TRAIT_TYPE_WEAPON_INTRICATE or traitType == ITEM_TRAIT_TYPE_ARMOR_INTRICATE then
		  return GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_INTRICATE
		elseif traitType == ITEM_TRAIT_TYPE_WEAPON_ORNATE or traitType == ITEM_TRAIT_TYPE_ARMOR_ORNATE then
		  return GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_ORNATE
		end
	  end   
	end
  return returnStatus, name
end


-- Original code by prasoc, edited by ScotteYx. Thanks for the improvement :)
local function AddInventoryPreInfo(tooltip, bagId, slotIndex)
    local itemLink = GetItemLink(bagId, slotIndex)      
    
    local style = GetItemLinkItemStyle(itemLink)    
    local _, traitText = GetItemLinkTraitInfo(itemLink) 
    local itemFlagStatus, name = GamePadBuddy:GetItemFlagStatus(bagId, slotIndex)
    local traitString = nil
    if itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_RESEARABLE then
      traitString = "|c00FF00Researchable|r"
    elseif itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_DUPLICATED then
      traitString = "|cFFFF00Duplicated|r"
    elseif itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_KNOWN then
      traitString = "|cFF0000Known|r"
    elseif itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_RESEARCHING then
      traitString = "|cFD9A00Researching|r"
    else
      traitString = ""
    end
    if itemFlagStatus ~= GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_NONE then
      local traitType, _, _, _, _ = GetItemLinkTraitInfo(itemLink)
      tooltip:AddLine(zo_strformat("<<1>> - <<2>> (<<3>>)", name, GetString("SI_ITEMTRAITTYPE", traitType), traitString), {fontSize=27, customSpacing=15}, tooltip:GetStyle("bodyHeader"))
    else
      
    end

    -- CHAT_SYSTEM:AddMessage("|cffffff test u "
    --   .. ITEM_TRAIT_TYPE_WEAPON_POWERED .. "," 
    --   .. ITEM_TRAIT_TYPE_WEAPON_CHARGED .. "," 
    --   .. ITEM_TRAIT_TYPE_WEAPON_PRECISE .. "," 
    --   .. ITEM_TRAIT_TYPE_WEAPON_INFUSED .. "," 
    --   .. ITEM_TRAIT_TYPE_WEAPON_DEFENDING .. "," 
    --   .. ITEM_TRAIT_TYPE_WEAPON_TRAINING .. "," 
    --   .. ITEM_TRAIT_TYPE_WEAPON_SHARPENED .. "," 
    --   .. ITEM_TRAIT_TYPE_WEAPON_DECISIVE .. ","       
    --   .. ITEM_TRAIT_TYPE_WEAPON_NIRNHONED .. "//"       
    --   .. ITEM_TRAIT_TYPE_ARMOR_STURDY .. "," 
    --   .. ITEM_TRAIT_TYPE_ARMOR_IMPENETRABLE .. "," 
    --   .. ITEM_TRAIT_TYPE_ARMOR_REINFORCED .. "," 
    --   .. ITEM_TRAIT_TYPE_ARMOR_WELL_FITTED .. "," 
    --   .. ITEM_TRAIT_TYPE_ARMOR_TRAINING .. "," 
    --   .. ITEM_TRAIT_TYPE_ARMOR_INFUSED .. "," 
    --   .. ITEM_TRAIT_TYPE_ARMOR_PROSPEROUS .. "," 
    --   .. ITEM_TRAIT_TYPE_ARMOR_DIVINES .. ","       
    --   .. ITEM_TRAIT_TYPE_ARMOR_NIRNHONED .. ","
    --   .. "|r");

	
	local isSetItem, setName, numBonuses, numEquipped, maxEquipped = GetItemLinkSetInfo(itemLink)
	if isSetItem then
		--tooltip:AddLine("Set: " .. setName .. " " .. numBonuses .. " " .. numEquipped .. " " .. maxEquipped)
		 
		tooltip:AddLine(zo_strformat("|cf2da3d<<1>>(<<2>>/<<3>>)|r", setName, numEquipped, maxEquipped))
		local maxSetBonus = numBonuses + 2 - maxEquipped 
		for i = 0, maxSetBonus do
			local _, bonusDescription = GetItemLinkSetBonusInfo(itemLink, false, maxEquipped - 1 + i)
			tooltip:AddLine(bonusDescription, tooltip:GetStyle("activeBonus"))
		end
	end

    if TamrielTradeCentre ~= nil then
		tooltip:AddLine(zo_strformat("|cf23d8eTCC:|r"))
        local priceInfo = TamrielTradeCentrePrice:GetPriceInfo(itemLink)
    
        if (priceInfo == nil) then
			tooltip:AddLine(zo_strformat("|cf23d8e<<1>>|r", GetString(TTC_PRICE_NOLISTINGDATA)))
        else
          if (priceInfo.SuggestedPrice ~= nil) then
			tooltip:AddLine(zo_strformat("|cf23d8e<<1>>|r", string.format(GetString(TTC_PRICE_SUGGESTEDXTOY), 
              TamrielTradeCentre:FormatNumber(priceInfo.SuggestedPrice, 0), TamrielTradeCentre:FormatNumber(priceInfo.SuggestedPrice * 1.25, 0))))
          end

          if (true) then 
			tooltip:AddLine(zo_strformat("|cf23d8e<<1>>|r", string.format(GetString(TTC_PRICE_AGGREGATEPRICESXYZ), TamrielTradeCentre:FormatNumber(priceInfo.Avg), 
              TamrielTradeCentre:FormatNumber(priceInfo.Min), TamrielTradeCentre:FormatNumber(priceInfo.Max)))) 
          end

          if (true) then
            if (priceInfo.EntryCount ~= priceInfo.AmountCount) then 
				tooltip:AddLine(zo_strformat("|cf23d8e<<1>>|r", string.format(GetString(TTC_PRICE_XLISTINGSYITEMS), TamrielTradeCentre:FormatNumber(priceInfo.EntryCount), TamrielTradeCentre:FormatNumber(priceInfo.AmountCount)))) 
              tooltip:AddLine()
            else
				tooltip:AddLine(zo_strformat("|cf23d8e<<1>>|r", string.format(GetString(TTC_PRICE_XLISTINGS), TamrielTradeCentre:FormatNumber(priceInfo.EntryCount)))) 
            end
          end
        end
 
    end 
	
	if MasterMerchant ~= nil then 
		tooltip:AddLine(zo_strformat("|c7171d1MM:|r"))
		local tipLine, avePrice, graphInfo = MasterMerchant:itemPriceTip(itemLink, false, false)
		if(tipLine ~= nil) then
			tooltip:AddLine(zo_strformat("|c7171d1<<1>>|r", tipLine))
		else
			tooltip:AddLine(zo_strformat("|c7171d1MM price (0 sales, 0 days): UNKNOWN|r"))
		end

		local craftInfo = MasterMerchant:itemCraftPriceTip(itemLink)
		if craftInfo ~= nil then
			tooltip:AddLine(zo_strformat("|c7171d1<<1>>|r", craftInfo)) 
		end	
		
        if GetItemLinkItemType(itemLink) == ITEMTYPE_RECIPE then
			local resultItemLink = GetItemLinkRecipeResultItemLink(itemLink)
			
			local tipLine, avePrice, graphInfo = MasterMerchant:itemPriceTip(resultItemLink, false, false)
			if(tipLine ~= nil) then
				tooltip:AddLine(zo_strformat("|c7171d1Product <<1>>|r", tipLine))  
			else
				tooltip:AddLine(zo_strformat("|c7171d1Product MM price (0 sales, 0 days): UNKNOWN|r")) 
			end
		end
	end
end

function InventoryHook(tooltip, method)
  -- local origMethod = tooltip[method]

  -- tooltip[method] = function(self, ...)
  --   AddInventoryPreInfo(self, linkFunc(...))
  --   origMethod(self, ...) 
  -- end

  local origMethod = tooltip[method]
  tooltip[method] = function(control, bagId, slotIndex, ...) 
    AddInventoryPreInfo(control, bagId, slotIndex, ...)
    origMethod(control, bagId, slotIndex, ...)            
  end
end

function InventoryMenuHook(tooltip, method) 
  local origMethod = tooltip[method]
  tooltip[method] = function(selectedData, ...) 
    origMethod(selectedData, ...)  
	if tooltip.selectedEquipSlot then
		--d("eslot: " .. tooltip.selectedEquipSlot)
		GAMEPAD_TOOLTIPS:LayoutBagItem(GAMEPAD_LEFT_TOOLTIP, BAG_WORN, tooltip.selectedEquipSlot)
	end
	  
  end
end

local function LoadModules() 
  if(not _initialized) then
    InventoryHook(GAMEPAD_TOOLTIPS:GetTooltip(GAMEPAD_LEFT_TOOLTIP), "LayoutBagItem")
	InventoryMenuHook(GAMEPAD_INVENTORY, "UpdateCategoryLeftTooltip")
	
    InventoryHook(GAMEPAD_TOOLTIPS:GetTooltip(GAMEPAD_RIGHT_TOOLTIP), "LayoutBagItem")
    InventoryHook(GAMEPAD_TOOLTIPS:GetTooltip(GAMEPAD_MOVABLE_TOOLTIP), "LayoutBagItem")
    RefreshResearchData()
    CacheItemTraits() 

    --test
    GPB_EntryIcon:New()
    GPB_FastTeleport:New()
  
    --d("entry icon newed")
    _initialized = true

  end
end

--event triggered on addons loaded; function to sort through all incoming loaded addons, and only call function for the correct one
local function triggerAddonLoaded(eventCode, addonName)
  if  (addonName == GamePadBuddyData.name) then
    --unregister initialization event
    EVENT_MANAGER:UnregisterForEvent(GamePadBuddyData.name, EVENT_ADD_ON_LOADED);


    if(IsInGamepadPreferredMode()) then
      LoadModules()
    else
      _initialized = false
    end
  end
end

----------------------------------
--PULL/DATA PROCESSING FUNCTIONS--
----------------------------------

--function to convert time from seconds (pulled from API) to seconds, minutes, hours
local function convertTime(seconds)
  --initialize new variables
  local minutes, hours = 0, 0;
  --control for odd server bugs (negative time or above 24 hours)
  if (seconds < 0) or (seconds >= 86400) then
    seconds, minutes, hours = 0, 0, 0;
  --assuming nothing is going wrong, continue
  else  
    minutes = math.floor(seconds / 60);
    hours = math.floor(minutes / 60);
  
    if seconds >= 60 then
     seconds = seconds % 60;
    end
  
    if minutes >= 60 then
      minutes = minutes % 60;
    end
  end
  --seconds, minutes, and hours are returned separately
  return seconds, minutes, hours;
end

------------------
--CHAT FUNCTIONS--
------------------

--function activated by "/gpb"
local function commandExec()
  --CHAT_SYSTEM:AddMessage("|cffffff test u|r");
end

ZO_GamepadSkillLineXpBar_Setup = function(skillType, skillLineIndex, xpBar, nameControl, forceInit)
    local name, lineRank = GetSkillLineInfo(skillType, skillLineIndex)
    local lastXP, nextXP, currentXP = GetSkillLineXPInfo(skillType, skillLineIndex)    
    ZO_SkillInfoXPBar_SetValue(xpBar, lineRank, lastXP, nextXP, currentXP, forceInit)
    if nameControl then
        nameControl:SetText(zo_strformat(SI_SKILLS_ENTRY_LINE_NAME_FORMAT, name))
    end
	--CHAT_SYSTEM:AddMessage("|cffffff test u1|r");
end
  

----------------------
--EVENT REGISTRATION--
----------------------

--register the slash command "/fence" to allow user command to do things
SLASH_COMMANDS["/gpb"] = commandExec
--register events to update addon when loaded, when stolen items are removed while arrested, or when any item slot is updated
EVENT_MANAGER:RegisterForEvent(GamePadBuddyData.name, EVENT_ADD_ON_LOADED, triggerAddonLoaded);  
EVENT_MANAGER:RegisterForEvent(GamePadBuddyData.name, EVENT_GAMEPAD_PREFERRED_MODE_CHANGED, function(code, inGamepad)  LoadModules() end)