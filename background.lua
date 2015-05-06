Background = {
	backgrounds = nil,
	scrollSpeed = 2
}

BackgroundBuilder = createClass(Background, Updatable)

function Background:new()
	currentHeight = love.graphics.getHeight()
	for i=1, #self.backgrounds do
		currentHeight = currentHeight - self.backgrounds[i].image:getHeight()
		self.backgrounds[i].y = currentHeight
	end
end

function Background:update()
	for i=1, #self.backgrounds do
		self.backgrounds[i].y = self.backgrounds[i].y + self.scrollSpeed;
		if self.backgrounds[i].y >= love.graphics.getHeight() then
			if i == 1 then
				self.backgrounds[i].y = self.backgrounds[#self.backgrounds].y - self.backgrounds[i].image:getHeight() + self.scrollSpeed
			else
				self.backgrounds[i].y = self.backgrounds[i-1].y - self.backgrounds[i].image:getHeight()
			end
		end
	end
end
