local helpers = require("split-evaluator.helpers")
local onePair = require("split-evaluator.one-pair")
local twoPair = require("split-evaluator.two-pair")
local highCard = require("split-evaluator.high-card")

local M = {}

function M.houseWaySplit(cards)
    helpers.sortByRankDesc(cards)
    local counts = helpers.countRanks(cards)

    local pairsFound = {}
    for rank, count in pairs(counts) do
        if count == 2 then
            table.insert(pairsFound, rank)
        end
    end
    table.sort(pairsFound, function(a, b)
        return helpers.rankOrder[a] > helpers.rankOrder[b]
    end)

    if #pairsFound >= 2 then
        return twoPair.splitTwoPair(cards, pairsFound, counts)
    elseif #pairsFound == 1 then
        return onePair.splitOnePair(cards, pairsFound[1], counts)
    end

    -- TODO: Add more hand type checks here

    return highCard.splitHighCard(cards)
end

return M

