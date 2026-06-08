Board = Class()
local rand = math.random
function Board:init(x, y)
	self.x = x
	self.y = y
	self.matches = {}
	self:initTiles()
end

function Board:initTiles()
	self.tiles = {}
	repeat
		for y = 1, 8 do
			self.tiles[y] = {}
			for x = 1, 8 do
				self.tiles[y][x] = Tile(x, y, rand(18), rand(6))
			end
		end
	until not self:hasMatches()
end

function Board:hasMatches()
	local matches = {}
	for y = 1, 8 do
		local matchTiles = 1
		local currCol = self.tiles[y][1].color
		for x = 2, 8 do
			if self.tiles[y][x].color == currCol then
				matchTiles = matchTiles + 1
			else
				if matchTiles >= 3 then
					matches[#matches + 1] = {}
					for nx = x - 1, x - matchTiles, -1 do
						matches[#matches + 1] = self.tiles[y][nx]
					end
				end
				currCol = self.tiles[y][x].color
				matchTiles = 1
			end
		end
	end
	for x = 1, 8 do
		local matchTiles = 1
		local currCol = self.tiles[1][x].color
		for y = 2, 8 do
			if self.tiles[y][x].color == currCol then
				matchTiles = matchTiles + 1
			else
				if matchTiles >= 3 then
					matches[#matches + 1] = {}
					for ny = y - 1, y - matchTiles, -1 do
						matches[#matches + 1] = self.tiles[ny][x]
					end
				end
				currCol = self.tiles[y][x].color
				matchTiles = 1
			end
		end
	end
	self.matches = matches
	return #matches > 0
end

function Board:removeMatches()
	for i, match in ipairs(self.matches) do
		for j, tile in ipairs(match) do
			self.tiles[tile.gy][tile.gx] = nil
		end
	end
	self.matches = nil
end

function Board:render()
	for y = 1, 8 do
		for x = 1, 8 do
			self.tiles[y][x]:render(self.x, self.y)
		end
	end
end
