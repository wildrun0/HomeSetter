local croot = cRoot:Get()


local function checkPerms(Player)
    local PlayerHomes = #getUserHomes(Player:GetName())
    local PlayerPermissions = Player:GetPermissions()

    for i = 1, #PlayerPermissions do
        if PlayerPermissions[i] == "*" then
            return true
        elseif string.find(PlayerPermissions[i], "homesetter.maxhomes.") then
            local amount = string.sub(PlayerPermissions[i], -1)
            if amount == "*" then
                return true
            else
                return (PlayerHomes < tonumber(amount))
            end
        end
    end
    return (PlayerHomes < 3) -- default maximum (if permission was deleted/not found)
end


function SetPlayerHome(Player, HomeName, pos)
    if not checkPerms(Player) then
        return nil
    end
    if doesExist(Player:GetName(), HomeName) then
        return false
    else
        saveHome(Player, HomeName, pos)
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
    for i = 1, #default_group do
        if string.find(default_group[i], "homesetter.") then
            return
        end
    end
    cRankManager:AddPermissionToGroup("homesetter.maxhomes.3",  default_rank_name)
    cRankManager:AddPermissionToGroup("homesetter.home",        default_rank_name)
    cRankManager:AddPermissionToGroup("homesetter.homes",       default_rank_name)
    cRankManager:AddPermissionToGroup("homesetter.sethome",     default_rank_name)
    cRankManager:AddPermissionToGroup("homesetter.delhome",     default_rank_name)
    LOG("Default permissions set!")
end