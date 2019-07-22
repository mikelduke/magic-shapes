debug = true

updatetime = 0

smallBlast = nil
explosions = {}

function love.load(arg)
    print("Touch it!")

    smallBlast = getBlast(100)
end

function love.update(dt)
    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    updatetime = dt

    updateExplosions(dt)
end

function love.draw()
    love.graphics.setColor(1, 1, 1)

    for i, explosion in ipairs(explosions) do
        love.graphics.draw(explosion, 0,0)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("DT: " .. tostring(updatetime), 0, 0)
    love.graphics.print("FPS: " .. tostring(1.0 / updatetime), 0, 10)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
    -- print("Touch " .. tostring(id) .. ": " .. x .. "," .. y .. "dx,dy: " .. dx .. "," .. dy .. " pressure: " .. pressure)

    local explosion = getExplosion(smallBlast)
    explosion:setPosition(x, y)
    explosion:emit(10)
    table.insert(explosions, explosion)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
    -- print("Touch Moved" .. tostring(id) .. ": " .. x .. "," .. y .. "dx,dy: " .. dx .. "," .. dy .. " pressure: " ..
    --           pressure)

    local explosion = getExplosion(smallBlast)
    explosion:setPosition(x, y)
    explosion:emit(10)
    table.insert(explosions, explosion)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
    -- print("Touch Released" .. tostring(id) .. ": " .. x .. "," .. y .. "dx,dy: " .. dx .. "," .. dy .. " pressure: " ..
    --           pressure)

end

function getBlast(size)
    local blast = love.graphics.newCanvas(size, size)
    love.graphics.setCanvas(blast)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.circle("fill", size / 2, size / 2, size / 2)
    love.graphics.setCanvas()
    return blast
end

function getExplosion(image)
    pSystem = love.graphics.newParticleSystem(image, 300)
    pSystem:setParticleLifetime(0.5, 0.5)
    pSystem:setLinearAcceleration(-100, -100, 100, 100)
    pSystem:setColors(255, 255, 0, 255, 255, 153, 51, 255, 64, 64, 64, 0)
    pSystem:setSizes(1, 0.1)
    return pSystem
end

function updateExplosions(dt)
    for i = table.getn(explosions), 1, -1 do
      local explosion = explosions[i]
      explosion:update(dt)
      if explosion:getCount() == 0 then
        table.remove(explosions, i)
      end
    end
  end