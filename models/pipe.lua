Pipe = class()

local pipe = love.graphics.newImage('assets/pipe.png')

function Pipe:init(reversed, pipeEnd)
    self.width = pipe:getWidth()
    self.pipeEnd = pipeEnd
    self.reversed = reversed
    self.x = VIRTUAL_WIDTH
end

function Pipe:draw()
    love.graphics.draw(pipe, self.x, self.pipeEnd, 0, 1, self.reversed and -1 or 1)
end