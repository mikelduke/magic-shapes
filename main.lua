debug = false

updatetime = 0

particles = {}
touches = {}

mousedown = false

sounds = {
    love.audio.newSource("assets/Menu_Navigate_00.mp3", "static"),
    love.audio.newSource("assets/Climb_Rope_Loop_00.mp3", "static"),
    love.audio.newSource("assets/Collect_Point_00.mp3", "static"),
    love.audio.newSource("assets/Hit_00.mp3", "static"),
    love.audio.newSource("assets/Jump_00.mp3", "static")
}

shapeSides = {3, 4, 5, 6, 7, 8, 100}

function love.load(arg)
    print("Touch it!")
end

function love.update(dt)
    updatetime = dt

    updateParticles(dt)
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'd' and not isrepeat then
        debug = not debug
    end

    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)

    for i, p in ipairs(particles) do
        love.graphics.draw(p.psystem, 0, 0)

        if debug then
            if p.id ~= nil and touches[p.id] ~= nil then
                love.graphics.print("p.id: " .. tostring(p.id) ..
                                        " p.psystem:getSizes() " ..
                                        p.psystem:getSizes() .. " rotation: " ..
                                        touches[p.id].rotation, 0, i * 10 + 20)

                love.graphics.draw(touches[p.id].shape, touches[p.id].x,
                                   touches[p.id].y, touches[p.id].rotation,
                                   p.psystem:getSizes(), p.psystem:getSizes(),
                                   touches[p.id].shape:getWidth() / 2,
                                   touches[p.id].shape:getHeight() / 2)
            end
        end
    end

    if debug then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("DT: " .. tostring(updatetime), 0, 0)
        love.graphics.print("FPS: " .. tostring(1.0 / updatetime), 0, 10)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if not istouch then
        mousedown = true
        love.touchpressed("mouse", x, y, 0, 0, 0)
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    if not istouch and mousedown then
        love.touchmoved("mouse", x, y, 0, 0, 0)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if not istouch and mousedown then
        mousedown = false
        love.touchreleased("mouse", x, y, 0, 0, 0)
    end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    -- print("Touch " .. tostring(id) .. ": " .. x .. "," .. y .. "dx,dy: " .. dx .. "," .. dy .. " pressure: " .. pressure)
    -- love.system.vibrate(0.1)
    local touch = {
        id = id,
        sound = sounds[math.random(1, #sounds)],
        x = x,
        y = y,
        trails = {
            color1 = {r = math.random(), g = math.random(), b = math.random()},
            color2 = {r = math.random(), g = math.random(), b = math.random()},
            color3 = {r = math.random(), g = math.random(), b = math.random()}
        },
        shape = nil,
        psystem = nil,
        rotation = math.random(0, 360)
    }

    love.audio.play(touch.sound)

    touch.shape = getShape(100, touch.trails.color1)
    local particle = getParticleSystem(touch.shape, touch.trails)
    particle:setPosition(x, y)
    particle:setEmissionRate(20)
    particle:setRotation(touch.rotation)
    touchParticle = {psystem = particle, id = id} -- wrapper table
    touch.psystem = particle
    touches[id] = touch
    table.insert(particles, touchParticle)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    -- love.system.vibrate(0.1)
    -- print("Touch Moved" .. tostring(id) .. ": " .. x .. "," .. y .. "dx,dy: " .. dx .. "," .. dy .. " pressure: " ..
    --           pressure)
    local touch = touches[id]

    love.audio.play(touch.sound)
    touch.x = x
    touch.y = y
    touch.psystem:setPosition(x, y)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    -- print("Touch Released" .. tostring(id) .. ": " .. x .. "," .. y .. "dx,dy: " .. dx .. "," .. dy .. " pressure: " ..
    --           pressure)
    touches[id] = nil
end

function getShape(size, color)
    local shape = love.graphics.newCanvas(size, size)
    love.graphics.setCanvas(shape)
    love.graphics.setColor(color.r, color.g, color.b, 255)

    local mode = "fill"
    if math.random(1, 10) > 6 then
        mode = "line"
        love.graphics.setLineWidth(math.random(10, 50))
    end

    love.graphics.circle(mode, size / 2, size / 2, size / 2,
                         shapeSides[math.random(#shapeSides)])
    love.graphics.setCanvas()
    return shape
end

function getParticleSystem(image, colors)
    local pSystem = love.graphics.newParticleSystem(image, 100)
    pSystem:setParticleLifetime(0.8, math.random(0.8, 3.0))
    pSystem:setLinearAcceleration(-100, -100, 100, 100)

    local area = math.random(80)
    pSystem:setEmissionArea("normal", area, area)
    pSystem:setColors(colors.color1.r, colors.color1.g, colors.color1.b, 255,
                      colors.color2.r, colors.color2.g, colors.color2.b, 255,
                      colors.color3.r, colors.color3.g, colors.color3.b, 0)
    pSystem:setSizes(math.random(.5, 1.5), 0.1)
    return pSystem
end

function updateParticles(dt)
    for i, p in ipairs(particles) do
        p.psystem:update(dt)

        if touches[p.id] == nil then
            p.psystem:setEmissionRate(0)
        end

        if p.psystem:getCount() == 0 and touches[p.id] == nil then
            table.remove(particles, i)
        end
    end
end
