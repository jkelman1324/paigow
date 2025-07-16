local splitEvaluator = require("split-evaluator")
local helpers = require("split-evaluator.helpers")

local function makeCard(rank, suit)
  return { rank = rank, suit = suit }
end

local function testTwoPair()
  local tests = {
    {
      name = "Low Pair - Low Pair",
      hand = {
        makeCard("2", "Hearts"), makeCard("2", "Spades"),
        makeCard("5", "Clubs"), makeCard("5", "Diamonds"),
        makeCard("K", "Hearts"), makeCard("J", "Clubs"),
        makeCard("9", "Spades"),
      },
      expectPairsInHigh = true,
    },
    {
      name = "Low Pair - Medium Pair, no King",
      hand = {
        makeCard("3", "Hearts"), makeCard("3", "Diamonds"),
        makeCard("8", "Clubs"), makeCard("8", "Spades"),
        makeCard("Q", "Hearts"), makeCard("7", "Clubs"),
        makeCard("5", "Spades"),
      },
      expectPairsInHigh = false,
    },
    {
      name = "Low Pair - Medium Pair, with King",
      hand = {
        makeCard("4", "Hearts"), makeCard("4", "Diamonds"),
        makeCard("9", "Clubs"), makeCard("9", "Spades"),
        makeCard("K", "Hearts"), makeCard("7", "Clubs"),
        makeCard("5", "Spades"),
      },
      expectPairsInHigh = true,
    },
    {
      name = "Low Pair - High Pair, with Ace",
      hand = {
        makeCard("5", "Hearts"), makeCard("5", "Diamonds"),
        makeCard("J", "Clubs"), makeCard("J", "Spades"),
        makeCard("A", "Hearts"), makeCard("7", "Clubs"),
        makeCard("3", "Spades"),
      },
      expectPairsInHigh = true,
    },
    {
      name = "Low Pair - High Pair, no Ace",
      hand = {
        makeCard("6", "Hearts"), makeCard("6", "Diamonds"),
        makeCard("Q", "Clubs"), makeCard("Q", "Spades"),
        makeCard("K", "Hearts"), makeCard("7", "Clubs"),
        makeCard("3", "Spades"),
      },
      expectPairsInHigh = false,
    },
    {
      name = "High Pair - High Pair",
      hand = {
        makeCard("K", "Hearts"), makeCard("K", "Diamonds"),
        makeCard("A", "Clubs"), makeCard("A", "Spades"),
        makeCard("5", "Hearts"), makeCard("7", "Clubs"),
        makeCard("3", "Spades"),
      },
      expectPairsInHigh = false,
    },
  }

  for _, test in ipairs(tests) do
    local split = splitEvaluator.houseWaySplit(test.hand)
    local counts = helpers.countRanks(test.hand)

    -- Check pairs are in high or split
    local pairsInHigh = true
    for _, rank in ipairs({"2","3","4","5","6","7","8","9","10","J","Q","K","A"}) do
      if counts[rank] == 2 then
        local inHigh = false
        for _, card in ipairs(split.high) do
          if card.rank == rank then
            inHigh = true
          end
        end
        if not inHigh then
          pairsInHigh = false
          break
        end
      end
    end

    if pairsInHigh ~= test.expectPairsInHigh then
      error(test.name .. " failed: expected pairsInHigh=" .. tostring(test.expectPairsInHigh) .. " got " .. tostring(pairsInHigh))
    end

    print(test.name .. " passed")
  end
end

testTwoPair()

