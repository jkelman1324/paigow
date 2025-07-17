-- test-one-pair.lua
local onePair = require("one-pair")
local helpers = require("helpers")
local testUtils = require("test-utils")

local function testBasicOnePair()
    local cards = {
        testUtils.card("A", "Hearts"),
        testUtils.card("A", "Clubs"),
        testUtils.card("K", "Diamonds"),
        testUtils.card("Q", "Spades"),
        testUtils.card("J", "Hearts"),
        testUtils.card("10", "Clubs"),
        testUtils.card("9", "Diamonds")
    }

    local counts = helpers.countRanks(cards)
    local result = onePair.splitOnePair(cards, "A", counts)

    -- High hand should have the pair + 3 lowest remaining cards
    testUtils.assertEqual(#result.high, 5)
    testUtils.assertEqual(#result.low, 2)

    -- Check that both Aces are in high hand
    local aceCount = 0
    for _, card in ipairs(result.high) do
        if card.rank == "A" then
            aceCount = aceCount + 1
        end
    end
    testUtils.assertEqual(aceCount, 2, "Both Aces should be in high hand")
end

local function testOnePairWithJoker()
    local cards = {
        testUtils.card("A", "Hearts"),
        testUtils.card("Joker"),
        testUtils.card("K", "Diamonds"),
        testUtils.card("Q", "Spades"),
        testUtils.card("J", "Hearts"),
        testUtils.card("10", "Clubs"),
        testUtils.card("9", "Diamonds")
    }

    local counts = helpers.countRanks(cards)
    local result = onePair.splitOnePair(cards, "A", counts)

    -- High hand should have A + Joker + 3 lowest remaining
    testUtils.assertEqual(#result.high, 5)
    testUtils.assertEqual(#result.low, 2)

    -- Check that A and Joker are in high hand
    local hasAce = false
    local hasJoker = false
    for _, card in ipairs(result.high) do
        if card.rank == "A" then hasAce = true end
        if card.rank == "Joker" then hasJoker = true end
    end
    testUtils.assert(hasAce and hasJoker, "Both A and Joker should be in high hand")
end

local function runOnePairTests()
    testUtils.runTest("BasicOnePair", testBasicOnePair)
    testUtils.runTest("OnePairWithJoker", testOnePairWithJoker)
end

return {
    runOnePairTests = runOnePairTests
}
