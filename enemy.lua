require "EnemyWeapon"

enemyList = {}

enemyListRemove = {}

enemyWeaponList ={}

enemyWeaponListRemove ={}

Enemy = {
  timeToNextShot = 0,
  directionX = 0,
  directionY = 1,
  state = 1, -- used for red enemy
  type = 1,
  bulletImage,
  firing = 0, -- 1= shoot bullets at player , 0 = does not fire any bullets
  xtemp = 0, -- used for red enemy
  ytemp = 0, -- used for red enemy
  collection,
  removeCollection
}

EnemyBuilder = createClass(Enemy, Updatable, Drawable)

function Enemy:new()
  enemyList[#enemyList+1] = self
  self.image = love.graphics.newImage("dev/galaga" .. self.type .. ".png")
  self.bulletImage = love.graphics.newImage("dev/smallestbullet.png")
  self.state = incoming
end

function Enemy:destroy()
  enemyListRemove[#enemyListRemove+1] = self
end

function Enemy:update()
  self.timeToNextShot = self.timeToNextShot - 1
  if not self:isOnScreen() then       -- destroy enemies who are off the bottom of the screen
    EnemyBuilder:destroy(self)
  end
  if self.type == 2 then          -- code for spinning red enemies
    if self.state == 1 then
      if self.y > 200 then
        self.theta = 10
        self.r = 1
        self.xtemp = self.x
        self.ytemp = self.y
        self.state = 2
      else
        self.x = self.x + self.directionX
        self.y = self.y + self.directionY
      end
    end

    if self.state == 2 then
      self.theta = self.theta - 0.13
      self.r = self.r + 2
      self.x = self.r * math.sin(self.theta) + self.xtemp
      self.y = self.r * math.cos(self.theta) + self.ytemp
      if self.theta <= 0 then
        self.state = 3
      end
    end

    if self.state == 3 then
      self.x = self.x + (self.directionX*-1)
      self.y = self.y + (self.directionY+3)
    end
  else
    self.x = self.x + self.directionX
    self.y = self.y + self.directionY
  end

                -- enemy x boundry checking to make enemies stay on screen
  if self.type == 4 then          -- purple enemies reflect off edges of screen
    if self.x < smallestX then
      self.directionX = self.directionX*-1
    elseif self.x > largestX-32 then
      self.directionX = self.directionX*-1
    end
  else              -- yellow, green, red wrap around to opposite side of screen
    if self.x <= smallestX then
      self.x = largestX
    elseif self.x >= largestX then
      self.x = smallestX
    end
  end

  if self.firing == 1 then
    if  self.timeToNextShot <= 0 then
      self.timeToNextShot = columns[math.random(10)]
      local params = {
        image = enemyBulletImage,
        x = self.x + self.image:getWidth() / 2 - self.bulletImage:getWidth() / 2,
        y = self.y + self.bulletImage:getHeight(),
        z = self.z,
        collection = enemyWeaponList,
        removeCollection = enemyWeaponListRemove
      }
      EnemyWeaponBuilder:new(params)
    end
  end
end

function Enemy:collide()
  EnemyBuilder:destroy(self)
end

function Enemy:isOnScreen()
  if self.x > largestX+5 or self.y > 680  or self.x < smallestX-5 then return false end
  return true
end
