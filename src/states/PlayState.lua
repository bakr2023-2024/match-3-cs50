PlayState = Class({ __includes = BaseState })
local abs = math.abs
local highlightTx, highlightTy = 1, 1
local selectTx, selectTy = 0, 0
local hasSelected = false
local canInput = true
function PlayState:init()
	self.timer = require("lib.knife.timer")
	self.timeLeft = 60
	self.timer.every(1, function()
		self.timeLeft = self.timeLeft - 1
	end)
end

function PlayState:enter(params)
	self.level = params.level
	self.score = params.score
	self.board = params.board
	self.scoreGoal = self.level * 1.25 * BASE_SCORE_GOAL
end

function PlayState:update(dt)
	if self.timeLeft <= 0 then
		gsm:change("gameOver", { score = self.score })
	end
	if self.score >= self.scoreGoal then
		gsm:change("beginGame", { level = self.level + 1, score = self.score })
	end
	if love.keyboard.active["up"] then
		highlightTy = highlightTy > 1 and highlightTy - 1 or 1
	elseif love.keyboard.active["down"] then
		highlightTy = highlightTy < 8 and highlightTy + 1 or 8
	elseif love.keyboard.active["left"] then
		highlightTx = highlightTx > 1 and highlightTx - 1 or 1
	elseif love.keyboard.active["right"] then
		highlightTx = highlightTx < 8 and highlightTx + 1 or 8
	end

	if love.keyboard.active["enter"] or love.keyboard.active["return"] then
		if not canInput then
			return
		end
		if not hasSelected then
			hasSelected = true
			selectTx, selectTy = highlightTx, highlightTy
		else
			hasSelected = false
			local tile1 = self.board.tiles[selectTy][selectTx]
			selectTx, selectTy = highlightTx, highlightTy
			local tile2 = self.board.tiles[selectTy][selectTx]
			if abs(tile1.gx - tile2.gx) + abs(tile1.gy - tile2.gy) ~= 1 then
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
	end
	self.timer.update(dt)
end

function PlayState:calcMatches()
	for i=1,#self.board.matches do
		for j = 1, #self.board.matches[i] do
			self.score = self.score + BASE_TILE_SCORE + BASE_VARIETY_SCORE * self.board.matches[i][j].variety
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
