require("src.Dependencies")
local backgroundX = 0
function love.load()
	love.window.setTitle("Match 3")
	love.graphics.setDefaultFilter("nearest", "nearest")
	math.randomseed(os.time())
	fonts = {
		["small"] = love.graphics.newFont("fonts/font.ttf", 8),
		["medium"] = love.graphics.newFont("fonts/font.ttf", 16),
		["large"] = love.graphics.newFont("fonts/font.ttf", 32),
	}
	love.graphics.setFont(fonts["medium"])
	-- sounds["music"]:setLooping(true)
	-- sounds["music"]:play()
	love.window.setMode(WW, WH, { fullscreen = false, vsync = true })
	push:setupScreen(VW, VH, WW, WH)
end
function love.update(dt)
	backgroundX = backgroundX - BACKGROUND_SCROLL * dt
	if backgroundX <= -1024 + VW + 47 then
		backgroundX = 0
	end
end
function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end
function love.draw()
	push:start()
	love.graphics.draw(textures["background"], backgroundX, 0)
	push:finish()
end
