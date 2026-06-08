StartState = Class({ __includes = BaseState })

function StartState:init()
	self.timer = require("lib.knife.timer")
	self.currOption = 1
	self.canInput = true
	self.transAlpha = 0
	self.board = Board(HVW - 4 * 32, HVH - 4 * 32, 2)
end

function StartState:update(dt)
	if self.canInput then
		if love.keyboard.active["up"] or love.keyboard.active["down"] then
			sounds["select"]:play()
			self.currOption = self.currOption == 1 and 2 or 1
		elseif love.keyboard.active["enter"] or love.keyboard.active["return"] then
			if self.currOption == 2 then
				love.event.quit()
			else
				self.timer.tween(1, { [self] = { transAlpha = 1 } }):finish(function()
					gsm:change("beginGame", { level = 1, score = 0 })
				end)
			end
			self.canInput = false
		end
	end
	self.timer.update(dt)
end

function StartState:render()
	self.board:render()
	love.graphics.setColor(0, 0, 0, 0.5)
	love.graphics.rectangle("fill", 0, 0, VW, VH)

	love.graphics.setFont(fonts["large"])
	love.graphics.setColor(1, 1, 1, 0.5)
	love.graphics.rectangle("fill", HVW - 76, HVH - 64, 152, 60, 6)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf("MATCH 3", 0, HVH - 48, VW, "center")
	love.graphics.setFont(fonts["medium"])
	love.graphics.setColor(1, 1, 1, 0.5)
	love.graphics.rectangle("fill", HVW - 76, HVH, 152, 72, 6)

	if self.currOption == 1 then
		love.graphics.setColor(0, 1, 1, 1)
	else
		love.graphics.setColor(0, 0, 1, 1)
	end

	love.graphics.printf("START", 0, HVH + 16, VW, "center")
	if self.currOption == 2 then
		love.graphics.setColor(0, 1, 1, 1)
	else
		love.graphics.setColor(0, 0, 1, 1)
	end
	love.graphics.printf("QUIT GAME", 0, HVH + 32, VW, "center")
	love.graphics.setColor(1, 1, 1, self.transAlpha)
	love.graphics.rectangle("fill", 0, 0, VW, VH)
	love.graphics.setColor(1, 1, 1, 1)

end
