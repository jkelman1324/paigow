local love = require("love")
local deckModule = require("Deck")
local playerModule = require("Player")
local evaluator = require("HandEvaluator")

local cardImages = {}
local minCardWidth = 70
local maxCardWidth = 120
local cardAspectRatio = 2 / 3
local margin = 50
local lowHandLength = 0
local cardCoordinates = {}
local inLowHand = { false, false, false, false, false, false, false }

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

function love.update(dt)
	if player.hand ~= nil and love.mouse.isDown(1) then
		local x, y = love.mouse.getPosition()
		for i, card in pairs(cardCoordinates) do
			if x > card.x1 and x < card.x2 and y > card.y1 and y < card.y2 then
				if not inLowHand[i] then
					inLowHand[i] = true
				else
					inLowHand[i] = false
				end
			end
		end
	end
end

function love.draw()
	local cardWidth, cardHeight, cardSpacing = calculateLayout()
	local firstLow = false
	local startX = margin
	local y = love.graphics.getHeight() - cardHeight - margin
	local highHandCount = 0

	for i, card in ipairs(player.hand) do
		local x = startX + highHandCount * (cardWidth + cardSpacing)

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
			if inLowHand[i] then
				x = love.graphics.getWidth() / 2 - cardWidth - cardSpacing / 2
				if firstLow then
					x = love.graphics.getWidth() / 2 + cardSpacing / 2
				else
					firstLow = true
				end
				love.graphics.setColor(0.8, 0.8, 0.8)
				love.graphics.rectangle("fill", x, y - cardHeight - margin, cardWidth, cardHeight)
				love.graphics.setColor(0, 0, 0)
				love.graphics.printf(
					card.rank .. " " .. (card.suit or ""),
					x,
					y - cardHeight - margin,
					cardWidth,
					"center"
				)
				table.insert(
					cardCoordinates,
					{ x1 = x, x2 = x + cardWidth, y1 = y - cardHeight - margin, y2 = y - margin }
				)
			else
				love.graphics.setColor(0.8, 0.8, 0.8)
				love.graphics.rectangle("fill", x, y, cardWidth, cardHeight)
				love.graphics.setColor(0, 0, 0)
				love.graphics.printf(
					card.rank .. " " .. (card.suit or ""),
					x,
					y + cardHeight / 2 - 10,
					cardWidth,
					"center"
				)
				table.insert(cardCoordinates, { x1 = x, x2 = x + cardWidth, y1 = y, y2 = y + cardHeight })
				highHandCount = highHandCount + 1
			end
		end
	end

	-- Draw low hand
	for i, v in ipairs(inLowHand) do
		if v then
		end
	end
end
