local helpers = require("split-evaluator.helpers")

local M = {}

function M.splitTwoPair(cards, pairs, counts)
  local p1, p2 = pairs[1], pairs[2]
  local cat1, cat2 = helpers.pairCategory(p1), helpers.pairCategory(p2)

  local hasAce = (counts["A"] or 0) > 0
  local hasJoker = (counts["Joker"] or 0) > 0
  local hasKing = (counts["K"] or 0) > 0

  local function playBothPairsInHigh()
    local highHand = {}
    for _, rank in ipairs(pairs) do
      local pairCards = helpers.findCardsByRank(cards, rank, 2)
      for _, c in ipairs(pairCards) do
        table.insert(highHand, c)
      end
    end
    local nonPairs = helpers.getNonPairCards(cards, counts)
    helpers.sortByRankDesc(nonPairs)
    local lowHand = {nonPairs[1], nonPairs[2]}
    return {high = highHand, low = lowHand}
  end

  local function splitPairs()
    local highHand = helpers.findCardsByRank(cards, p1, 2)
    local lowHand = helpers.findCardsByRank(cards, p2, 2)
    for _, card in ipairs(cards) do
      if card.rank ~= p1 and card.rank ~= p2 then
        table.insert(highHand, card)
      end
    end
    return {high = highHand, low = lowHand}
  end

  if ((cat1 == "High" and cat2 == "Medium") or (cat2 == "High" and cat1 == "Medium")) then
    return splitPairs()
  end

  if cat1 == "Low" and cat2 == "Low" then
    return playBothPairsInHigh()
  end

  if (cat1 == "Low" and cat2 == "Medium") or (cat1 == "Medium" and cat2 == "Low") then
    if hasKing then
      return playBothPairsInHigh()
    else
      return splitPairs()
    end
  end

  if (cat1 == "Low" and cat2 == "High") or (cat1 == "High" and cat2 == "Low") then
    if hasAce or hasJoker then
      return playBothPairsInHigh()
    else
      return splitPairs()
    end
  end

  if cat1 == "Medium" and cat2 == "Medium" then
    if hasAce or hasJoker then
      return playBothPairsInHigh()
    else
      return splitPairs()
    end
  end

  if (cat1 == "Medium" and cat2 == "High") or (cat1 == "High" and cat2 == "Medium") then
    if hasAce and hasKing then
      return playBothPairsInHigh()
    else
      return splitPairs()
    end
  end

  if cat1 == "High" and cat2 == "High" then
    return splitPairs()
  end

  return splitPairs()
end

return M

