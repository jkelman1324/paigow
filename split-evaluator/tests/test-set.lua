-- test-set.lua
local set = require("set")
local helpers = require("helpers")
local testUtils = require("test-utils")

local function testBasicSet()
    local cards = {
        testUtils.card("K", "Hearts"),
        testUtils.card("K", "Clubs"),
        testUtils.card("K", "Diamonds"),
        testUtils.card("A", "Spades"),
        testUtils.card("Q", "Hearts"),
        testUtils.card("J", "Clubs"),
        testUtils.card("10", "Diamonds")
    }

    local counts = helpers.countRanks(cards)
    local result = set.splitSet(cards, "K", counts)

    testUtils.assertEqual(#result.high, 5)
    testUtils.assertEqual(#result.low, 2)

    -- All three Kings should be in high hand
    local kingCount = 0
    for _, card in ipairs(result.high) do
        if card.rank == "K" then
            kingCount = kingCount + 1
        end
    end
    testUtils.assertEqual(kingCount, 3, "All three Kings should be in high hand")
end

local function testAceSet()
    local cards = {
        testUtils.card("A", "Hearts"),
        testUtils.card("A", "Clubs"),
        testUtils.card("A", "Diamonds"),
        testUtils.card("K", "Spades"),
        testUtils.card("Q", "Hearts"),
        testUtils.card("J", "Clubs"),
        testUtils.card("10", "Diamonds")
    }

    local counts = helpers.countRanks(cards)
    local result = set.splitSet(cards, "A", counts)

    testUtils.assertEqual(#result.high, 5)
    testUtils.assertEqual(#result.low, 2)

    -- Should use special Ace splitting logic
    -- High hand: A-A + 3 lowest, Low hand: A + highest remaining
end

local function testSetWithJoker()
    local cards = {
        testUtils.card("A", "Hearts"),
        testUtils.card("A", "Clubs"),
        testUtils.card("Joker"),
        testUtils.card("K", "Spades"),
        testUtils.card("Q", "Hearts"),
        testUtils.card("J", "Clubs"),
        testUtils.card("10", "Diamonds")
    }

    local counts = helpers.countRanks(cards)
    local result = set.splitSet(cards, "A", counts)

    testUtils.assertEqual(#result.high, 5)
    testUtils.assertEqual(#result.low, 2)

    -- Should treat as three Aces (A-A-Joker)
end

local function runSetTests()
    testUtils.runTest("BasicSet", testBasicSet)
    testUtils.runTest("AceSet", testAceSet)
    testUtils.runTest("SetWithJoker", testSetWithJoker)
end

return {
    runSetTests = runSetTests
}
