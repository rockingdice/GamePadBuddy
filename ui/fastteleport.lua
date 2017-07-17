
function TeleportToZone(targetZoneId)
	for index = 1, GetNumGuilds() do
		local guildId = GetGuildId(index)		
		local numMembers,numOnline,_ = GetGuildInfo(number guildId)
		for memberIndex = 1, numMembers do
			local memberName, _, _, playerStatus, _ = GetGuildMemberInfo(guildId, memberIndex)
			
			if playerStatus ~= PLAYER_STATUS_OFFLINE then
				hasCharacter, characterName, _, _, _, _, _, zoneId = GetGuildMemberCharacterInfo(guildId, memberIndex)
				if zoneId == targetZoneId then
					JumpToGuildMember(memberName)
					return true
				end
			end
		end
	end
	return false
end