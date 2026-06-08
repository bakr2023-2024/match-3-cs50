PlayState = Class({ __includes = BaseState })
local abs = math.abs
local floor = math.floor
local highlightTx, highlightTy = 1, 1
local selectTx, selectTy = 0, 0
local hasSelected = false
local canInput = true
function PlayState:init()
	self.timer = require("lib.knife.timer")
	self.timeLeft = 60
	self.timer.every(1, function()
		self.timeLeft = self.timeLeft - 1
		if self.timeLeft <= 5 then
			sounds["clock"]:play()
		end
	end)
end

function PlayState:enter(params)
	self.level = params.level
	self.score = params.score
	self.board = params.board
	self.scoreGoal = self.level * 2 * BASE_SCORE_GOAL
end

function PlayState:update(dt)
	if self.timeLeft <= 0 then
		sounds["game-over"]:play()
		self.timer.clear()
		gsm:change("gameOver", { score = self.score })
	end
	if self.score >= self.scoreGoal then
		sounds["next-level"]:play()
		self.timer.clear()
		gsm:change("beginGame", { level = self.level + 1, score = self.score })
	end
	if love.keyboard.active["up"] then
		sounds["select"]:play()
		highlightTy = highlightTy > 1 and highlightTy - 1 or 1
	elseif love.keyboard.active["down"] then
		sounds["select"]:play()
		highlightTy = highlightTy < 8 and highlightTy + 1 or 8
	elseif love.keyboard.active["left"] then
		sounds["select"]:play()
		highlightTx = highlightTx > 1 and highlightTx - 1 or 1
	elseif love.keyboard.active["right"] then
		sounds["select"]:play()
		highlightTx = highlightTx < 8 and highlightTx + 1 or 8
	end

	if (love.keyboard.active["enter"] or love.keyboard.active["return"]) and canInput then
		if not hasSelected then
			hasSelected = true
			selectTx, selectTy = highlightTx, highlightTy
		else
			self:checkSwap()
		end
	-- added mouse support
	elseif love.mouse.active[1] and canInput then
		local mx, my = love.mouse.getPosition()
		local gx, gy = push:toGame(mx, my)
		if gx and gy then
			sounds["select"]:play()
			highlightTx, highlightTy = floor((gx - self.board.x) / 32) + 1, floor((gy - self.board.y) / 32) + 1
			if not hasSelected then
				hasSelected = true
				selectTx, selectTy = highlightTx, highlightTy
			else
				self:checkSwap()
			end
		end
	end
	self.timer.update(dt)
end

function PlayState:checkSwap()
	hasSelected = false
	local tile1 = self.board.tiles[selectTy][selectTx]
	selectTx, selectTy = highlightTx, highlightTy
	local tile2 = self.board.tiles[selectTy][selectTx]
	if abs(tile1.gx - tile2.gx) + abs(tile1.gy - tile2.gy) ~= 1 then
		sounds["error"]:play()
		selectTx, selectTy = 0, 0
	else
		-- swap
		canInput = false
		self.board:swap(tile1, tile2)
		self.timer
			.tween(0.1, {
				[tile1] = { px = tile2.px, py = tile2.py },
				[tile2] = { px = tile1.px, py = tile1.py },
			})
			:finish(function()
				-- check for match
				self.board.matches = self.board:getMatches()
				if #self.board.matches > 0 then
					self:calcMatches()
					-- resets board if no potential matches found
					while not self.board:hasPotentialMatch() do
						self.board:initTiles(self.level)
					end
				else
					-- if swapping didn't result in a match, swap again to revert change
					self.board:swap(tile1, tile2)
					self.timer.tween(0.1, {
						[tile1] = { px = tile2.px, py = tile2.py },
						[tile2] = { px = tile1.px, py = tile1.py },
					})
				end
				canInput = true
			end)
	end
end

function PlayState:calcMatches()
	for i,match in ipairs(self.board.matches) do
		sounds["match"]:stop()
		sounds["match"]:play()
		local j = 1
		local isShiny = false
		local isHorz = false
		-- if a shiny tile is found, find out if it was matched horizontally or vertically
		while j <= #match do
			if match[j].shiny then
				isShiny = true
				isHorz = math.abs(match[1].gx - match[2].gx) == 1
				break
			end
			j = j + 1
		end
		-- if shiny, add all the tiles in row/column to the match array
		if isShiny then
			if isHorz then
				for k = 1, 8 do
					match[k] = self.board.tiles[match[1].gy][k]
				end
			else
				for k = 1, 8 do
					match[k] = self.board.tiles[k][match[1].gx]
				end
			end
		end
		for k=1,#match do
			self.score = self.score + BASE_TILE_SCORE + BASE_VARIETY_SCORE * match[k].variety
			-- 1 second added for each tile in a match
			self.timeLeft = self.timeLeft + 1
		end
	end
	self.board:removeMatches()
	local tweens = self.board:fillGaps()
	self.timer.tween(0.25, tweens):finish(function()
		self.board.matches = self.board:getMatches()
		if #self.board.matches > 0 then
			self:calcMatches()
		end
	end)
end

function PlayState:render()
	self.board:render()

	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.setFont(fonts["medium"])
	love.graphics.rectangle("fill", 16, 16, 182, 116, 4)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf("Level: " .. tostring(self.level), 20, 24, 182, "center")
	love.graphics.printf("Score: " .. tostring(self.score), 20, 52, 182, "center")
	love.graphics.printf("Goal : " .. tostring(self.scoreGoal), 20, 80, 182, "center")
	love.graphics.printf("Timer: " .. tostring(self.timeLeft), 20, 108, 182, "center")

	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.setLineWidth(4)
	love.graphics.rectangle(
		"line",
		self.board.x + (highlightTx - 1) * 32,
		self.board.y + (highlightTy - 1) * 32,
		32,
		32,
		4
	)

	love.graphics.setLineWidth(1)

	if hasSelected then
		love.graphics.setColor(1, 1, 1, 0.5)
		love.graphics.rectangle(
			"fill",
			self.board.x + (selectTx - 1) * 32,
			self.board.y + (selectTy - 1) * 32,
			32,
			32,
			6
		)
	end

	love.graphics.setColor(1, 1, 1, 1)
end
