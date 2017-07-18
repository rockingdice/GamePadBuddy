GPB_FastTeleport = ZO_Object:Subclass()

function GPB_FastTeleport:New(...)
	--CHAT_SYSTEM:AddMessage("|cffffff test 1 ")
    local object = ZO_Object.New(self)
    object:Initialize(...)
    return object
end

function GPB_FastTeleport:Initialize()
	--CHAT_SYSTEM:AddMessage("|cffffff test 2 ")
	self:hookFastTeleport()
end

function GPB_FastTeleport:hookFastTeleport() 
	GAMEPAD_WORLD_MAP_LOCATIONS.keybindStripDescriptor = 
	{
        alignment = KEYBIND_STRIP_ALIGN_LEFT,
        {
            keybind = "UI_SHORTCUT_PRIMARY",

            name = GetString(SI_GAMEPAD_SELECT_OPTION),

            callback = function()
                if GAMEPAD_WORLD_MAP_LOCATIONS.selectedData then
                    ZO_WorldMap_SetMapByIndex(GAMEPAD_WORLD_MAP_LOCATIONS.selectedData.index)
                    PlaySound(SOUNDS.MAP_LOCATION_CLICKED)
                end
            end,

            visible = function()
                return GAMEPAD_WORLD_MAP_LOCATIONS.selectedData ~= nil
            end
        }, 
		   -- Fast Teleport
        {
            name = "Fast Teleport",
            keybind = "UI_SHORTCUT_TERTIARY",
            callback = function()
					if GAMEPAD_WORLD_MAP_LOCATIONS.selectedData then
						--d("Travel to " .. GAMEPAD_WORLD_MAP_LOCATIONS.selectedData.locationName)               
						PlaySound(SOUNDS.MAP_LOCATION_CLICKED)
						local mapName, mapType, mapContentType, zoneIndex, description = GetMapInfo(GAMEPAD_WORLD_MAP_LOCATIONS.selectedData.index)
						zoneIndex = zoneIndex + 1
						--d("Zone :"..mapName .. " Zone Index:"..zoneIndex)
						local result = self:TeleportToZone(mapName)
						if result then
							ZO_WorldMap_HideWorldMap()
						end
					end
				end,
            visible = function()
					return GAMEPAD_WORLD_MAP_LOCATIONS.selectedData ~= nil
                end,
            sound = SOUNDS.GAMEPAD_MENU_FORWARD,
        },
    }
 
    ZO_Gamepad_AddBackNavigationKeybindDescriptors(GAMEPAD_WORLD_MAP_LOCATIONS.keybindStripDescriptor, GAME_NAVIGATION_TYPE_BUTTON, ZO_WorldMapInfo_OnBackPressed)
	GAMEPAD_WORLD_MAP_LOCATIONS:RefreshKeybind()
end
 

function GPB_FastTeleport:TeleportToZone(targetZoneName) 
	d("Finding members in Zone:" .. targetZoneName)
	local playerName = ZO_GetPrimaryPlayerNameFromUnitTag("player", false)
	for index = 1, GetNumGuilds() do
		local guildId = GetGuildId(index)		
		local numMembers,numOnline,_ = GetGuildInfo(guildId)
		for memberIndex = 1, numMembers do
			local memberName, _, _, playerStatus, _ = GetGuildMemberInfo(guildId, memberIndex)
			
			if playerStatus ~= PLAYER_STATUS_OFFLINE then
				hasCharacter, characterName, zoneName, _, _, _, _, zoneId = GetGuildMemberCharacterInfo(guildId, memberIndex)
				--zoneId = GetZoneId(zoneIndex)
				--d("Member:" .. memberName .. " zoneName:"..zoneName .. " zoneId:"..zoneId .. " cha:" .. playerName)
				if zoneName == targetZoneName and playerName ~= memberName then
					d("Teleporting to member:" .. memberName .. "(" .. zoneName .. ")".. " Guild:" .. GetGuildName(guildId))
					JumpToGuildMember(memberName)
					return true
				end
			end
		end
	end
	return false
end