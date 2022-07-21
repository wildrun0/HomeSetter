local croot = cRoot:Get()


local function checkPerms(Player)
    local max_value = 3

    local PlayerUUID = Player:GetUUID()
    local PlayerGroup = cRankManager:GetPlayerRankName(PlayerUUID)
    local PlayerPermissions = cRankManager:GetRankPermissions(PlayerGroup)

    for _, perm in pairs(PlayerPermissions) do
        if perm == "*" then
            max_value = 1e309 -- let's consider it as infinity :)
        elseif string.find(perm, "homesetter.maxhomes.") then
            local amount = string.sub(perm, -1)
            if amount == "*" then
                max_value = 1e309
            else
                max_value = tonumber(string.sub(perm, -1))
            end
            break
        end
    end

    local player_homes = #getUserHomes(Player:GetName())
    return (player_homes < max_value)
end


function SetPlayerHome(Player, HomeName, pos)
    if not checkPerms(Player) then
        return nil
    end
    if doesExist(Player:GetName(), HomeName) then
        return false
    else
        saveHome(Player:GetName(), Player:GetWorld():GetName(), HomeName, pos)
        return true
    end
end


function DelPlayerHome(PlayerName, HomeName)
    if doesExist(PlayerName, HomeName) then
        deleteHome(PlayerName, HomeName)
        return true
    end
    return false
end


function TpPlayerHome(Player, HomeName)
    local PlayerName = Player:GetName()
    if doesExist(PlayerName, HomeName) then
        local world, x, y, z  = getHomePos(PlayerName, HomeName)
        if world ~= Player:GetWorld():GetName() then
            local cworld = croot:GetWorld(world)
            local VectorCoords = Vector3d(x, y, z)
            Player:MoveToWorld(cworld, true, VectorCoords)
        else
            Player:TeleportToCoords(x, y, z)
        end
        return true
    end
    return false
end


function SetPermissions()
    local default_rank_name = "Default"
    local default_group = cRankManager:GetGroupPermissions(default_rank_name)
    local perm_found = false
    for _, perm in pairs(default_group) do
        if string.find(perm, "homesetter.") then
            perm_found = true
            break
        end
    end
    if not perm_found then
        cRankManager:AddPermissionToGroup("homesetter.maxhomes.3",  default_rank_name)
        cRankManager:AddPermissionToGroup("homesetter.home",        default_rank_name)
        cRankManager:AddPermissionToGroup("homesetter.homes",       default_rank_name)
        cRankManager:AddPermissionToGroup("homesetter.sethome",     default_rank_name)
        cRankManager:AddPermissionToGroup("homesetter.delhome",     default_rank_name)
        LOG("Default permissions set!")
    end
end