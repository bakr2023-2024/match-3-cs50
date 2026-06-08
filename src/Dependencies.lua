Class = require("lib.class")
push = require("lib.push")

WW, WH = 1280, 720
VW, VH = 512, 288
HVW, HVH = VW / 2, VH / 2
BACKGROUND_SCROLL = 80

SUBSET = 8
BASE_SCORE_GOAL = 1000
BASE_TILE_SCORE = 25
BASE_VARIETY_SCORE = 15

require("src.Tile")
require("src.Board")

require("src.states.BaseState")
require("src.states.StartState")
require("src.states.BeginGameState")
require("src.states.PlayState")
require("src.states.GameOverState")
require("src.StateMachine")

require("src.Utils")

sounds = {
	["music"] = love.audio.newSource("sounds/music3.mp3", "static"),
	["select"] = love.audio.newSource("sounds/select.wav", "static"),
	["error"] = love.audio.newSource("sounds/error.wav", "static"),
	["match"] = love.audio.newSource("sounds/match.wav", "static"),
	["clock"] = love.audio.newSource("sounds/clock.wav", "static"),
	["game-over"] = love.audio.newSource("sounds/game-over.wav", "static"),
	["next-level"] = love.audio.newSource("sounds/next-level.wav", "static"),
}

textures = {
	["tiles"] = love.graphics.newImage("graphics/match3.png"),
	["background"] = love.graphics.newImage("graphics/background.png"),
}

frames = {
	["tiles"] = GenerateQuads(textures["tiles"]),
}

fonts = {
	["small"] = love.graphics.newFont("fonts/font.ttf", 8),
	["medium"] = love.graphics.newFont("fonts/font.ttf", 16),
	["large"] = love.graphics.newFont("fonts/font.ttf", 32),
}
