local M = {}

local rankOrder = {
  ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6,
  ["7"] = 7, ["8"] = 8, ["9"] = 9, ["10"] = 10,
  ["J"] = 11, ["Q"] = 12, ["K"] = 13, ["A"] = 14,
  ["Joker"] = 14, -- treat Joker as Ace for house way
}

local function rankValue(card)
  return rankOrder[card.rank] or 0
end

local function sortByRankDesc(cards)
  table.sort(cards, function(a, b) return rankValue(a) > rankValue(b) end)
end

-- Helper to count rank frequencies
local function countRanks(cards)
  local counts = {}
  for _, card in ipairs(cards) do
    counts[card.rank] = (counts[card.rank] or 0) + 1
  end
  return counts
end

-- Split High Card hand according to house way
local function splitHighCard(cards)
  -- cards assumed sorted descending
  local front = {cards[2], cards[3]} -- second and third highest to front (2-card hand)
  local back = {cards[1]}             -- highest card starts back hand
  for i = 4, #cards do
    table.insert(back, cards[i])
  end
  return {front = front, back = back}
end

-- Main entry
function M.houseWaySplit(cards)
  sortByRankDesc(cards)
  local counts = countRanks(cards)

  -- TODO: implement detection of pairs, trips, straights, etc.

  -- Placeholder: if no pairs or better, treat as high card
  return splitHighCard(cards)
end

return M

