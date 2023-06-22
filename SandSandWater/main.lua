w = 101
h = 101
cellsize = (805-205)/w

grid = {}

droppercell = 3

droppercellr = 1

droppersize = 2

pause = false

settings = {}

settings.outline = false
settings.void_id = 2
settings.debug_mode = true

types = {}

function contains(table, value)
    for i=1,#table do
        if table[i] == value then 
            return true
        end
    end
    return false
end

function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end

function add_cell(r, g, b, name, replace_when_place, update, description, type_, tags, on_create, on_draw)
    if description == nil then
        description = "This is " .. name
    end
    if type_ == nil then
        type_ = ""
    end
    if tags == nil then
        tags = {}
    end
    if on_create == nil then
        on_create = function(x, y, id) end
    end
    if on_draw == nil then
        on_draw = nil
    end
    table.insert(types, {r, g, b, name, replace_when_place, update, description, type_, tags, on_create, on_draw})
end

function get_cell(x, y, givedata)
    if x < 1 or x > w or y < 1 or y > h then
        return settings.void_id
    else
        if givedata == true then
            return grid[x][y][2]
        else
            return grid[x][y][1]
        end
    end
end

function set_cell(x, y, id, data, dont_replace_ids)
    if dont_replace_ids == nil then
        dont_replace_ids = {}
    end
    if x < 1 or x > w or y < 1 or y > h then
        return false
    else
        if not contains(dont_replace_ids, get_cell(x, y)) then
            if data == nil then
                grid[x][y] = {id, {}}
                types[id][10](x, y, id)
            else
                grid[x][y] = {id, data}
                types[id][10](x, y, id)
            end
        end
        return true
    end
end

function set_cell_data(x, y, data)
    if x < 1 or x > w or y < 1 or y > h then
        return false
    else
        grid[x][y][2] = data
        return true
    end
end

function move_cell(x1, y1, x2, y2)
    local cell1id = get_cell(x1, y1, false)
    local cell1data = get_cell(x1, y1, true)
    local cell2id = get_cell(x2, y2, false)
    local cell2data = get_cell(x2, y2, true)
    set_cell(x1, y1, cell2id, cell2data)
    set_cell(x2, y2, cell1id, cell1data)
end

function is_near_cell(x, y, id)
    local is_near = false
    local locs = {}
    if get_cell(x, y-1) == id then
        is_near = true
        table.insert(locs, {x, y})
    end
    if get_cell(x+1, y-1) == id then
        is_near = true
        table.insert(locs, {x, y})
    end
    if get_cell(x+1, y) == id then
        is_near = true
        table.insert(locs, {x, y})
    end
    if get_cell(x+1, y+1) == id then
        is_near = true
        table.insert(locs, {x, y})
    end
    if get_cell(x, y+1) == id then
        is_near = true
        table.insert(locs, {x, y})
    end
    if get_cell(x-1, y+1) == id then
        is_near = true
        table.insert(locs, {x, y})
    end
    if get_cell(x-1, y) == id then
        is_near = true
        table.insert(locs, {x, y})
    end
    if get_cell(x-1, y-1) == id then
        is_near = true
        table.insert(locs, {x, y})
    end
    return is_near, locs
end

function dropper(x, y, id, size)
    for ypos = -size, size do
        for xpos = -size, size do
            if get_cell(x + xpos, y + ypos) == 1 or types[id][5] then
                set_cell(x + xpos, y + ypos, id)
            end
        end
    end
end

function update_world()
    for i = 1, w*h do
        local x = math.random(1, w)
        local y = math.random(1, h)
        local id = get_cell(x, y)
        types[id][6](x, y, id)
    end
end

function fill_world(id)
    for y=1, h do
        for x=1, w do
            set_cell(x, y, id)
        end
    end
end

function love.load()
    love.window.setMode(805, 600, {resizable=true, vsync=1, minwidth=200, minheight=200})

    require("elements")

    debug_font = love.graphics.newFont(13, "normal")
    cell_name_font = love.graphics.newFont(16, "normal")
    cell_desc_font = love.graphics.newFont(12, "normal")

    for y=1, h do
        row = {}
        for x=1, w do
            table.insert(row, {1, {}})
        end
        table.insert(grid, row)
    end

    -- grid[3][3] = 3
end

function love.draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    if wh < ww-175 then
        cellsize = wh/w
    else
        cellsize = (ww-205)/w
    end

    for y = 1, h do
        for x = 1, w do
            local cellid = get_cell(x, y)
            local celldata = get_cell(x, y, true)
            
            local r = types[cellid][1]
            local g = types[cellid][2]
            local b = types[cellid][3]
            if celldata.color ~= nil then
                r = celldata.color[1]
                g = celldata.color[2]
                b = celldata.color[3]
            end
            if types[cellid][11] ~= nil then
                r, g, b = types[cellid][11](x, y, cellid)
            end
            love.graphics.setColor(r, g, b, 1)
            love.graphics.rectangle("fill", (x-1)*cellsize, (y-1)*cellsize, cellsize, cellsize)
            if settings.outline then
                love.graphics.setColor(0, 0, 0, 1)
                love.graphics.rectangle("line", (x-1)*cellsize, (y-1)*cellsize, cellsize, cellsize)
            end
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", 0, 0, w*cellsize, h*cellsize)

    local x = love.mouse.getX()
    local y = love.mouse.getY()

    if love.mouse.getX() < w*cellsize and love.mouse.getY() < h*cellsize then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", (math.floor(x/cellsize)-droppersize)*cellsize, (math.floor(y/cellsize)-droppersize)*cellsize, ((droppersize*2)+1)*cellsize, ((droppersize*2)+1)*cellsize)
    end

    for i,t in ipairs(types) do
        love.graphics.setColor(types[i][1], types[i][2], types[i][3], 1)
        love.graphics.rectangle("fill", ww-75, ((wh/2)-25)+(((i-droppercell))*60), 50, 50)

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", ww-75, ((wh/2)-25)+(((i-droppercell))*60), 50, 50)

        love.graphics.setFont(cell_name_font)
        love.graphics.print(types[i][4] .. ", " .. tostring(i), ww-195, ((wh/2)-9)+(((i-droppercell))*60))
        love.graphics.setFont(cell_desc_font)
        love.graphics.print(types[i][7], ww-195, (((wh/2)-9)+(((i-droppercell))*60)+20))
    end

    love.graphics.rectangle("line", ww-200, (wh/2)-30, 180, 60)

    if settings.debug_mode then
        love.graphics.setFont(debug_font)
        love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 0, 0)
    end
end

function love.update(dt)
    if not pause then
        update_world()
    end

    local x = love.mouse.getX()
    local y = love.mouse.getY()

    if love.mouse.isDown(1) and x < w*cellsize then
        -- set_cell(math.floor(x/cellsize) + 1, math.floor(y/cellsize) + 1, 3)
        dropper(math.floor(x/cellsize) + 1, math.floor(y/cellsize) + 1, droppercell, droppersize)
    elseif love.mouse.isDown(2) and x < w*cellsize then
        -- set_cell(math.floor(x/cellsize) + 1, math.floor(y/cellsize) + 1, 1)
        dropper(math.floor(x/cellsize) + 1, math.floor(y/cellsize) + 1, droppercellr, droppersize)
    end

    local r, g, b = HSV(
        ((love.timer.getTime()*2) / 8) % 1,
        0.2,
        1
    )
    types[16][1] = r
    types[16][2] = g
    types[16][3] = b

    -- if dt < 1/60 then
    --     love.timer.sleep(1/80 - dt)
    -- end
end

function love.mousepressed(x, y, button)
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()
    if button == 1 then
        if x > w*cellsize then
            local add_by = math.floor(((y - (wh / 2))+30) / 60)
            if droppercell + add_by < 1 or droppercell + add_by > #types then
                -- print("no")
            else
                droppercell = droppercell + add_by
            end
        end
    elseif button == 3 then
        droppercell = get_cell(math.floor(x/cellsize) + 1, math.floor(y/cellsize) + 1)
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "g" then
        settings.outline = not settings.outline
    end
    if key == "space" then
        pause = not pause
    end
    if key == "s" and pause then
        update_world()
    end
    if key == "r" then
        fill_world(1)
    end
    if key == "f" or key == "f11" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end
    if key == "f3" then
        settings.debug_mode = not settings.debug_mode
    end
    if key == "f6" then
        love.event.quit("restart")
    end
end

function love.wheelmoved(x, y)
    local ctrl = love.keyboard.isDown("lctrl")
    if y > 0 then
        local x = love.mouse.getX()
        if x < w*cellsize then
            droppersize = droppersize + 1
        elseif droppercell > 1 then
            droppercell = droppercell - 1
        end
    elseif y < 0 then
        local x = love.mouse.getX()
        if x < w*cellsize and droppersize > 0 then
            droppersize = droppersize - 1
        elseif x > w*cellsize and droppercell < #types then
            droppercell = droppercell + 1
        end
    end
end

--[[
function love.resize(ww, wh)
    if wh < ww-175 then
        cellsize = wh/w
    else
        cellsize = (ww-205)/w
    end
end
]]--