PlayState = Class({ __includes = BaseState })
local highlightTx, highlightTy = 1, 1
function PlayState:init()
	self.timer = require("lib.knife.timer")
end

function PlayState:enter(params)
	self.level = params.level
	self.score = params.score
	self.board = params.board
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
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setLineWidth(1)
end
