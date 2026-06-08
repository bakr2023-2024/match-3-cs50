PlayState = Class({ __includes = BaseState })
local abs = math.abs
local highlightTx, highlightTy = 1, 1
local selectTx, selectTy = 0, 0
local hasSelected = false
local canInput = true
function PlayState:init()
	self.timer = require("lib.knife.timer")
end

function PlayState:enter(params)
	self.level = params.level
	self.score = params.score
	self.board = params.board
	self.scoreGoal = self.level * 1.25 * BASE_SCORE_GOAL
end

function PlayState:update(dt)
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
					end)
			end
		end
	end
	self.timer.update(dt)
end

function PlayState:calcMatches()
	for i, match in ipairs(self.board.matches) do
		self.score = self.score + #match * 50
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
