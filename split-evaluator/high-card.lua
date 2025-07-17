-- high-card.lua
local helpers = require("helpers")

local M = {}

function M.splitHighCard(cards)
    helpers.sortByRankDesc(cards)
    -- Put highest card in high hand, next two highest in low hand
    local highHand = { cards[1] }
    local lowHand = { cards[2], cards[3] }
    
    -- Remaining cards go to high hand
    for i = 4, #cards do
        table.insert(highHand, cards[i])
    end
    
    return { high = highHand, low = lowHand }
end

return M
