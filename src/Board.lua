Board = Class()
local rand = math.random
function Board:init(x, y, level)
	self.x = x
	self.y = y
	self.matches = {}
	self.colors = {}
	self.level = level
	repeat
		self:initTiles(level)
	until #(self:getMatches()) == 0 and self:hasPotentialMatch() -- guarantees that board will have at least 1 potential match
end

function Board:initTiles(level)
	self.tiles = {}
	self.matches = {}
	self.colors = GetRandomColors()
	for y = 1, 8 do
		self.tiles[y] = {}
		for x = 1, 8 do
			-- at level 1 only flat blocks will appear
			self.tiles[y][x] =
				Tile(x, y, self.colors[math.random(#self.colors)], level == 1 and 1 or rand(6), rand() <= 0.05) -- 5% chance for a shiny block
		end
	end
end

function Board:getMatches()
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
	return matches
end

function Board:removeMatches()
	for i, match in ipairs(self.matches) do
		for j, tile in ipairs(match) do
			self.tiles[tile.gy][tile.gx] = nil
		end
	end
	self.matches = {}
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
				tile.gy = spaceY
				self.tiles[y][x] = nil
				tweens[tile] = { py = (tile.gy - 1) * 32 }
				space = false
				y = spaceY
				spaceY = 0
			elseif (not space) and not tile then
				space = true
				if spaceY == 0 then
					spaceY = y
				end
			end
			y = y - 1
		end
	end
	for x = 1, 8 do
		for y = 8, 1, -1 do
			local tile = self.tiles[y][x]
			if not tile then
				-- at level 1 only flat blocks will appear
				tile = Tile(x, y, rand(#self.colors), self.level == 1 and 1 or rand(6), rand() <= 0.05) -- 5% chance for a shiny block
				tile.py = -32
				self.tiles[y][x] = tile
				tweens[tile] = { py = (tile.gy - 1) * 32 }
			end
		end
	end
	return tweens
end
-- swaps both tiles' gridX,gridY and their positions in board
function Board:swap(tile1, tile2)
	local tempGx, tempGy = tile1.gx, tile1.gy
	-- swap gridX and gridY of both tiles (tiles POV)
	tile1.gx, tile1.gy = tile2.gx, tile2.gy
	tile2.gx, tile2.gy = tempGx, tempGy
	-- swap both tiles' positions in board (board POV)
	self.tiles[tile2.gy][tile2.gx], self.tiles[tile1.gy][tile1.gx] = tile2, tile1
end
-- swap each tile right and down and check for matches
function Board:hasPotentialMatch()
	for y = 1, 8 do
		for x = 1, 8 do
			local tile = self.tiles[y][x]
			if x < 8 then
				local tile2 = self.tiles[y][x + 1]
				self:swap(tile, tile2)
				local result = #(self:getMatches()) > 0
				self:swap(tile, tile2)
				if result then
					return true
				end
			end
			if y < 8 then
				local tile2 = self.tiles[y + 1][x]
				self:swap(tile, tile2)
				local result = #(self:getMatches()) > 0
				self:swap(tile, tile2)
				if result then
					return true
				end
			end
		end
	end
	return false
end
function Board:render()
	for y = 1, 8 do
		for x = 1, 8 do
			self.tiles[y][x]:render(self.x, self.y)
		end
	end
end
