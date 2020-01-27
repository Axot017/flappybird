Gate = class()

GATE_GAP = 75

function Gate:init()
    local gap = math.random(30, GROUND_LEVEL - GATE_GAP - 30)
    self.topPipe = Pipe(true, gap)
    self.bottomPipe = Pipe(false, gap + GATE_GAP)
    self.x = VIRTUAL_WIDTH
end

function Gate:draw()
    self.topPipe:draw()
    self.bottomPipe:draw()
end

function Gate:update(dt)
    self.x = self.x - GROUND_SPEED * dt
    self.topPipe.x = self.x
    self.bottomPipe.x = self.x
    if(self.x < -self.topPipe.width) then
        self.delete = true
    end
end