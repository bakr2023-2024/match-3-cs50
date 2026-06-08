Tile = Class()

function Tile:init(gx, gy, color, variety, shiny)
	self.gx, self.gy = gx, gy
	self.px, self.py = (gx - 1) * 32, (gy - 1) * 32
	self.color = color
	self.variety = variety
	self.shiny = shiny -- shiny flag
end

function Tile:render(ox, oy)
	love.graphics.draw(
		textures["tiles"],
		frames["tiles"][(self.color - 1) * 6 + self.variety],
		self.px + ox,
		self.py + oy
	)
	-- if shiny, draw an ellipse to mark as a shiny tile
	if self.shiny then
		love.graphics.setColor(212 / 255, 175 / 255, 55 / 255, 1)
		love.graphics.ellipse("fill", self.px + ox + 6, self.py + oy + 6, 5, 5)
		love.graphics.setColor(1, 1, 1, 1)
	end
end
