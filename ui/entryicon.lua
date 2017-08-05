GPB_EntryIcon = ZO_Object:Subclass()
TEMPLATE_MODE_ITEM = 1
TEMPLATE_MODE_ITEM_PRICE = 2
function GPB_EntryIcon:New(...)
    local object = ZO_Object.New(self)
    object:Initialize(...)
    return object
end

function GPB_EntryIcon:Initialize()
	self:HookInventory()
end

function GPB_EntryIcon:ModifyEntryTemplate(itemList, templateName, mode)
	if itemList == nil then return end
	
	local dataTypes = ZO_ScrollList_GetDataTypeTable(itemList, templateName)
  
	local original = dataTypes.setupFunction
	
	dataTypes.setupFunction = function(control, data, ...)
		original(control, data, ...)
		local c = control:GetNamedChild("GPBEntryIcon")
		if c then
			c:SetHidden(true)
		end
		if c == nil then
			if mode == TEMPLATE_MODE_ITEM_PRICE then
				local label = control:GetNamedChild("Label")
				local price = control:GetNamedChild("Price")
				c = CreateControlFromVirtual("$(parent)GPBEntryIcon", control, "GPB_EntryIcon")
				c:SetDimensions(40, 40)	
				local w = label:GetWidth()
				label:SetWidth(w-110)
				c:ClearAnchors() 
				c:SetAnchor(RIGHT, price, LEFT, 0, 0) 
			elseif mode == TEMPLATE_MODE_ITEM then
				local label = control:GetNamedChild("Label")
				c = CreateControlFromVirtual("$(parent)GPBEntryIcon", control, "GPB_EntryIcon")
				c:SetDimensions(40, 40)	
				local w = label:GetWidth()
				label:SetWidth(w-40)
				c:ClearAnchors() 
				c:SetAnchor(LEFT, label, RIGHT, 0, 0) 
			end
		end
		if c then 
			c:SetHidden(false)
			local tex_research = c:GetNamedChild("Research")
			local tex_intricate = c:GetNamedChild("Intricate")
			local tex_ornate = c:GetNamedChild("Ornate")
			local tex_tccquest = c:GetNamedChild("TCCQuest")
			tex_research:SetHidden(true)
			tex_intricate:SetHidden(true)
			tex_ornate:SetHidden(true)
			tex_tccquest:SetHidden(true)
			
			local bag = data.bagId
			local slotIndex = data.slotIndex
			local itemFlagStatus = GamePadBuddy:GetItemFlagStatus(bag, slotIndex)
 
			if itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_ORNATE then
				tex_ornate:SetHidden(false)
			elseif itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_INTRICATE then
				tex_intricate:SetHidden(false)
			elseif itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TCC_QUEST or
					itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TCC_USABLE or
					itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TCC_USELESS then
				tex_tccquest:SetHidden(false)
				tex_tccquest:SetColor(0, 255, 0)
				if itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TCC_USELESS then
					tex_tccquest:SetColor(255, 0, 0)
				elseif itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TCC_USABLE then
					tex_tccquest:SetColor(255, 255, 255)
				end
			else
				tex_research:SetHidden(false)
				if itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_RESEARABLE then 
				  tex_research:SetColor(0, 255, 0)
				elseif itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_DUPLICATED then 
				  tex_research:SetColor(255, 255, 0)
				elseif itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_KNOWN then 
				  tex_research:SetColor(255, 0, 0)
				elseif itemFlagStatus == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_RESEARCHING then 
				  tex_research:SetColor(253, 154, 0)
				else
					c:SetHidden(true)
				end
			end
		end
	end
end

function GPB_EntryIcon:HookEntrySetup(ui, templateName, mode)
	self:ModifyEntryTemplate(ui, templateName, mode)
	self:ModifyEntryTemplate(ui, templateName .. "WithHeader", mode)
end

function GPB_EntryIcon:HookInventory()
	--Inventory GUI is not initialized at first, so override initialze function to make the hook.
	--Because list doesn't have a callback
 	local o1 = ZO_GamepadInventory.RefreshItemList
	ZO_GamepadInventory.RefreshItemList = function(...)
		GamePadBuddy:RefreshTCCQuestData()
		GPB_EntryIcon:HookEntrySetup(GAMEPAD_INVENTORY.itemList, "ZO_GamepadItemSubEntryTemplate", TEMPLATE_MODE_ITEM)
		o1(...)	
	end  
	
	local o2 = ZO_BankingCommon_Gamepad.OnSceneShowing
	ZO_BankingCommon_Gamepad.OnSceneShowing = function(...)
		GamePadBuddy:RefreshTCCQuestData()
		GPB_EntryIcon:HookEntrySetup(GAMEPAD_BANKING.withdrawList.list, "ZO_GamepadItemSubEntryTemplate", TEMPLATE_MODE_ITEM)
		GPB_EntryIcon:HookEntrySetup(GAMEPAD_BANKING.depositList.list, "ZO_GamepadItemSubEntryTemplate", TEMPLATE_MODE_ITEM)
		o2(...)
	end
	
	
	local o3 = ZO_GamepadFenceLaunder.Refresh
	ZO_GamepadFenceLaunder.Refresh = function(...)
		GamePadBuddy:RefreshTCCQuestData()
		GPB_EntryIcon:HookEntrySetup(FENCE_LAUNDER_GAMEPAD.list, "ZO_GamepadPricedVendorItemEntryTemplate", TEMPLATE_MODE_ITEM_PRICE)
		GPB_EntryIcon:HookEntrySetup(FENCE_SELL_GAMEPAD.list, "ZO_GamepadPricedVendorItemEntryTemplate", TEMPLATE_MODE_ITEM_PRICE)
		o3(...)
	end
	
	local o4 = ZO_GamepadStoreManager.ShowComponent
	ZO_GamepadStoreManager.ShowComponent = function(...)
		GamePadBuddy:RefreshTCCQuestData()
		GPB_EntryIcon:HookEntrySetup(STORE_WINDOW_GAMEPAD.components[ZO_MODE_STORE_SELL].list, "ZO_GamepadPricedVendorItemEntryTemplate", TEMPLATE_MODE_ITEM_PRICE)
		GPB_EntryIcon:HookEntrySetup(STORE_WINDOW_GAMEPAD.components[ZO_MODE_STORE_BUY_BACK].list, "ZO_GamepadPricedVendorItemEntryTemplate", TEMPLATE_MODE_ITEM_PRICE)
		o4(...)
	end
	  
	 
	--Crafting inventory is different, just hook it at first.
	GamePadBuddy:RefreshTCCQuestData()
	GPB_EntryIcon:HookEntrySetup(SMITHING_GAMEPAD.deconstructionPanel.inventory.list, "ZO_GamepadItemSubEntryTemplate", TEMPLATE_MODE_ITEM)
	GPB_EntryIcon:HookEntrySetup(SMITHING_GAMEPAD.improvementPanel.inventory.list, "ZO_GamepadItemSubEntryTemplate", TEMPLATE_MODE_ITEM)	
	HookDestructionList()
end

function OnOpenStore()
	GamePadBuddy:RefreshTCCQuestData()
	GPB_EntryIcon:HookEntrySetup(STORE_WINDOW_GAMEPAD.components[ZO_MODE_STORE_SELL].list, "ZO_GamepadPricedVendorItemEntryTemplate", TEMPLATE_MODE_ITEM_PRICE)
	GPB_EntryIcon:HookEntrySetup(STORE_WINDOW_GAMEPAD.components[ZO_MODE_STORE_BUY_BACK].list, "ZO_GamepadPricedVendorItemEntryTemplate", TEMPLATE_MODE_ITEM_PRICE)
end

function HookDestructionList() 
	local testfunction = _G.ZO_SharedSmithingExtraction_IsExtractableOrRefinableItem
	_G.ZO_SharedSmithingExtraction_IsExtractableOrRefinableItem = function (bagId, slotIndex) 
		local isResearchItem = GamePadBuddy:GetItemFlagStatus(bagId, slotIndex) == GamePadBuddy.CONST.ItemFlags.ITEM_FLAG_TRAIT_RESEARABLE
		return testfunction(bagId, slotIndex) and not isResearchItem
	end
end
