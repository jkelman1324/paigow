local helpers = require("split-evaluator.helpers")

local M = {}

function M.splitHighCard(cards)
  helpers.sortByRankDesc(cards)
  local lowHand = {cards[2], cards[3]}
  local highHand = {cards[1]}
  for i = 4, #cards do
    table.insert(highHand, cards[i])
  end
  return {low = lowHand, high = highHand}
end

return M

