GameOverState = Class({ __includes = BaseState })

function GameOverState:enter(params)
	self.score = params.score
end

function GameOverState:update()
	if love.keyboard.active["enter"] or love.keyboard.active["return"] then
		gsm:change("start")
	end
end

function GameOverState:render()
	love.graphics.setColor(0, 0, 0, 0.7)
	love.graphics.rectangle("fill", HVW - 76, HVH - 70, 152, 130, 6)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(fonts["large"])
	love.graphics.printf("GAME\nOVER", 0, HVH - 64, VW, "center")
	love.graphics.setFont(fonts["medium"])
	love.graphics.printf("Your Score: " .. tostring(self.score), 0, HVH + 8, VW, "center")
	love.graphics.printf("Press Enter", 0, HVH + 32, VW, "center")
	love.graphics.setColor(1, 1, 1, 1)
end
