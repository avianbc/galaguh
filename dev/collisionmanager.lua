CollisionManager = {
	collisionTables = {}
}

CollisionManagerBuilder = createClass(CollisionManager, Updatable)

function CollisionManager:addCollisionTables(firstSet, secondSet)
	table.insert(self.collisionTables, {firstSet=firstSet, secondSet=secondSet})
end

function CollisionManager:update()
	for i=1,#self.collisionTables do
		for j=1,#self.collisionTables[i].firstSet do
			local firstObject = self.collisionTables[i].firstSet[j]
			for k=1,#self.collisionTables[i].secondSet do
				local secondObject = self.collisionTables[i].secondSet[k]
				if not (firstObject.x >= secondObject.x + secondObject.image:getWidth() or
					firstObject.y >= secondObject.y + secondObject.image:getHeight() or
					secondObject.x >= firstObject.x + firstObject.image:getWidth() or
					secondObject.y >= firstObject.y + firstObject.image:getHeight())
				then
					--print("collide")
					if firstObject.collide ~= nil then firstObject:collide(secondObject) end
					if secondObject.collide ~= nil then secondObject:collide(firstObject) end
				end
			end
		end
	end
end
