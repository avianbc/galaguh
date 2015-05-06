require "basicweapon"

playerWeaponsList = {}

playerWeaponsListRemove = {}

Player = {
  timeToNextShot = 0,
  bulletImage
}

PlayerBuilder = createClass(Player, Updatable, Drawable)

function Player:new()
  self.bulletImage = love.graphics.newImage("dev/smallbullet.png")
  self.image = playerImage
end

function Player:collide() -- player death
  print("Player died!")
  playerLives = playerLives - 1
  shotDelay = shotDelayMax
  love.timer.sleep(1000)
  clearScreen()
  resetPlayer()
  if playerLives <= 0 then      -- game over, print info to console and reset game status to start
    accuracy = math.floor((hitCount / shotCount)*100)
    gameState = 4
  else
    drawBackground()
  end
end


function Player:update()
  self.timeToNextShot = self.timeToNextShot - 1
  if love.keyboard.isDown("left") then
    if self.x > smallestX then
      self.x = self.x - playerSpeed
    elseif self.x <= smallestX then
      self.x = largestX
    end
  elseif love.keyboard.isDown("right") then
    if self.x < largestX then
      self.x = self.x + playerSpeed
    elseif self.x >= largestX then
      self.x = smallestX
    end
  end

  if love.keyboard.isDown(" ") and self.timeToNextShot <= 0 then
    shotCount = shotCount + 1
    self.timeToNextShot = shotDelay

    local params3 = {
      image = love.graphics.newImage("dev/smallbullet.png"),
      x = (self.x + self.image:getWidth() / 2 - self.bulletImage:getWidth() / 2),
      y = self.y - self.bulletImage:getHeight(),
      z = self.z,
      collection = playerWeaponsList,
      removeCollection = playerWeaponsListRemove
    }

    if shotDelay <= shotDelayMin then
      local params1 = {
        image = love.graphics.newImage("dev/smallestbullet.png"),
        x = (self.x + self.image:getWidth() / 2 - self.bulletImage:getWidth() / 2)-7,
        y = self.y - self.bulletImage:getHeight(),
        z = self.z,
        collection = playerWeaponsList,
        removeCollection = playerWeaponsListRemove
      }
      BasicWeaponBuilder:new(params1)
      --BasicWeaponBuilder:new(params2)
      --BasicWeaponBuilder:new(params3)

    else
      BasicWeaponBuilder:new(params3)
    end
  end

  if love.keyboard.isDown("up") and self.timeToNextShot <= 0 then
    shotCount = shotCount + 1
    self.timeToNextShot = shotDelay
    local params = {
      image = love.graphics.newImage("dev/smallbullet.png"),
      x = self.x + self.image:getWidth() / 2 - self.bulletImage:getWidth() / 2,
      y = self.y - self.bulletImage:getHeight(),
      z = self.z,
      collection = playerWeaponsList,
      removeCollection = playerWeaponsListRemove
    }
    BasicWeaponBuilder:new(params)
  end
end
