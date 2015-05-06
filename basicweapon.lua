BasicWeapon = {
	directionX = 0,
	directionY = -10,
	collection,
	removeCollection
}

BasicWeaponBuilder = createClass(BasicWeapon, Updatable, Drawable)

function BasicWeapon:new()
	self.collection[#self.collection+1] = self
end

function BasicWeapon:destroy()
	self.removeCollection[#self.removeCollection+1] = self
end

function BasicWeapon:update()
	--self.x = self.x + self.directionX
	self.y = self.y + self.directionY
	if not self:isOnScreen() then
		BasicWeaponBuilder:destroy(self)
	end
end

function BasicWeapon:collide() -- enemy killed!
	BasicWeaponBuilder:destroy(self)
	hitCount = hitCount + 1
	playerScore = playerScore + 50
	playerKills = playerKills + 1
	if playerKills % shotDelayIncrement == 0 and shotDelay >= shotDelayMin then
		shotDelay = shotDelay - 1
	end
end

function BasicWeapon:isOnScreen()
	if self.x < -20 then return false end
	return true
end
