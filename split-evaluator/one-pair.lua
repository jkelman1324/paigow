local helpers = require("split-evaluator.helpers")

local M = {}

function M.splitOnePair(cards, pairRank, counts)
    local pairCards = helpers.findCardsByRank(cards, pairRank, 2)
    local highHand = {}
    for _, c in ipairs(pairCards) do
        table.insert(highHand, c)
    end

    local lowHand = {}
    for _, card in ipairs(cards) do
        if card.rank ~= pairRank then
            table.insert(lowHand, card)
        end
    end

    helpers.sortByRankDesc(lowHand)
    local lowSplit = { lowHand[1], lowHand[2] }

    for i = 3, #lowHand do
        table.insert(highHand, lowHand[i])
    end

    return { high = highHand, low = lowSplit }
end

return M

