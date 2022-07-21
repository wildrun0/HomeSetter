DB = sqlite3.open(cPluginManager:Get():GetCurrentPlugin():GetLocalFolder() .. "/data.sqlite")
DB_TABLE_EXIST = false


function doesExist(name, homename)
    if not DB_TABLE_EXIST then
        for _ in DB:urows("SELECT * FROM sqlite_master WHERE name='homes'") do
            DB_TABLE_EXIST = true
        end
    end
    if not DB_TABLE_EXIST then
        DB:exec("CREATE TABLE homes (playername, playerworld, homename, homepos)")
        return false
    else
        local stmt = DB:prepare[[
            SELECT count(*) FROM 'homes' WHERE homename = ? AND playername = ?
        ]]
        stmt:bind_values(homename, name)
        for count in stmt:urows() do
            return (count > 0 and true or false)
        end
    end
end


function saveHome(PlayerName, PlayerWorldName, HomeName, Coords)
    local stmt = DB:prepare[[
        INSERT INTO homes VALUES(?, ?, ?, ?);
    ]]
    stmt:bind_values(PlayerName, PlayerWorldName, HomeName, Coords)
    for data in stmt:rows() do
        -- luasqlite3 moment
        -- If you don't iterate, nothing will work
        -- Even if it doesn't make sense to iterate
    end
    stmt:finalize()
end


function deleteHome(PlayerName, HomeName)
    local stmt = DB:prepare[[
        DELETE from homes WHERE playername = ? AND homename = ?
    ]]
    stmt:bind_values(PlayerName, HomeName)
    for data in stmt:rows() do end
    stmt:finalize()
end


function getHomePos(PlayerName, HomeName)
    local stmt = DB:prepare[[
        SELECT homepos, playerworld FROM 'homes' WHERE homename = ? AND playername = ?
    ]]
    stmt:bind_values(HomeName, PlayerName)
    for pos, world in stmt:urows() do
        local coords = cJson:Parse(pos)
        return world, coords[1], coords[2], coords[3]
    end
end


function getUserHomes(PlayerName)
    local stmt = DB:prepare[[
        SELECT homename FROM 'homes' WHERE playername = ?
    ]]
    stmt:bind_values(PlayerName)
    local homes = {}
    for homename in stmt:urows() do
        table.insert(homes, homename)
    end
    return homes
end