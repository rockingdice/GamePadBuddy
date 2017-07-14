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

function GPB_EntryIcon:HookInventory()
	--Other addons are causing setupCallback to be called too many times 
		ZO_GamepadInventoryList.entrySetupCallback = function(control, entryData, ...)
			CHAT_SYSTEM:AddMessage("|cffffff test 3 ")
			local c = control:GetNamedChild("GPBEntryIcon")
			if c then
				c:SetHidden(true)
			end
			if c == nil then
				c = CreateControlFromVirtual("$(parent)GPBEntryIcon", control, "GPB_EntryIcon")
			end
			if c then
				c:ClearAnchors() 
				c:SetAnchor(RIGHT, control:GetNamedChild("icon"), LEFT, -10, 0) 
				c:SetDimensions(30, 30)
				c:SetHidden(false)				
			end
		end
		
	
end
