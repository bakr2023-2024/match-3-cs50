Tile = Class()

function Tile:init(gx, gy, color, variety)
	self.gx, self.gy = gx, gy
	self.px, self.py = (gx - 1) * 32, (gy - 1) * 32
	self.color = color
	self.variety = variety
end

function Tile:render(ox, oy)
	love.graphics.draw(
		textures["tiles"],
		frames["tiles"][(self.color - 1) * 6 + self.variety],
		self.px + ox,
		self.py + oy
	)
end
