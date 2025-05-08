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

local royalRanks = { ["A"] = 1, ["K"] = 1, 12, 11, 10 }

local function containsJoker(hand)
	for _, card in ipairs(hand) do
		if card.rank == "Joker" then
			return true
		end
	end
	return false
end

local function tablesEqual(t1, t2)
	-- If both are not tables or are the same table, return direct comparison
	if t1 == t2 then
		return true
	end
	if type(t1) ~= "table" or type(t2) ~= "table" then
		return false
	end

	-- Check if they have the same number of keys
	local t1Count, t2Count = 0, 0
	for _ in pairs(t1) do
		t1Count = t1Count + 1
	end
	for _ in pairs(t2) do
		t2Count = t2Count + 1
	end
	if t1Count ~= t2Count then
		return false
	end

	-- Compare each key-value pair
	for key, value1 in pairs(t1) do
		local value2 = t2[key]

		-- If value is a table, compare recursively
		if type(value1) == "table" and type(value2) == "table" then
			if not tablesEqual(value1, value2) then
				return false
			end
		else
			if value1 ~= value2 then
				return false
			end
		end
	end

	return true
end

local function isStraight(cards)
	for i = 1, 4, 1 do
		if cards[i] - cards[i + 1] ~= 1 then
			return false
		end
	end
	return true
end

function M.evaluateHighHand(cards)
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

	-- Royal Flush
	if #suits == 1 and tablesEqual(rankValuesList, royalRanks) then
		return {
			rank = "Royal Flush",
			value = 10,
		}
	end

	-- Straight Flush
	local straight = isStraight(rankValuesList)
	if #suits == 1 and straight then
		return {
			rank = "Straight Flush",
			value = 9,
			tiebreaker = rankValuesList[1],
		}
	end

	-- Four of a Kind
	for _, v in pairs(ranks) do
		if v == 4 then
			return {
				rank = "Four of a Kind",
				value = 8,
				tiebreaker = v,
			}
		end
	end

	-- Full House
	local set = false
	local setVal = 0
	local pair = false
	local pairVal = 0
	for _, v in pairs(ranks) do
		if v == 3 then
			set = true
			setVal = v
		end
		if v == 2 then
			pair = true
			pairVal = v
		end
	end
	if set and pair then
		return {
			rank = "Full House",
			value = 7,
			tiebreaker = { setVal },
		}
	end

	-- Flush
	if #suits == 1 then
		return {
			rank = "Flush",
			value = 6,
			tiebreaker = rankValuesList,
		}
	end

	-- Straight
	if straight then
		return {
			rank = "Straight",
			value = 5,
			tiebreaker = rankValuesList,
		}
	end

	-- Three of a Kind
	if set then
		return {
			rank = "Three of a Kind",
			value = 4,
			tiebreaker = { setVal },
		}
	end

	-- Two-Pair
	local pairVals = {}
	for _, v in pairs(ranks) do
		if v == 2 then
			table.insert(pairVals, v)
		end
	end
	if #pairVals == 2 then
		table.sort(pairVals, function(a, b)
			return a > b
		end)
		return {
			rank = "Two Pair",
			value = 3,
			tiebreaker = pairVals,
		}
	end

	-- Pair
	if pair then
		return {
			rank = "Pair",
			value = 2,
			tiebreaker = pairVal,
		}
	end

	-- High Card
	return {
		rank = "High Card",
		value = 1,
		tiebreaker = rankValuesList,
	}
end

return M
