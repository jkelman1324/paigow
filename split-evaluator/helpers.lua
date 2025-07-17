local M = {}

M.rankOrder = {
    ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6,
    ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10,
    ["J"] = 11, ["Q"] = 12, ["K"] = 13, ["A"] = 14,
    ["Joker"] = 14,
}

function M.rankValue(card)
    return M.rankOrder[card.rank] or 0
end

function M.sortByRankDesc(cards)
    table.sort(cards, function(a, b)
        return M.rankValue(a) > M.rankValue(b)
    end)
end

function M.countRanks(cards)
    local counts = {}
    for _, card in ipairs(cards) do
        counts[card.rank] = (counts[card.rank] or 0) + 1
    end
    return counts
end

function M.pairCategory(rank)
    local val = M.rankOrder[rank]
    if val >= 11 then
        return "High"
    elseif val >= 7 then
        return "Medium"
    else
        return "Low"
    end
end

function M.findCardsByRank(cards, rank, n)
    local found = {}
    for _, card in ipairs(cards) do
        if card.rank == rank and #found < n then
            table.insert(found, card)
        end
    end
    return found
end

function M.getNonPairCards(cards, counts)
    local nonPairs = {}
    for _, card in ipairs(cards) do
        if counts[card.rank] < 2 then
            table.insert(nonPairs, card)
        end
    end
    return nonPairs
end

return M

