local splitEvaluator = require("split-evaluator")

local function makeCard(rank, suit)
    return { rank = rank, suit = suit }
end

local function testHighCard()
    local hand = {
        makeCard("Q", "Hearts"),
        makeCard("10", "Clubs"),
        makeCard("7", "Diamonds"),
        makeCard("4", "Spades"),
        makeCard("2", "Hearts"),
        makeCard("9", "Clubs"),
        makeCard("J", "Diamonds"),
    }

    local split = splitEvaluator.houseWaySplit(hand)

    assert(#split.high == 5, "High hand should have 5 cards")
    assert(#split.low == 2, "Low hand should have 2 cards")

    -- High hand must contain the highest card
    local highRanks = {}
    for _, c in ipairs(split.high) do
        highRanks[c.rank] = true
    end
    assert(highRanks["Q"], "High hand must contain Queen")

    print("High Card test passed")
end

testHighCard()

