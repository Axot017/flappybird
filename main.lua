push = require 'libraries/push'
require 'libraries/class'
require 'models/bird'
require 'models/pipe'
require 'models/gate'

GROUND_SPEED = 50

DEFAULT_WIDTH = 1280
DEFAULT_HEIGHT = 720

VIRTUAL_WIDTH = 480
VIRTUAL_HEIGHT = 270

GROUND_LEVEL = VIRTUAL_HEIGHT - 35

NEW_GATE_TIME = 2.5

local lost = false

local background = love.graphics.newImage('assets/background.png')
local backgroundMove = 0
local backgroundSpeed = 25

local ground = love.graphics.newImage('assets/ground.png')
local groundMove = 0

local bird = Bird()
local gates = {}

local gateTimer = 1
local speedIncrease = 0.5

function love.load()
    love.window.setTitle('Flappy Bird')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, DEFAULT_WIDTH, DEFAULT_HEIGHT, {
        vsync = true,
        resizable = true,
        fullscreen = false
    })
end

function love.resize(width, height)
    push:resize(width, height)
end

function love.update(dt)
    if lost then return end
    bird:update(dt)
    updateBackground(dt)
    updatePipes(dt)

    checkCollisions()
end

function updateBackground(dt)
    backgroundMove = (backgroundMove + (backgroundSpeed * dt)) % VIRTUAL_WIDTH
    groundMove = (groundMove + (GROUND_SPEED * dt)) % VIRTUAL_WIDTH

    GROUND_SPEED = GROUND_SPEED + speedIncrease * dt
    backgroundSpeed = backgroundSpeed + speedIncrease * dt
end

function checkCollisions()
    if bird:didColidateWithGround() then
        lost = true
    end
    local collidate = false
    for key, gate in pairs(gates) do
        if bird:didCollidateWithPipe(gate.topPipe) or bird:didCollidateWithPipe(gate.bottomPipe) then
            collidate = true
        end
        bird:countPoints(gate)
    end
    if collidate then lost = true end
end



function updatePipes(dt)
    gateTimer = gateTimer + dt
    if gateTimer > NEW_GATE_TIME then
        table.insert(gates, Gate())
        gateTimer = 0
    end
    for key, gate in pairs(gates) do
        gate:update(dt)
    end

    for key, gate in pairs(gates) do
        if gate.delete then
            table.remove(gates, key)
        end
    end
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundMove, 0)
    bird:draw()

    for key, gate in pairs(gates) do
        gate:draw()
    end

    love.graphics.draw(ground, -groundMove, GROUND_LEVEL)

    love.graphics.setColor(255, 255, 255, lost and 0.666 or 0)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(bird.points, VIRTUAL_WIDTH / 2, 50, 0, 1.2, 1.2)

    love.graphics.setColor(0, 0, 0, lost and 1 or 0)
    love.graphics.print('Press "SPACE" to play again', 140, 100, 0, 1.2, 1.2)

    push:finish()
end

function playAgain()
    setDefaults()
    lost = false
end

function setDefaults()
    GROUND_SPEED = 50
    backgroundMove = 0
    backgroundSpeed = 25
    groundMove = 0
    bird = Bird()
    gates = {}
    gateTimer = 1
end

function love.keypressed(key)
    if key == 'space' then
        if lost then
            playAgain()
        else
            bird:jump()
        end
    end
end