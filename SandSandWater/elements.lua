add_cell(0.1, 0.1, 0.1, "Empty", true, function() end, "O2", "")

add_cell(0.9, 0.9, 0.9, "Wall", false, function() end, "Walllllll", "Solid")

add_cell(0.9, 0.9, 0, "Sand", false, function(x, y, id)
    if get_cell(x, y+1) == 1 then
        set_cell(x, y, 1)
        set_cell(x, y+1, id)
    elseif get_cell(x, y+1) == 5 then
        set_cell(x, y, 5)
        set_cell(x, y+1, id)
    else
        local dir = 1
        if math.random(1, 2) == 1 then
            dir = -1
        end
        local cell = get_cell(x+dir, y+1)
        if cell == 1 or cell == 5 then
            set_cell(x, y, cell)
            set_cell(x+dir, y+1, id)
        elseif get_cell(x-dir, y+1) == 1 then
            cell = get_cell(x-dir, y+1)
            set_cell(x, y, cell)
            set_cell(x-dir, y+1, id)
        end
    end
end, "Its sand...", "powder")

add_cell(0.5, 0.5, 0.5, "Stone", false, function(x, y, id)
    if get_cell(x, y+1) == 1 then
        set_cell(x, y, 1)
        set_cell(x, y+1, id)
    elseif get_cell(x, y+1) == 5 then
        set_cell(x, y, 5)
        set_cell(x, y+1, id)
    end
end, "Stoney", "stone")

add_cell(0, 0, 0.9, "Water", false, function(x, y, id)
    if get_cell(x, y+1) == 1 then
        set_cell(x, y, 1)
        set_cell(x, y+1, id)
    elseif get_cell(x, y+1) == 6 then
        set_cell(x, y, 6)
        set_cell(x, y+1, id)
    else
        local dir = 1
        if math.random(1, 2) == 1 then
            dir = -1
        end
        if get_cell(x+dir, y) == 1 then
            set_cell(x, y, 1)
            set_cell(x+dir, y, id)
        elseif get_cell(x-dir, y) == 1 then
            set_cell(x, y, 1)
            set_cell(x-dir, y, id)
        end
    end
end, "Water yummy >:)", "liquid")

add_cell(0.3, 0.3, 0.3, "Steam", false, function(x, y, id)
    if get_cell(x, y-1) == 1 then
        set_cell(x, y, 1)
        set_cell(x, y-1, id)
    elseif get_cell(x, y-1) == 5 then
        set_cell(x, y, 5)
        set_cell(x, y-1, id)
    else
        local dir = 1
        if math.random(1, 2) == 1 then
            dir = -1
        end
        if get_cell(x+dir, y) == 1 then
            set_cell(x, y, 1)
            set_cell(x+dir, y, id)
        elseif get_cell(x-dir, y) == 1 then
            set_cell(x, y, 1)
            set_cell(x-dir, y, id)
        end
    end
    if math.random(1, 2000) == 1 then
        set_cell(x, y, 5)
    end
end, "Steamy", "gas")

add_cell(0.8, 0, 0, "Void", true, function(x, y, id)
    set_cell(x+1, y, 1, {}, {id, 2})
    set_cell(x, y+1, 1, {}, {id, 2})
    set_cell(x+1, y+1, 1, {}, {id, 2})
    set_cell(x-1, y, 1, {}, {id, 2})
    set_cell(x, y-1, 1, {}, {id, 2})
    set_cell(x-1, y-1, 1, {}, {id, 2})
    set_cell(x-1, y+1, 1, {}, {id, 2})
    set_cell(x+1, y-1, 1, {}, {id, 2})
end, "The void will consume you.", "Solid")

add_cell(1, 1, 0, "Creater", false, function(x, y, id)
    -- set_cell_data(x, y, {ctype = 3})
    local randomposs = {{1, 0}, {0, 1}, {1, 1}, {-1, 0}, {0, -1}, {-1, -1}, {1, -1}, {-1, 1}}
    local randompos = randomposs[math.random(1, 8)]
    local randomposx = randompos[1]
    local randomposy = randompos[2]
    if get_cell(x, y, true).ctype == nil then
        local cctype = get_cell(x + randomposx, y + randomposy)
        if cctype == 1 or cctype == 2 or cctype == id then
        else
            set_cell_data(x, y, {ctype = cctype})
        end
    elseif get_cell(x + randomposx, y + randomposy) == 1 and math.random(1, 2) == 1 then
        set_cell(x + randomposx, y + randomposy, get_cell(x, y, true).ctype)
    end
end, "Creates things", "Solid")

add_cell(0, 0.8, 0, "Plant", false, function(x, y, id)
    -- set_cell_data(x, y, {ctype = 3})
    local randomposs = {{1, 0}, {0, 1}, {1, 1}, {-1, 0}, {0, -1}, {-1, -1}, {1, -1}, {-1, 1}}
    local randompos = randomposs[math.random(1, 8)]
    local randomposx = randompos[1]
    local randomposy = randompos[2]
    if get_cell(x + randomposx, y + randomposy) == 5 and math.random(1, 2) == 1 then
        set_cell(x + randomposx, y + randomposy, id)
    end
end, "Feed with water", "organic")

add_cell(0, 1, 0, "Super Plant", false, function(x, y, id)
    -- set_cell_data(x, y, {ctype = 3})
    local randomposs = {{1, 0}, {0, 1}, {1, 1}, {-1, 0}, {0, -1}, {-1, -1}, {1, -1}, {-1, 1}}
    local randompos = randomposs[math.random(1, 8)]
    local randomposx = randompos[1]
    local randomposy = randompos[2]
    if get_cell(x + randomposx, y + randomposy) == 1 and math.random(1, 2) == 1 then
        set_cell(x + randomposx, y + randomposy, id)
    end
end, "Feed with air", "organic")

add_cell(1, 0, 1, "Virus 1", false, function(x, y, id)
    -- set_cell_data(x, y, {ctype = 3})
    local randomposs = {{1, 0}, {0, 1}, {1, 1}, {-1, 0}, {0, -1}, {-1, -1}, {1, -1}, {-1, 1}}
    local randompos = randomposs[math.random(1, 8)]
    local randomposx = randompos[1]
    local randomposy = randompos[2]
    local cell = get_cell(x + randomposx, y + randomposy)
    if cell ~= 1 and cell ~= 2 and math.random(1, 2) == 1 then
        set_cell(x + randomposx, y + randomposy, id)
    end
end, "Virus", "solid")

add_cell(0, 1, 1, "Virus 2", false, function(x, y, id)
    -- set_cell_data(x, y, {ctype = 3})
    local randomposs = {{1, 0}, {0, 1}, {1, 1}, {-1, 0}, {0, -1}, {-1, -1}, {1, -1}, {-1, 1}}
    local randompos = randomposs[math.random(1, 8)]
    local randomposx = randompos[1]
    local randomposy = randompos[2]
    local cell = get_cell(x + randomposx, y + randomposy)
    if cell ~= 1 and cell ~= 2 and math.random(1, 2) == 1 then
        set_cell(x + randomposx, y + randomposy, id)
    end
end, "Virus", "solid")

add_cell(150/255, 111/255, 51/255, "Wood", false, function() end, "Flameble", "organic")
add_cell(0.3, 0.3, 0.3, "Smoke", false, function(x, y, id)
    if get_cell(x, y-1) == 1 then
        set_cell(x, y, 1)
        set_cell(x, y-1, id)
    elseif get_cell(x, y-1) == 5 then
        set_cell(x, y, 5)
        set_cell(x, y-1, id)
    else
        local dir = 1
        if math.random(1, 2) == 1 then
            dir = -1
        end
        if get_cell(x+dir, y) == 1 then
            set_cell(x, y, 1)
            set_cell(x+dir, y, id)
        elseif get_cell(x-dir, y) == 1 then
            set_cell(x, y, 1)
            set_cell(x-dir, y, id)
        end
    end

    if math.random(1, 250) == 1 then
        set_cell(x, y, 1)
    end
end, "CO2", "gas")

add_cell(1, 0, 0, "Fire", false, function(x, y, id)
    local cell = get_cell(x+1, y)
    if contains({9, 10, 13, 14, 17}, cell) and math.random(1, 4) == 1 then
        set_cell(x+1, y, id)
    end
    cell = get_cell(x-1, y)
    if contains({9, 10, 13, 14, 17}, cell) and math.random(1, 4) == 1 then
        set_cell(x-1, y, id)
    end
    cell = get_cell(x, y-1)
    if contains({9, 10, 13, 14, 17}, cell) and math.random(1, 4) == 1 then
        set_cell(x, y-1, id)
    end
    cell = get_cell(x, y+1)
    if contains({9, 10, 13, 14, 17}, cell) and math.random(1, 4) == 1 then
        set_cell(x, y+1, id)
    end
    cell = get_cell(x+1, y+1)
    if contains({9, 10, 13, 14, 17}, cell) and math.random(1, 4) == 1 then
        set_cell(x+1, y, id)
    end
    cell = get_cell(x-1, y+1)
    if contains({9, 10, 13, 14, 17}, cell) and math.random(1, 4) == 1 then
        set_cell(x-1, y, id)
    end
    cell = get_cell(x+1, y-1)
    if contains({9, 10, 13, 14, 17}, cell) and math.random(1, 4) == 1 then
        set_cell(x, y-1, id)
    end
    cell = get_cell(x-1, y+1)
    if contains({9, 10, 13, 14, 17}, cell) and math.random(1, 4) == 1 then
        set_cell(x, y+1, id)
    end

    local near_water, locs_water = is_near_cell(x, y, 5)
    if near_water then
        set_cell(x, y, 1)
        for _, loc_water in ipairs(locs_water) do
            set_cell(loc_water[1], loc_water[2], 6)
        end
    end

    if math.random(1, 16) == 1 then
        set_cell(x, y, 1)
        if math.random(1, 2) == 1 and get_cell(x, y-1) == 1 then
            set_cell(x, y-1, 14)
        end
    else
        --[[
        if math.random(1, 4) == 1 then
            set_cell(x, y, 1)
            set_cell(x, y-1, id)
        end
        ]]--
    end
end, "Firery", "gas", {}, function(x, y, id)
    -- local g = math.random(90, 100)/100
    -- set_cell_data(x, y, {color = {g, 0, 0}})
end)

add_cell(1, 1, 1, "Rainbowium", false, function(x, y, id) end, "RAINBOW!!!!!", "solid", nil, nil, function(x, y, id)
    local r, g, b = HSV(
        (((x/16) + (y/16) + (love.timer.getTime()*2)) / 8) % 1,
        0.2+(math.sin((-x/0.5) + (y/0.5))/12),
        0.85
    )
    return r, g, b
end)

add_cell(0.95, 0.95, 0.95, "Paper", false, function(x, y, id)
    local near_water, locs_water = is_near_cell(x, y, 5)
    if near_water then
        set_cell(x, y, id+1)
        -- for _, loc_water in ipairs(locs_water) do
        --     set_cell(loc_water[1], loc_water[2], 1)
        -- end
    else
        local near_wet_paper, _ = is_near_cell(x, y, id+1)
        if near_wet_paper and math.random(1, 16) == 1 then
            set_cell(x, y, id+1)
        end
    end
end, "", "organic", {}, function(x, y, id)
    local g = math.random(90, 100)/100
    set_cell_data(x, y, {color = {g, g, g}})
end)

add_cell(0.75, 0.75, 0.75, "Wet Paper", false, function(x, y, id)
    -- if math.random(1, 1000) == 1 then
    --     set_cell(x, y, id-1)
    -- end
end, "", "organic", {}, function(x, y, id)
    local g = math.random(70, 80)/100
    set_cell_data(x, y, {color = {g, g, g}})
end)

add_cell(0.4, 0.4, 0.4, "Gunpowder", false, function(x, y, id)
    if get_cell(x, y+1) == 1 then
        set_cell(x, y, 1)
        set_cell(x, y+1, id)
    elseif get_cell(x, y+1) == 5 then
        set_cell(x, y, 5)
        set_cell(x, y+1, id)
    else
        local dir = 1
        if math.random(1, 2) == 1 then
            dir = -1
        end
        local cell = get_cell(x+dir, y+1)
        if cell == 1 or cell == 5 then
            set_cell(x, y, cell)
            set_cell(x+dir, y+1, id)
        elseif get_cell(x-dir, y+1) == 1 then
            cell = get_cell(x-dir, y+1)
            set_cell(x, y, cell)
            set_cell(x-dir, y+1, id)
        end
    end

    local near_fire, _ = is_near_cell(x, y, 15)
    if near_fire then
        set_cell(x, y, 1)
        dropper(x, y, 15, 2)
    end
end, "Boom!", "powder")

--[[
-- V debug test thing V
for b=0, 5 do
    for g=0, 5 do
        for r=0, 5 do
            add_cell(r/5, g/5, b/5, tostring(r/5) .. " " .. tostring(g/5) .. " " .. tostring(b/5), true, function(x, y, id)
                if get_cell(x, y+1) == 1 then
                    set_cell(x, y, 1)
                    set_cell(x, y+1, id)
                elseif get_cell(x, y+1) == 5 then
                    set_cell(x, y, 5)
                    set_cell(x, y+1, id)
                end
            end)
        end
    end
end
]]--
