local love = require("love")
local deckModule = require("Deck")
local playerModule = require("Player")

function love.load()
	deck = Deck:new()
	deck:shuffle()

	player = Player:new("You")
	dealer = Player:new("Dealer")

	player:receiveCards(deck:deal(7))
	dealer:receiveCards(deck:deal(7))

	print("Player Hand:")
	for _, card in ipairs(player.hand) do
		print(card.rank .. " of " .. card.suit)
	end

	print("Dealer Hand:")
	for _, card in ipairs(dealer.hand) do
		print(card.rank .. " of " .. card.suit)
	end
end

function love.update() end

function love.draw() end
