StartState = Class({ __includes = BaseState })

local currOption = 1

function StartState:init() end

function StartState:enter(params) end

function StartState:update(dt)
	if love.keyboard.active["up"] then
		currOption = currOption == 1 and 2 or 1
	elseif love.keyboard.active["down"] then
		currOption = currOption == 2 and 1 or 2
	elseif love.keyboard.active["enter"] or love.keyboard.active["return"] then
		if currOption == 2 then
			love.event.quit()
		else
			gsm:change("play", { level = 1 })
		end
	end
end

function StartState:render()
	love.graphics.setFont(fonts["large"])
	love.graphics.setColor(1, 1, 1, 0.5)
	love.graphics.rectangle("fill", HVW - 76, HVH - 64, 152, 60, 6)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.printf("MATCH 3", 0, HVH - 48, VW, "center")
	love.graphics.setFont(fonts["medium"])
	love.graphics.setColor(1, 1, 1, 0.5)
	love.graphics.rectangle("fill", HVW - 76, HVH, 152, 72, 6)
	if currOption == 1 then
		love.graphics.setColor(0, 1, 1, 1)
	else
		love.graphics.setColor(0, 0, 1, 1)
	end

	love.graphics.printf("START", 0, HVH + 16, VW, "center")
	if currOption == 2 then
		love.graphics.setColor(0, 1, 1, 1)
	else
		love.graphics.setColor(0, 0, 1, 1)
	end
	love.graphics.printf("QUIT GAME", 0, HVH + 32, VW, "center")
	love.graphics.setColor(1, 1, 1, 1)
end
