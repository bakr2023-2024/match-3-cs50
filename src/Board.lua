Board = Class()
local rand = math.random
function Board:init(x, y)
	self.x = x
	self.y = y
	self.matches = {}
	self.colors = {}
	self:initTiles()
end

function Board:initTiles(level)
	self.tiles = {}
	repeat
		self.colors = GetRandomColors()
		for y = 1, 8 do
			self.tiles[y] = {}
			for x = 1, 8 do
				self.tiles[y][x] = Tile(x, y, self.colors[math.random(#self.colors)], rand(6))
			end
		end
	until not self:hasMatches()
end

function Board:hasMatches()
	local matches = {}
	local matchTiles = 1
	for y = 1, 8 do
		matchTiles = 1
		local currCol = self.tiles[y][1].color
		for x = 2, 8 do
			if self.tiles[y][x].color == currCol then
				matchTiles = matchTiles + 1
			else
				if matchTiles >= 3 then
					local match = {}
					for nx = x - 1, x - matchTiles, -1 do
						table.insert(match, self.tiles[y][nx])
					end
					table.insert(matches, match)
				end
				currCol = self.tiles[y][x].color
				matchTiles = 1
			end
		end
		if matchTiles >= 3 then
			local match = {}
			for nx = 8, 8 - matchTiles + 1, -1 do
				table.insert(match, self.tiles[y][nx])
			end
			table.insert(matches, match)
		end
	end
	for x = 1, 8 do
		matchTiles = 1
		local currCol = self.tiles[1][x].color
		for y = 2, 8 do
			if self.tiles[y][x].color == currCol then
				matchTiles = matchTiles + 1
			else
				if matchTiles >= 3 then
					local match = {}
					for ny = y - 1, y - matchTiles, -1 do
						table.insert(match, self.tiles[ny][x])
					end
					table.insert(matches, match)
				end
				currCol = self.tiles[y][x].color
				matchTiles = 1
			end
		end
		if matchTiles >= 3 then
			local match = {}
			for ny = 8, 8 - matchTiles + 1, -1 do
				table.insert(match, self.tiles[ny][x])
			end
			table.insert(matches, match)
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

function Board:fillGaps()
	local tweens = {}
	for x = 1, 8 do
		local space = false
		local spaceY = 0
		local y = 8
		while y >= 1 do
			local tile = self.tiles[y][x]
			if space and tile then
				self.tiles[spaceY][x] = tile
				self.tiles[y][x] = nil
				tile.gy = spaceY
				tweens[tile] = { py = (spaceY - 1) * 32 }
				space = false
				y = spaceY
			elseif not space and not tile then
				space = true
				spaceY = y
			end
			y = y - 1
		end
	end
	for x = 1, 8 do
		for y = 8, 1, -1 do
			local tile = self.tiles[y][x]
			if not tile then
				tile = Tile(x, y, rand(#self.colors), rand(6))
				tile.py = -32
				self.tiles[y][x] = tile
				tweens[tile] = { py = (y - 1) * 32 }
			end
		end
	end
	return tweens
end

function Board:render()
	for y = 1, 8 do
		for x = 1, 8 do
			self.tiles[y][x]:render(self.x, self.y)
		end
	end
end
