function removeItems(itemsToRemove, source)
	for i=1, #itemsToRemove do
		for j=1, #source do
			if source[j] == itemsToRemove[i] then
				table.remove(source, j)
				break
			end
		end
		itemsToRemove[i] = nil
	end
end


function drawBackground()
	background = BackgroundBuilder:new(
		{
			backgrounds = {
				DrawableBuilder:new({image = love.graphics.newImage("dev/background.jpg"), z=0}),
				DrawableBuilder:new({image = love.graphics.newImage("dev/background2.jpg"), z=0}),
				DrawableBuilder:new({image = love.graphics.newImage("dev/background3.jpg"), z=0}),
				DrawableBuilder:new({image = love.graphics.newImage("dev/background4.jpg"), z=0}),
				DrawableBuilder:new({image = love.graphics.newImage("dev/background5.jpg"), z=0}),
				DrawableBuilder:new({image = love.graphics.newImage("dev/background6.jpg"), z=0})
			}
		}
	)
end

-- remove everything from the screen, except the player & collision tables
function clearScreen()
	for i=1,#enemyList do
		enemyListRemove[#enemyListRemove+1] = enemyList[i]
	end

	for i=1,#enemyWeaponList do
		enemyWeaponListRemove[#enemyWeaponListRemove+1] = enemyWeaponList[i]
	end
	local tempPlayer = player
	local tempCollisionTable = collisionManager

	--for key,value in pairs(drawableList) do print(key,value) end

	for i=1,#drawableList do
		if drawableList[i] ~= tempPlayer then
			drawableListRemove[#drawableListRemove+1] = drawableList[i]
		end
	end

	--for key,value in pairs(updatableList) do print(key,value) end

	for i=1,#updatableList do
		local curVal = updatableList[i]
		if curVal ~= tempPlayer and curVal ~= tempCollisionTable then
			updateListRemove[#updateListRemove+1] = updatableList[i]
		end
	end
end

-- moves player to the starting x/y co-ordinates
function resetPlayer()
	player.x = largestX/2
	player.y = love.graphics.getHeight()-35
	player.z = 10
end

function newGame()
	currentTime = 0.0001
	--clearScreen()
	drawBackground()
	resetPlayer()
	shotDelay = shotDelayMax
	playerScore = 0
	playerLives = playerTotalLives
	playerKills = 0
	playerEnemyWaveCount = 0
	gameState = 1
end

-- spawns a wave of enemies
function newEnemy(typeOfEnemy, rows, cols)
	local speedIncrease = math.floor(currentTime/6)*math.random(0.8,1.1) -- increasing speed as time increases
	if speedIncrease > enemySpeedLimit then speedIncrease = enemySpeedLimit end
	local randomX = columns[math.random(2,8)]
	local sway = math.random(-4,4) 			-- influences x direction of enemies
	local i
	local j
	playerEnemyWaveCount = playerEnemyWaveCount + 1
	print ("Wave # ".. playerEnemyWaveCount .. " Type: " .. typeOfEnemy .. " Rows: " ..rows .. " Cols: " ..cols .. " Speed: " .. speedIncrease)
	if randomX + cols > 10 then
		temp = randomX-(cols*40)
		randomX = temp
	end

	if typeOfEnemy == 1 then			-- yellow attacks in columns and doesnt sway
		if rows > 3 then rows = 3 end
		--if rows <=4 then newEnemy(2,1,1) end
		sway = 0
	elseif typeOfEnemy == 2 then 			-- red
		rows = 1
		sway = sway * 2
		if cols < 4 then newEnemy(1,1,1) end
	elseif typeOfEnemy == 3 then 			-- green
		if cols < 4 then cols = 4 end
	elseif typeOfEnemy == 4 then 			-- purple
		if rows < 4 then rows = 4 end
	end

	for i=1,rows do
		for j=1,cols do
			if randomX+(40*j) > largestX then
				randomX = randomX - largestX
			end
			if rows <= 6 or cols <= 3 or typeOfEnemy == 2 then
				enemy = EnemyBuilder:new(
					{
						directionY = 1+speedIncrease,
						directionX = sway,
						bulletImage = enemyBulletImage,
						firing = 1,
						type = typeOfEnemy,
						x = randomX+(40*j),
						y = -40-(40*i),
						z = 4
					}
				)
			else
				enemy = EnemyBuilder:new(
					{
						directionY = 1+speedIncrease,
						directionX = sway,
						bulletImage = enemyBulletImage,
						firing = 0,
						type = typeOfEnemy,
						x = randomX+(40*j),
						y = -40-(40*i),
						z = 4
					}
				)
			end
		end
	end
end

function togglePlayerLives()
	if playerTotalLives ~= 10 then
		playerTotalLives = playerTotalLives + 1
	else
		playerTotalLives = 1
	end
end

function toggleMaxEnemySpeed()
	if enemySpeedLimit ~= 30 then
		enemySpeedLimit = enemySpeedLimit + 1
	else
		enemySpeedLimit = 1
	end
end


function toggleEnemyWeaponSpeed()
	if enemyWeaponSpeed ~= 20 then
		enemyWeaponSpeed = enemyWeaponSpeed + 1
	else
		enemyWeaponSpeed = 1
	end
end

function togglePlayerSpeed()
	if playerSpeed ~= 15 then
		playerSpeed = playerSpeed + 1
	else
		playerSpeed = 1
	end
end
