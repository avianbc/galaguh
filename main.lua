require "dev/class"
require "dev/drawable"
require "dev/updatable"
require "player"
require "background"
require "dev/collisionmanager"
require "enemy"
require "functions"

function love.load()
  -- player and enemy data
  enemySpeedLimit = 14    -- max speed of enemy movement
  enemyWeaponSpeed = 5    -- enemy fire moves this # of pixels per frame
  playerTotalLives = 3
  playerKills = 0
  playerScore = 0
  playerSpeed = 5
  playerEnemyWaveCount = 0
  shotDelayMax = 18
  shotDelayMin = 6
  shotDelayIncrement = 2
  shotCount = 0
  hitCount = 0

  shotDelay = shotDelayMax
  gameState = 2 -- 1: game in progress, 2: menu, 3: pause, 4: gameover, 5: options
  love.graphics.setMode(480, 640, false, true, 0)
  love.graphics.setCaption("Galaguh")
  love.graphics.newFont("dev/emulogic.ttf", 10)
  playerImage = love.graphics.newImage("dev/player.gif")
  enemyBulletImage = love.graphics.newImage("dev/smallbullet.png")
  love.graphics.setIcon(playerImage)
  columns = {40, 80, 120, 160, 200, 240, 280, 320, 360, 400}  -- holds values for random enemy x value generation
  smallestX = -32         -- used to determine if something is on screen
  largestX = love.graphics.getWidth()
  currentTime = 0.00001
  player = PlayerBuilder:new(
    {
      image = playerImage,
      x = largestX/2,
      y = love.graphics.getHeight()-35,
      z = 5
    }
  )
  collisionManager = CollisionManagerBuilder:new()
  collisionManager:addCollisionTables({player}, enemyList)
  collisionManager:addCollisionTables(playerWeaponsList, enemyList)
  collisionManager:addCollisionTables({player}, enemyWeaponList)
end


function love.draw()
  if gameState == 1 then -- game in progress

    for i=1, # drawableList do drawableList[i]:draw() end

    love.graphics.print("Score: " .. playerScore, 0, 0, 0, 1, 1)
    love.graphics.print("Lives: " .. playerLives, 0, 20, 0, 1, 1)
    love.graphics.print("Time: " .. math.floor(currentTime), 0, 40, 0, 1, 1)
    love.graphics.print("Kills: " .. playerKills, 0, 60, 0, 1, 1)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 80, 0, 1, 1)
    if shotDelay <= shotDelayMin then
      love.graphics.print("MAX WEAPON", largestX-100, 0, 0, 1, 1)
    end

  elseif gameState == 2 then -- menu

    love.graphics.newFont("dev/emulogic.ttf", 30)
    love.graphics.print("GALAGUH", 25, 100, 0, 2, 2)
    love.graphics.newFont("dev/emulogic.ttf", 10)
    love.graphics.print("Press ENTER to play!", 40, 580, 0, 2, 2)
    love.graphics.print("F1 - Toggle fullscreen", 25, 300, 0, 1, 1)
    love.graphics.print("Space Bar - Fires your ship", 25, 320, 0, 1, 1)
    love.graphics.print("Arrow Keys - Move your ship left and right", 25, 340, 0, 1, 1)
    love.graphics.print("Escape - Pause/Unpause game", 25, 360, 0, 1, 1)
    love.graphics.print("o - View game options", 25, 380, 0, 1, 1)

  elseif gameState == 3 then -- pause

    local rot = pauseSpin*180/math.pi
        local sx = math.cos(pauseSpin)*3
        local sy = math.sin(pauseSpin)*3
    love.graphics.print("GALAGUH", pausex+10, pausey+10, 360-rot, sx, -sy)
    love.graphics.print("PAUSE", pausex, pausey, -rot, sx, 1+sy)

  elseif gameState == 4 then -- game over

    love.graphics.print("Score: " .. playerScore, 0, 0, 0, 1, 1)
    love.graphics.print("Kills: " .. playerKills, 0, 25, 0, 1, 1)
    love.graphics.print("Waves Survived: " .. playerEnemyWaveCount, 0, 50, 0, 1, 1)
    love.graphics.print("Accuracy: %" .. accuracy, 0, 75, 0, 1, 1)
    love.graphics.print("GAME OVER", 110, 320, 0, 2.5, 2.5)

  elseif gameState == 5 then -- options
    love.graphics.print("OPTIONS", 110, 20, 0, 3, 3)

    love.graphics.print("Starting Lives: " .. playerTotalLives, 40, 200, 0, 1, 1)
    love.graphics.print("Max Enemy Speed: " .. enemySpeedLimit, 40, 220, 0, 1, 1)
    love.graphics.print("Enemy Weapon Speed: " .. enemyWeaponSpeed, 40, 240, 0, 1, 1)
    love.graphics.print("Player Speed: " .. playerSpeed, 40, 260, 0, 1, 1)

    love.graphics.print("1 - Toggle amount of starting lives", 25, 300, 0, 1, 1)
    love.graphics.print("2 - Toggle max enemy speed", 25, 320, 0, 1, 1)
    love.graphics.print("3 - Toggle enemy weapon speed", 25, 340, 0, 1, 1)
    love.graphics.print("4 - Toggle player speed", 25, 360, 0, 1, 1)
    love.graphics.print("Press ENTER for main menu!", 40, 580, 0, 1.5, 1.5)
  end
end


function love.update(dt)
  currentTime = currentTime + dt

  removeItems(updateListRemove, updatableList)
  removeItems(drawableListRemove, drawableList)
  removeItems(enemyListRemove, enemyList)
  removeItems(playerWeaponsListRemove, playerWeaponsList)
  removeItems(enemyWeaponListRemove, enemyWeaponList)

  if gameState == 1 then -- game in progress
    for i=1, # updatableList do
      updatableList[i]:update()
    end
    if next(enemyList) == nil then -- no enemy, create another
      local enemyPattern = math.random(4)
      newEnemy(enemyPattern, math.random(10), math.random(5))
    end
  elseif gameState == 3 then -- game paused
    pauseSpin = pauseSpin + dt/14
    pausex, pausey = 170 + math.cos(pauseSpin)*100, 300 + math.sin(pauseSpin)*100
  end
end

function love.quit()

end

-- 1: game in progress, 2: menu, 3: pause, 4: gameover
function love.keyreleased(key, unicode)
  if key == 'f1' then   -- f1 toggle fullscreen
    success = love.graphics.toggleFullscreen()
  elseif key == 'escape' and gameState == 1 then  -- toggle pause
    pauseSpin = 0
    gameState = 3
  elseif key == 'escape' and gameState == 3 then  -- toggle pause
    gameState = 1
  elseif key == 'return' and gameState == 2 then  -- start new game if at main menu
    newGame()
  elseif key == 'return' and gameState == 4 then  -- goto main menu if at game over
    gameState = 2
  elseif key == 'return' and gameState == 5 then  -- goto main menu if at game over
    gameState = 2
  elseif key == '1' and gameState == 5 then -- toggle starting lives
    togglePlayerLives()
  elseif key == '2' and gameState == 5 then -- toggle max enemy speed
    toggleMaxEnemySpeed()
  elseif key == '3' and gameState == 5 then -- toggle enemy weapon speed
    toggleEnemyWeaponSpeed()
  elseif key == '4' and gameState == 5 then -- toggle player speed
    togglePlayerSpeed()
  elseif key == 'o' and gameState == 2 then -- goto options if at main menu
    gameState = 5
  end
end
