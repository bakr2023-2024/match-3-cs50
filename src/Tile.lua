Tile = Class()

function Tile:init(gx, gy, color, pattern)
	self.gx, self.gy = gx, gy
	self.color, self.pattern = color, pattern
end

function Tile:render(ox, oy)
	love.graphics.draw(
		textures["tiles"],
		frames["tiles"][(self.color - 1) * 6 + self.pattern],
		(self.gx - 1) * 32 + ox,
		(self.gy - 1) * 32+ oy
	)
end
