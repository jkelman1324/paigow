local helpers = require("split-evaluator.helpers")

local M = {}

function M.splitHighCard(cards)
    helpers.sortByRankDesc(cards)
    local lowHand = { cards[1], cards[2] }
    local highHand = {}
    for i = 3, #cards do
        table.insert(highHand, cards[i])
    end
    return { high = highHand, low = lowHand }
end

return M

