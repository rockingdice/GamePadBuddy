GPB_EntryIcon = ZO_Object:Subclass()

function GPB_EntryIcon:New(...)
	CHAT_SYSTEM:AddMessage("|cffffff test 1 ")
    local object = ZO_Object.New(self)
    object:Initialize(...)
    return object
end

function GPB_EntryIcon:Initialize()
	CHAT_SYSTEM:AddMessage("|cffffff test 2 ")
	self:HookInventory()
end

function GPB_EntryIcon:ModifyEntryTemplate(templateName)
	local itemList = GAMEPAD_INVENTORY.itemList;
	
	local dataTypes = ZO_ScrollList_GetDataTypeTable(itemList, templateName)
  
	local original = dataTypes.setupFunction
	
	dataTypes.setupFunction = function(control, data, ...)
		original(control, data, ...)
		--CHAT_SYSTEM:AddMessage("|cffffff " .. control.key .. "," .. control.templateName .. "," .. control.dataIndex)
		local c = control:GetNamedChild("GPBEntryIcon")
		if c then
			c:SetHidden(true)
		end
		local label = control:GetNamedChild("Label")
		if c == nil then
			c = CreateControlFromVirtual("$(parent)GPBEntryIcon", control, "GPB_EntryIcon")
			c:SetDimensions(30, 30)	
			local w = label:GetWidth()
			label:SetWidth(w-30)
		end
		if c then 
			c:ClearAnchors() 
			c:SetAnchor(LEFT, label, RIGHT, 0, 0) 
			c:SetHidden(false)
			local tex_research = c:GetNamedChild("Research")
			local tex_intricate = c:GetNamedChild("Intricate")
			local tex_ornate = c:GetNamedChild("Ornate")
			tex_research:SetHidden(true)
			tex_intricate:SetHidden(true)
			tex_ornate:SetHidden(true)
			
			local bag = data.bagId
			local slotIndex = data.slotIndex
			local traitStatus = GamePadBuddy:GetItemTraitStatus(bag, slotIndex)
 
			if traitStatus == GamePadBuddy.CONST.TraitStatus.TRAIT_STATUS_ORNATE then
				tex_ornate:SetHidden(false)
			elseif traitStatus == GamePadBuddy.CONST.TraitStatus.TRAIT_STATUS_INTRICATE then
				tex_intricate:SetHidden(false)
			else
				tex_research:SetHidden(false)
				if traitStatus == GamePadBuddy.CONST.TraitStatus.TRAIT_STATUS_RESEARABLE then 
				  tex_research:SetColor(0, 255, 0)
				elseif traitStatus == GamePadBuddy.CONST.TraitStatus.TRAIT_STATUS_DUPLICATED then 
				  tex_research:SetColor(255, 255, 0)
				elseif traitStatus == GamePadBuddy.CONST.TraitStatus.TRAIT_STATUS_KNOWN then 
				  tex_research:SetColor(255, 0, 0)
				elseif traitStatus == GamePadBuddy.CONST.TraitStatus.TRAIT_STATUS_RESEARCHING then 
				  tex_research:SetColor(253, 154, 0)
				else
					c:SetHidden(true)
				end
			end
		end
	end
end

function GPB_EntryIcon:HookEntrySetup()
	self:ModifyEntryTemplate("ZO_GamepadItemSubEntryTemplate")
	self:ModifyEntryTemplate("ZO_GamepadItemSubEntryTemplateWithHeader")
end

function GPB_EntryIcon:HookInventory()
	--Inventory GUI is not initialized at first, so override initialze function to make the hook.
	--Because list doesn't have a callback
	local o1 = ZO_GamepadInventory.RefreshItemList
	ZO_GamepadInventory.RefreshItemList = function(...)
		d("RefreshItemList")
		GPB_EntryIcon:HookEntrySetup()
		o1(...)	
	end
	 
end
