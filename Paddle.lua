Paddle = Class{}

function Paddle:init(x,y,width,height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

function Paddle:render()
    love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
end

function Paddle:update(dt)
    if self.dy<0 then
        self.y = math.max(0, self.y + self.dy*dt) --make sure doesnot cross the upper boundary 
    else 
        self.y = math.min(VIRTUAL_HEIGHT-self.height, self.y + self.dy*dt) --make sure doesnot cross the lower boundary
    end
end
