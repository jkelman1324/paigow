local M = {}

local rankValues = {
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
	["5"] = 5,
	["6"] = 6,
	["7"] = 7,
	["8"] = 8,
	["9"] = 9,
	["10"] = 10,
	["J"] = 11,
	["Q"] = 12,
	["K"] = 13,
	["A"] = 14,
	["Joker"] = 0, -- Special handling
}

local handRanks = {
	["High Card"] = 1,
	["One Pair"] = 2,
	["Two Pair"] = 3,
	["Three of a Kind"] = 4,
	["Straight"] = 5,
	["Flush"] = 6,
	["Full House"] = 7,
	["Four of a Kind"] = 8,
	["Straight Flush"] = 9,
	["Royal Flush"] = 10,
	["Five Aces"] = 11, -- with Joker
}

function M.evaluateHand(cards)
	local ranks = {}
	local suits = {}
	for _, card in pairs(cards) do
		ranks[card.rank] = (ranks[card.rank] or 0) + 1
		suits[card.suit] = (suits[card.suit] or 0) + 1
	end

	local rankValuesList = {}
	for rank, count in pairs(ranks) do
		local value = rankValues[rank]
		for _ = 1, count do
			table.insert(rankValuesList, value)
		end
	end
	table.sort(rankValuesList, function(a, b)
		return a > b
	end)

	if ranks["Joker"] ~= nil then
	else
	end
end

return M
