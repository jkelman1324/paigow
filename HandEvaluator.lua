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

	for _, card in ipairs(cards) do
		ranks[card.rank] = (ranks[card.rank] or 0) + 1

		if card.rank ~= "Joker" then
			suits[card.suit] = (suits[card.suit] or 0) + 1
		end
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

	-- Five Aces
	if ranks["A"] == 4 and ranks["Joker"] == 1 then
		return {
			rank = "Five Aces",
			value = 11,
		}
	end
end

local function containsJoker(hand)
	for _, card in ipairs(hand) do
		if card.rank == "Joker" then
			return true
		end
	end
	return false
end

local function isStraight(cards)
	local iterations = 3
	if containsJoker(cards) then
		iterations = 2
	end

	for i = 1, iterations, 1 do
		local count = 0
		local j = i
		while true do
			if ranks[j + 1] - ranks[j] == 1 then
				j = j + 1
				count = count + 1
			else
				count = 0
				break
			end

			if count == 5 then
			end
		end
	end
end

return M
