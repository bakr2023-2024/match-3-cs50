require("src.Dependencies")
local backgroundX = 0
function love.load()
	love.window.setTitle("Match 3")
	love.graphics.setDefaultFilter("nearest", "nearest")
	math.randomseed(os.time())
	love.graphics.setFont(fonts["medium"])
	-- sounds["music"]:setLooping(true)
	-- sounds["music"]:play()
	gsm = StateMachine({
		["start"] = function()
			return StartState()
		end,
		['beginGame'] = function ()
		return BeginGameState()
		end,
		["play"] = function()
			return PlayState()
		end,
		['gameOver'] = function()
		return GameOverState()
		end
	})
	gsm:change("start")
	love.window.setMode(WW, WH, { fullscreen = false, vsync = true })
	push:setupScreen(VW, VH, WW, WH)
	love.keyboard.active = {}
end
function love.update(dt)
	backgroundX = backgroundX - BACKGROUND_SCROLL * dt
	if backgroundX <= -1024 + VW - 4 + 51 then
		backgroundX = 0
	end
	gsm:update(dt)
	love.keyboard.active = {}
end
function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	else
		love.keyboard.active[key] = true
	end
end
function love.draw()
	push:start()
	love.graphics.draw(textures["background"], backgroundX, 0)
	gsm:render()
	push:finish()
end
