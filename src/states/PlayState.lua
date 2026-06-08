PlayState = Class({ __includes = BaseState })
local abs = math.abs
local highlightTx, highlightTy = 1, 1
local selectTx, selectTy = 0, 0
local hasSelected = false
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
			local prevTx, prevTy = selectTx, selectTy
			selectTx, selectTy = highlightTx, highlightTy
			if abs(selectTx - prevTx) + abs(selectTy - prevTy) == 1 then
				-- copy gridX and gridY of previous tile
				local tempGx, tempGy = self.board.tiles[prevTy][prevTx].gx, self.board.tiles[prevTy][prevTx].gy
				-- swap gridX and gridY of both tiles (tiles POV)
				self.board.tiles[prevTy][prevTx].gx, self.board.tiles[prevTy][prevTx].gy =
					self.board.tiles[selectTy][selectTx].gx, self.board.tiles[selectTy][selectTx].gy
				self.board.tiles[selectTy][selectTx].gx, self.board.tiles[selectTy][selectTx].gy = tempGx, tempGy
				-- swap both tiles' positions in board (board POV)
				self.board.tiles[prevTy][prevTx], self.board.tiles[selectTy][selectTx] =
					self.board.tiles[selectTy][selectTx], self.board.tiles[prevTy][prevTx]
				-- if no match found, swap back from board POV and tiles POV
				if not self:calcMatches() then
					self.board.tiles[prevTy][prevTx].gx, self.board.tiles[prevTy][prevTx].gy =
						self.board.tiles[selectTy][selectTx].gx, self.board.tiles[selectTy][selectTx].gy
					self.board.tiles[selectTy][selectTx].gx, self.board.tiles[selectTy][selectTx].gy = tempGx, tempGy

					self.board.tiles[prevTy][prevTx], self.board.tiles[selectTy][selectTx] =
						self.board.tiles[selectTy][selectTx], self.board.tiles[prevTy][prevTx]
				end
			end
		end
	end
	self.timer.update(dt)
end

function PlayState:calcMatches()
	if self.board:hasMatches() then
		return true
	else
		return false
	end
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
