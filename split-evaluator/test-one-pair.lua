local splitEvaluator = require("split-evaluator")

local function makeCard(rank, suit)
  return { rank = rank, suit = suit }
end

local function testOnePair()
  local hand = {
    makeCard("8", "Hearts"),
    makeCard("8", "Spades"),
    makeCard("K", "Clubs"),
    makeCard("10", "Hearts"),
    makeCard("5", "Diamonds"),
    makeCard("3", "Clubs"),
    makeCard("2", "Spades"),
  }

  local split = splitEvaluator.houseWaySplit(hand)

  assert(#split.high >= 5, "High hand should have 5 or more cards")
  assert(#split.low == 2, "Low hand should have 2 cards")

  local highRanks = {}
  for _, c in ipairs(split.high) do
    highRanks[c.rank] = (highRanks[c.rank] or 0) + 1
  end

  assert(highRanks["8"] == 2, "High hand must contain the pair")
  print("One Pair test passed")
end

testOnePair()

