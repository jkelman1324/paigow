local love = require("love")
local deckModule = require("Deck")
local playerModule = require("Player")
local evaluator = require("HandEvaluator")

function love.load()
	math.randomseed(os.time())
	local deck = Deck:new()
	deck:shuffle()

	local player = Player:new("You")
	local dealer = Player:new("Dealer")

	player:receiveCards(deck:deal(7))
	dealer:receiveCards(deck:deal(7))

	evaluator.evaluateHand(player.hand)
end

function love.update() end

function love.draw() end
