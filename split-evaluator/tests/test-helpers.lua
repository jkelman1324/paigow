-- test-helpers.lua
local helpers = require("helpers")
local testUtils = require("test-utils")

local function testRankValue()
    testUtils.assertEqual(helpers.rankValue(testUtils.card("2")), 2)
    testUtils.assertEqual(helpers.rankValue(testUtils.card("A")), 14)
    testUtils.assertEqual(helpers.rankValue(testUtils.card("Joker")), 15)
end

local function testGetEffectiveRank()
    testUtils.assertEqual(helpers.getEffectiveRank(testUtils.card("A")), "A")
    testUtils.assertEqual(helpers.getEffectiveRank(testUtils.card("Joker")), "A")
    testUtils.assertEqual(helpers.getEffectiveRank(testUtils.card("K")), "K")
end

local function testCountRanks()
    local cards = {
        testUtils.card("A", "Hearts"),
        testUtils.card("Joker"),
        testUtils.card("K", "Clubs"),
        testUtils.card("A", "Spades")
    }

    local counts = helpers.countRanks(cards)
    testUtils.assertEqual(counts["A"], 3) -- A + Joker + A
    testUtils.assertEqual(counts["K"], 1)
end

local function testFindCardsByRank()
    local cards = {
        testUtils.card("A", "Hearts"),
        testUtils.card("Joker"),
        testUtils.card("K", "Clubs"),
        testUtils.card("A", "Spades")
    }

    local aces = helpers.findCardsByRank(cards, "A", 2)
    testUtils.assertEqual(#aces, 2)
    -- Should find A and Joker (as effective A)
end

local function runHelperTests()
    testUtils.runTest("RankValue", testRankValue)
    testUtils.runTest("GetEffectiveRank", testGetEffectiveRank)
    testUtils.runTest("CountRanks", testCountRanks)
    testUtils.runTest("FindCardsByRank", testFindCardsByRank)
end

return {
    runHelperTests = runHelperTests
}
