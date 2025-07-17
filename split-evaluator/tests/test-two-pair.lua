-- test-two-pair.lua
local twoPair = require("two-pair")
local helpers = require("helpers")
local testUtils = require("test-utils")

local function testTwoPairSplit()
    local cards = {
        testUtils.card("A", "Hearts"),
        testUtils.card("A", "Clubs"),
        testUtils.card("K", "Diamonds"),
        testUtils.card("K", "Spades"),
        testUtils.card("Q", "Hearts"),
        testUtils.card("J", "Clubs"),
        testUtils.card("10", "Diamonds")
    }

    local counts = helpers.countRanks(cards)
    local pairsFound = {"A", "K"}
    local result = twoPair.splitTwoPair(cards, pairsFound, counts)

    testUtils.assertEqual(#result.high, 5)
    testUtils.assertEqual(#result.low, 2)

    -- Should split pairs (A-A in high, K-K in low for this scenario)
    -- Exact logic depends on strategy, but both hands should be valid
end

local function testTwoPairWithJoker()
    local cards = {
        testUtils.card("A", "Hearts"),
        testUtils.card("Joker"),
        testUtils.card("K", "Diamonds"),
        testUtils.card("K", "Spades"),
        testUtils.card("Q", "Hearts"),
        testUtils.card("J", "Clubs"),
        testUtils.card("10", "Diamonds")
    }

    local counts = helpers.countRanks(cards)
    local pairsFound = {"A", "K"}
    local result = twoPair.splitTwoPair(cards, pairsFound, counts)

    testUtils.assertEqual(#result.high, 5)
    testUtils.assertEqual(#result.low, 2)

    -- A-Joker should be treated as A-A pair
end

local function testThreePairs()
    local cards = {
        testUtils.card("A", "Hearts"),
        testUtils.card("A", "Clubs"),
        testUtils.card("K", "Diamonds"),
        testUtils.card("K", "Spades"),
        testUtils.card("Q", "Hearts"),
        testUtils.card("Q", "Clubs"),
        testUtils.card("J", "Diamonds")
    }

    local counts = helpers.countRanks(cards)
    local pairsFound = {"A", "K", "Q"}
    local result = twoPair.splitTwoPair(cards, pairsFound, counts)

    testUtils.assertEqual(#result.high, 5)
    testUtils.assertEqual(#result.low, 2)

    -- Should put highest pair in low hand, other two pairs in high hand
end

local function runTwoPairTests()
    testUtils.runTest("TwoPairSplit", testTwoPairSplit)
    testUtils.runTest("TwoPairWithJoker", testTwoPairWithJoker)
    testUtils.runTest("ThreePairs", testThreePairs)
end

return {
    runTwoPairTests = runTwoPairTests
}
