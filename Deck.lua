Deck = {}
Deck.__index = Deck

function Deck:new()
	local deck = {}
	setmetatable(deck, Deck)

	deck.cards = {}

	local ranks = { "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K" }
	local suits = { "Diamonds", "Clubs", "Hearts", "Spades" }

	for _, rank in ipairs(ranks) do
		for _, suit in ipairs(suits) do
			table.insert(deck.cards, { rank = rank, suit = suit })
		end
	end

	table.insert(deck.cards, { rank = "Joker" })

	return deck
end

function Deck:shuffle()
	local cards = self.cards
	for i = #cards, 2, -1 do
		local j = math.random(i)
		cards[i], cards[j] = cards[j], cards[i]
	end
end

function Deck:deal(n)
	local hand = {}
	for _ = 1, n do
		table.insert(hand, table.remove(self.cards))
	end
	return hand
end

return Deck
