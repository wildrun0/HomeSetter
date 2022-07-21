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
		Player:SendMessageFailure("The home name is too long")
		return true
	end
    local homename = (#command ~= 2 and "home" or command[2])
	if TpPlayerHome(Player, homename) then
		Player:SendMessageSuccess("Teleported to @d" .. homename)
	else
		Player:SendMessageFailure("Home '" .. homename .. "' not found!")
	end
	return true
end


function SetHome(command, Player)
	if #command > 2 then
		Player:SendMessageFailure("The home name is too long")
		return true
	end

    local homename = (#command ~= 2 and "home" or command[2])
	local PlayerPos = {Player:GetPosX(), Player:GetPosY(), Player:GetPosZ()}
	local sethome_state = SetPlayerHome(
		Player, homename, cJson:Serialize(PlayerPos)
	)
	
	if sethome_state == nil then
		Player:SendMessageFailure("Maximum homes have been set!")
	elseif sethome_state == true then
		Player:SendMessageSuccess("@aHome set!")
	else
		Player:SendMessageFailure("Home already exist!")
	end
	return true
end


function DelHome(command, Player)
	if #command > 2 then
		Player:SendMessageFailure("The home name is too long")
		return true
	end
	local homename = (#command ~= 2 and "home" or command[2])
	if DelPlayerHome(Player:GetName(), homename) then
		Player:SendMessageSuccess("Home deleted!")
	else
		Player:SendMessageFailure("Home not found!")
	end
	return true
end


function ViewHomes(_, Player)
	local homes, homesCounter = ListOfHomes(Player:GetName())
	local phrase = string.format("Your homes(%d): %s", homesCounter, homes)
	Player:SendMessage(phrase)
	return true
end


function OnDisable()
	DB:close()
end