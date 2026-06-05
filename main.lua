require("src.Dependencies")

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
	textures = {
		["background"] = love.graphics.newImage("graphics/background.png"),
		["tiles"] = love.graphics.newImage("graphics/match3.png"),
	}
	backgroundSX = VW / textures["background"]:getWidth()
	backgroundSY = VH / textures["background"]:getHeight()
	frames = {
		["tiles"] = GenerateQuads(textures["tiles"], 32, 32),
	}
	love.window.setMode(WW, WH, { fullscreen = false })
	push:setupScreen(VW, VH, WW, WH)
end

function love.draw()
	push:start()
	love.graphics.draw(textures["background"], 0, 0, 0, backgroundSX, backgroundSY)
	love.graphics.printf("Hello Match3", 0, HVH - 8, VW, "center")
	push:finish()
end
