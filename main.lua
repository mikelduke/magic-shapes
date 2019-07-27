debug = true

updatetime = 0

explosions = {}
touches = {}

sounds = {
    love.audio.newSource("assets/Menu_Navigate_00.mp3", "static"),
    love.audio.newSource("assets/Climb_Rope_Loop_00.mp3", "static"),
    love.audio.newSource("assets/Collect_Point_00.mp3", "static"),
    love.audio.newSource("assets/Hit_00.mp3", "static"),
    love.audio.newSource("assets/Jump_00.mp3", "static")
}

function love.load(arg)
    print("Touch it!")
end

function love.update(dt)
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    updatetime = dt

    updateExplosions(dt)
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'd' and not isrepeat then
        debug = not debug
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)

    for i, explosion in ipairs(explosions) do
        love.graphics.draw(explosion, 0, 0)
    end

    if debug then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("DT: " .. tostring(updatetime), 0, 0)
        love.graphics.print("FPS: " .. tostring(1.0 / updatetime), 0, 10)
    end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    -- print("Touch " .. tostring(id) .. ": " .. x .. "," .. y .. "dx,dy: " .. dx .. "," .. dy .. " pressure: " .. pressure)

    touch = {
        id = id,
        sound = sounds[math.random(1, #sounds)],
        x = x,
        y = y,
        trails = {
            color1 = {
                r = math.random(),
                g = math.random(),
                b = math.random()
            },
            color2 = {
                r = math.random(),
                g = math.random(),
                b = math.random()
            },
            color3 = {
                r = math.random(),
                g = math.random(),
                b = math.random()
            }
        }
    }
    love.audio.play(touch.sound)
    touches[id] = touch

    touch.blast = getBlast(100, touch.trails.color1)
    local explosion = getExplosion(touch.blast, touch.trails)
    explosion:setPosition(x, y)
    explosion:emit(10)
    table.insert(explosions, explosion)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    -- print("Touch Moved" .. tostring(id) .. ": " .. x .. "," .. y .. "dx,dy: " .. dx .. "," .. dy .. " pressure: " ..
    --           pressure)
    local touch = touches[id]

    love.audio.play(touch.sound)

    local explosion = getExplosion(touch.blast, touch.trails)
    explosion:setPosition(x, y)
    explosion:emit(10)
    table.insert(explosions, explosion)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    -- print("Touch Released" .. tostring(id) .. ": " .. x .. "," .. y .. "dx,dy: " .. dx .. "," .. dy .. " pressure: " ..
    --           pressure)
    touches[id] = nil
end

function getBlast(size, color)
    local blast = love.graphics.newCanvas(size, size)
    love.graphics.setCanvas(blast)
    love.graphics.setColor(color.r, color.g, color.b, 255)
    love.graphics.circle("fill", size / 2, size / 2, size / 2)
    love.graphics.setCanvas()
    return blast
end

function getExplosion(image, colors)
    pSystem = love.graphics.newParticleSystem(image, 10)
    pSystem:setParticleLifetime(0.5, 0.5)
    pSystem:setLinearAcceleration(-100, -100, 100, 100)
    pSystem:setColors(colors.color1.r, colors.color1.g, colors.color1.b, 255,
                      colors.color2.r, colors.color2.g, colors.color2.b, 255,
                      colors.color3.r, colors.color3.g, colors.color3.b, 0)
    pSystem:setSizes(1, 0.1)
    return pSystem
end

function updateExplosions(dt)
    for i, explosion in ipairs(explosions) do
        explosion:update(dt)
        if explosion:getCount() == 0 then
            table.remove(explosions, i)
        end
    end
end
