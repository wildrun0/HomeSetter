local croot = cRoot:Get()
local strfind = string.find


local function checkPerms(Player)
    local PlayerHomes = #getUserHomes(Player:GetName())
    local PlayerPermissions = Player:GetPermissions()

    for i = 1, #PlayerPermissions do
        local PlayerPerm = PlayerPermissions[i]
        if PlayerPerm == "*" then
            return true
        elseif strfind(PlayerPerm, "homesetter.maxhomes.") then
            local amount = string.sub(PlayerPerm, -1)
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
            Player:MoveToWorld(
                croot:GetWorld(world), true, Vector3d(x, y, z)
            )
        else
            Player:SetInvulnerableTicks(2) -- to prevent getting damage because of "fall" (cuberite bug)
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
        if strfind(default_group[i], "homesetter.") then
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