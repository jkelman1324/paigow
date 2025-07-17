-- one-pair.lua
local helpers = require("helpers")

local M = {}

function M.splitOnePair(cards, pairRank, counts)
    local pairCards = helpers.findCardsByRank(cards, pairRank, 2)
    local highHand = {}
    
    -- Add pair to high hand
    for _, card in ipairs(pairCards) do
        table.insert(highHand, card)
    end

    -- Get remaining cards for low hand
    local remainingCards = {}
    for _, card in ipairs(cards) do
        if helpers.getEffectiveRank(card) ~= pairRank then
            table.insert(remainingCards, card)
        end
    end

    helpers.sortByRankDesc(remainingCards)
    
    -- Two highest remaining cards go to low hand
    local lowHand = { remainingCards[1], remainingCards[2] }
    
    -- Rest go to high hand
    for i = 3, #remainingCards do
        table.insert(highHand, remainingCards[i])
    end

    return { high = highHand, low = lowHand }
end

return M
