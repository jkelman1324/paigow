local love = require("love")
local deckModule = require("Deck")
local playerModule = require("Player")
local evaluator = require("HandEvaluator")

function love.load()
	math.randomseed(os.time())
	local deck = Deck:new()
	deck:shuffle()

	local player = Player:new("You")
end

function love.update() end

function love.draw() end
