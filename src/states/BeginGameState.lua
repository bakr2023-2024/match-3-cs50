BeginGameState = Class({ __includes = BaseState })

function BeginGameState:init()
	self.board = Board(HVW - 16, 16)
	self.timer = require("lib.knife.timer")
	self.transAlpha = 1
	self.y = -60
end

function BeginGameState:enter(params)
	self.level = params.level
	self.score = params.score
	self.timer.tween(1, { [self] = { transAlpha = 0 } }):finish(function()
		self.timer.tween(0.25, { [self] = { y = HVH - 60 } }):finish(function()
			self.timer.after(0.25, function()
				self.timer.tween(0.25, { [self] = { y = VH + 60 } }):finish(function()
					gsm:change("play", { level = self.level, score = self.score, board = self.board })
				end)
			end)
		end)
	end)
end

function BeginGameState:update(dt)
	self.timer.update(dt)
end

function BeginGameState:render()
	love.graphics.setColor(0, 1, 1, 0.75)
	love.graphics.rectangle("fill", 0, self.y, VW, 60)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(fonts["large"])
	love.graphics.printf("Level " .. tostring(self.level), 0, self.y + 14, VW, "center")

	love.graphics.setColor(1, 1, 1, self.transAlpha)
	love.graphics.rectangle("fill", 0, 0, VW, VH)
	love.graphics.setColor(1, 1, 1, 1)
end
