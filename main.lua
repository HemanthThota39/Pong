WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
Class = require 'Class'
require 'Ball'
require 'Paddle'
push = require 'push'
PADDLE_SPEED = 300
player1Score = 0
player2Score = 0
gamestate = 'start'
function love.load()
    --load sounds 
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['success'] = love.audio.newSource('sounds/success.wav','static')
    }
    math.randomseed(os.time())
    player1 = Paddle(10, 30, 5, 30)
    player2 = Paddle(VIRTUAL_WIDTH-15, VIRTUAL_HEIGHT-40, 5, 30)
    ball = Ball(VIRTUAL_WIDTH/2,VIRTUAL_HEIGHT/2, 4,4)
    love.graphics.setDefaultFilter('nearest','nearest') --old aesthetic
    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    winFont = love.graphics.newFont('font.ttf', 24)
    love.window.setTitle("Hemanth-Game1-Pong")
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,{
        fullscreen  = false,
        resizable = false,
        vsync = true
    })
end

function love.draw()
    push:apply('start')
    player1:render()
    player2:render()
    ball:render() 
    if gamestate == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome To Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press return to start playing!', 0, 40, VIRTUAL_WIDTH, 'center')
    end
    if gamestate == 'pause' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press return to continue', 0, 20, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(scoreFont)
        love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
        love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,VIRTUAL_HEIGHT / 3)
    end
    if gamestate == 'victory' then
        
        if player1Score == 10 then
            love.graphics.setFont(winFont)
            love.graphics.printf('Player 1 wins the Game!',0,20,VIRTUAL_WIDTH,'center')
            love.graphics.setFont(smallFont)
            love.graphics.printf('Press h to go home!',0,VIRTUAL_HEIGHT/3,VIRTUAL_WIDTH,'center')
        elseif player2Score == 10 then
            love.graphics.setFont(winFont)
            love.graphics.printf('Player 2 wins the Game!',0,20,VIRTUAL_WIDTH,'center')
            love.graphics.setFont(smallFont)
            love.graphics.printf('Press h to go home!',0,VIRTUAL_HEIGHT/3,VIRTUAL_WIDTH,'center')
        end
    end
    push:apply('end')
    
end

function love.update(dt)
    --game in victory mode
    if gamestate == 'victory' then
        sounds['success']:play()
        ball:reset()
    end
    --game in pause mode 
    if gamestate  == 'pause' then
        ball:reset()
    end
    --game in start mode
    if gamestate == 'start' then
        player1Score = 0
        player2Score = 0
        ball:reset()
    end
    --game in play mode
    if gamestate == 'play' then
        if love.keyboard.isDown('up') then 
            player2.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('down') then
            player2.dy = PADDLE_SPEED
        else 
            player2.dy = 0
        end
        if love.keyboard.isDown('w') then 
            player1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            player1.dy = PADDLE_SPEED
        else 
            player1.dy = 0
        end
        player1:update(dt)
        player2:update(dt)
        ball:update(dt)
        --collision with paddle 1
        if ball:collides(player1) then
            sounds['paddle_hit']:play()
            ball.dx = -ball.dx*1.2
            ball.x = player1.x+player1.width
            if ball.dy<0 then
                ball.dy = -math.random(80,100)
            else 
                ball.dy = math.random(80,100)
            end
            
        end

        --collision with paddle 2
        if ball:collides(player2) then
            sounds['paddle_hit']:play()
            ball.dx = -ball.dx*1.2
            ball.x = player2.x - ball.width
            if ball.dy<0 then
                ball.dy = -math.random(80,100)
            else 
                ball.dy = math.random(80,100)
            end
            
        end
        --hitting the upper boundary 
        if ball.y <=0 then
            sounds['wall_hit']:play()
            ball.y = 0
            ball.dy = -ball.dy*1.2
        end
        --hitting the lower biundary
        if ball.y >= VIRTUAL_HEIGHT then
            sounds['wall_hit']:play()
            ball.y = VIRTUAL_HEIGHT - ball.height
            ball.dy = -ball.dy*1.2
        end
        --hitting the left boundary
        if ball.x<0 then
            sounds['score']:play()
            player2Score = player2Score+1
            if player2Score == 10 then
                gamestate = 'victory'
            else 
                gamestate = 'pause'
            end
        end
        --hitting the right boundary
        if ball.x>VIRTUAL_WIDTH then
            sounds['score']:play()
            player1Score = player1Score+1
            if player1Score == 10 then
                gamestate = 'victory'
            else 
                gamestate = 'pause'
            end
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'return' then
        gamestate = 'play'
    end
    if key == 'h' then
        gamestate = 'start'
    end
end