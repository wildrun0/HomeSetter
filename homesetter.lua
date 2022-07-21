PLUGIN = nil


function Initialize(Plugin)
	PLUGIN = Plugin
	Plugin:SetName("HomeSetter")
	Plugin:SetVersion(1)

	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	RegisterPluginInfoCommands()

	SetPermissions()

    LOG(Plugin:GetName() .. " v." .. Plugin:GetVersion() .. " loaded!")
	return true
end


function TpHome(command, Player)
	if #command > 2 then
		Player:SendMessageFailure("@cThe home name is too long")
		return true
	end
    local homename = (#command ~= 2 and "home" or command[2])
	if TpPlayerHome(Player, homename) then
		Player:SendMessageSuccess("@aTeleported to @d" .. homename)
	else
		Player:SendMessageFailure("@cHome not found!")
	end
	return true
end


function SetHome(command, Player)
	if #command > 2 then
		Player:SendMessageFailure("@cThe home name is too long")
		return true
	end

    local homename = (#command ~= 2 and "home" or command[2])
	local PlayerPos = {Player:GetPosX(), Player:GetPosY(), Player:GetPosZ()}
	local sethome_state = SetPlayerHome(
		Player, homename, cJson:Serialize(PlayerPos)
	)
	
	if sethome_state == nil then
		Player:SendMessageFailure("@cMaximum homes have been set!")
	elseif sethome_state then
		Player:SendMessageSuccess("@aHome set!")
	else
		Player:SendMessageFailure("@cHome already exist!")
	end
	return true
end


function DelHome(command, Player)
	if #command > 2 then
		Player:SendMessageFailure("@cThe home name is too long")
		return true
	end
	local homename = (#command ~= 2 and "home" or command[2])
	if DelPlayerHome(Player:GetName(), homename) then
		Player:SendMessageSuccess("@aHome deleted!")
	else
		Player:SendMessageFailure("@cHome not found!")
	end
	return true
end


function ViewHomes(_, Player)
	local homes = getUserHomes(Player:GetName())
	Player:SendMessage(
		string.format("Your homes(%d): %s", #homes, table.concat(homes, ', '))
	)
	return true
end


function OnDisable()
	LOG("Bye! :)")
	DB:close()
end