local love = require("love")
local deckModule = require("Deck")
local playerModule = require("Player")
local evaluator = require("HandEvaluator")

local cardImages = {}
local minCardWidth = 70
local maxCardWidth = 120
local cardAspectRatio = 2 / 3
local margin = 50

math.randomseed(os.time())
local deck = Deck:new()
deck:shuffle()

local player = Player:new("You")
player:receiveCards(deck:deal(7))

function love.load()
	-- for _, card in ipairs(player.hand) do
	--  cardImages[card.image] = love.graphics.newImage(card.image)
	-- end
	print(evaluator.evaluateHighHand(player.hand).rank)
end

local function calculateLayout()
	local screenWidth = love.graphics.getWidth()
	local numCards = #player.hand

	-- Calculate available width for cards ()
	local availableWidth = screenWidth - (2 * margin)

	-- Determine card width and spacing
	local cardWidth = math.min(maxCardWidth, availableWidth / numCards * 0.9)
	cardWidth = math.max(cardWidth, minCardWidth)

	local cardHeight = cardWidth / cardAspectRatio
	local cardSpacing = (availableWidth - (cardWidth * numCards)) / (numCards - 1)

	return cardWidth, cardHeight, cardSpacing
end

function love.update() end

function love.draw()
	local cardWidth, cardHeight, cardSpacing = calculateLayout()
	local startX = margin
	local y = love.graphics.getHeight() / 2 - cardHeight / 2

	for i, card in ipairs(player.hand) do
		local x = startX + (i - 1) * (cardWidth + cardSpacing)

		-- Draw card image or placeholder
		if cardImages[card.image] then
			love.graphics.draw(
				cardImages[card.image],
				x,
				y,
				0,
				cardWidth / cardImages[card.image]:getWidth(),
				cardHeight / cardImages[card.image]:getHeight()
			)
		else
			love.graphics.setColor(0.8, 0.8, 0.8)
			love.graphics.rectangle("fill", x, y, cardWidth, cardHeight)
			love.graphics.setColor(0, 0, 0)
			love.graphics.printf(card.rank .. " " .. (card.suit or ""), x, y + cardHeight / 2 - 10, cardWidth, "center")
		end
	end
end
