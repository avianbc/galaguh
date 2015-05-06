EnemyWeapon = {
	directionX = 0,
	directionY = 3,
	collection,
	removeCollection
}

EnemyWeaponBuilder = createClass(EnemyWeapon, Updatable, Drawable)

function EnemyWeapon:new()
	self.collection[#self.collection+1] = self
end

function EnemyWeapon:destroy()
	self.removeCollection[#self.removeCollection+1] = self
end

function EnemyWeapon:update()
	--self.x = self.x + self.directionX
	self.y = self.y + enemyWeaponSpeed
	if not self:isOnScreen() then
		EnemyWeaponBuilder:destroy(self)
	end
end

function EnemyWeapon:collide() -- enemy killed!
	EnemyWeaponBuilder:destroy(self)
end

function EnemyWeapon:isOnScreen()
	if self.y > 680 or self.y < 0 then return false end
	return true
end
