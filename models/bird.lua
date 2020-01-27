Bird = class()

local bird = love.graphics.newImage('assets/bird.png')
local GRAVITY = 17
local spacePressed = true

function Bird:init()
    spacePressed = true
    self.width = bird:getWidth()
    self.height = bird:getHeight()
    self.x = 50
    self.y = GROUND_LEVEL / 2 - (self.height / 2)
    self.velocity = 0
    self.points = 0
end

function Bird:update(dt)
    self.velocity = self.velocity + GRAVITY * dt
    self.y = self.y + self.velocity

    if spacePressed then
        self.velocity = -5
        spacePressed = false
    end
end

function Bird:draw()
    love.graphics.draw(bird, self.x, self.y, math.deg(self.velocity * 0.0005), 1, 1, 0, 0)
end

function Bird:didColidateWithGround()
    return self.y + self.height > GROUND_LEVEL
end

function Bird:countPoints(gate)
    local birdLeft = self.x
    local pipeRight = gate.topPipe.x + gate.topPipe.width
    if pipeRight < birdLeft and not gate.counted then
        gate.counted = true
        self.points = self.points + 1
    end
end

function Bird:didCollidateWithPipe(pipe)
    local collidate = false
    local pipeLeft = pipe.x
    local pipeRight = pipe.x + pipe.width
    local birdLeft = self.x
    local birdRight = self.x + self.width

    if birdLeft < pipeRight and birdRight > pipeLeft then
        if pipe.reversed then
            local pipeBottom = pipe.pipeEnd
            local birdTop = self.y
            if pipeBottom > birdTop then collidate = true end
        else
            local pipeTop = pipe.pipeEnd
            local birdBottom = self.y + self.height
            if pipeTop < birdBottom then collidate = true end
        end
    end
    return collidate
end

function Bird:jump()
    spacePressed = true
end