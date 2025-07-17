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
    ["Joker"] = 0,
}

local handValues = {
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
    ["Five Aces"] = 11,
}

local function isStraight(rankValuesList, hasJoker)
    local gaps = 0
    for i = 1, #rankValuesList - 1 do
        local diff = rankValuesList[i] - rankValuesList[i+1]
        if diff == 1 then
            -- fine
        elseif diff > 1 then
            gaps = gaps + (diff - 1)
        else
            return false -- duplicate or invalid sequence
        end
    end

    if hasJoker then
        return gaps <= 1
    else
        return gaps == 0
    end
end

function M.evaluateHighHand(cards)
    local ranks = {}
    local suits = {}
    local hasJoker = false

    for _, card in ipairs(cards) do
        ranks[card.rank] = (ranks[card.rank] or 0) + 1

        if card.rank ~= "Joker" then
            suits[card.suit] = (suits[card.suit] or 0) + 1
        end
    end

    local rankValuesList = {}
    for rank, count in pairs(ranks) do
        if rank == "Joker" then
            hasJoker = true
        else
            local value = rankValues[rank]
            for _ = 1, count do
                table.insert(rankValuesList, value)
            end
        end
    end
    table.sort(rankValuesList, function(a, b)
        return a > b
    end)

    -- Five Aces
    if ranks["A"] == 4 and hasJoker then
        return {
            rank = "Five Aces",
            value = handValues["Five Aces"]
        }
    end

    -- Royal Flush
    if #suits == 1 and isStraight(rankValuesList, hasJoker) and rankValuesList[1] == 14 then
        return {
            rank = "Royal Flush",
            value = handValues["Royal Flush"],
        }
    end

    -- Straight Flush
    local straight = isStraight(rankValuesList, hasJoker)
    if #suits == 1 and straight then
        return {
            rank = "Straight Flush",
            value = handValues["Straight Flush"],
            tiebreaker = rankValuesList[1],
        }
    end

    -- Four of a Kind
    for rank, count in pairs(ranks) do
        if count == 4 then
            return {
                rank = "Four of a Kind",
                value = handValues["Four of a Kind"],
                tiebreaker = rankValues[rank],
            }
        end
    end

    -- Full House
    local set, pair = false, false
    local setVal, pairVal
    for rank, count in pairs(ranks) do
        if count == 3 then
            set = true
            setVal = rankValues[rank]
        end
        if count == 2 then
            pair = true
            pairVal = rankValues[rank]
        end
    end
    if set and pair then
        return {
            rank = "Full House",
            value = handValues["Full House"],
            tiebreaker = { setVal },
        }
    end

    -- Flush
    if #suits == 1 then
        return {
            rank = "Flush",
            value = handValues["Flush"],
            tiebreaker = rankValuesList,
        }
    end

    -- Straight
    if straight then
        return {
            rank = "Straight",
            value = handValues["Straight"],
            tiebreaker = rankValuesList[1]
        }
    end

    -- Three of a Kind
    if set then
        return {
            rank = "Three of a Kind",
            value = handValues["Three of a Kind"],
            tiebreaker = { setVal },
        }
    end

    -- Two-Pair
    local pairVals = {}
    for rank, count in pairs(ranks) do
        if count == 2 then
            table.insert(pairVals, rankValues[rank])
        end
    end
    if #pairVals == 2 then
        table.sort(pairVals, function(a, b)
            return a > b
        end)
        return {
            rank = "Two Pair",
            value = handValues["Two Pair"],
            tiebreaker = pairVals,
        }
    end

    -- One Pair
    if pair then
        return {
            rank = "One Pair",
            value = handValues["One Pair"],
            tiebreaker = pairVal,
        }
    end

    -- High Card
    return {
        rank = "High Card",
        value = handValues["High Card"],
        tiebreaker = rankValuesList,
    }
end

function M.evaluateLowHand(cards)
    local ranks = {}
    for _, card in ipairs(cards) do
        ranks[card.rank] = (ranks[card.rank] or 0) + 1
    end

    local rankVals = {}
    for rank, count in pairs(ranks) do
        local val = (rank == "Joker") and rankValues["A"] or rankValues[rank]
        for _ = 1, count do
            table.insert(rankVals, val)
        end
    end

    table.sort(rankVals, function(a, b)
        return a > b
    end)

    -- Check for One Pair
    for _, count in pairs(ranks) do
        if count == 2 then
            return {
                rank = "One Pair",
                value = handValues["One Pair"],
                tiebreaker = rankVals,
            }
        end
    end

    -- High Card
    return {
        rank = "High Card",
        value = handValues["High Card"],
        tiebreaker = rankVals,
    }
end

return M

