-- test-high-card.lua

local highCard = require("high-card")
local testUtils = require("test-utils")

local function testBasicHighCard()
    local cards = {
        testUtils.card("A", "Hearts"),
        testUtils.card("K", "Clubs"),
        testUtils.card("Q", "Diamonds"),
        testUtils.card("J", "Spades"),
        testUtils.card("10", "Hearts"),
        testUtils.card("9", "Clubs"),
        testUtils.card("8", "Diamonds")
    }

    local result = highCard.splitHighCard(cards)

    -- High hand should have A and 4 lowest cards
    testUtils.assertEqual(#result.high, 5)
    testUtils.assertEqual(#result.low, 2)

    -- Check that A is in high hand
    local hasAce = false
    for _, card in ipairs(result.high) do
        if card.rank == "A" then
            hasAce = true
            break
        end
    end
    testUtils.assert(hasAce, "Ace should be in high hand")

    -- Check that K is in low hand (highest of remaining)
    local hasKing = false
    for _, card in ipairs(result.low) do
        if card.rank == "K" then
            hasKing = true
            break
        end
    end
    testUtils.assert(hasKing, "King should be in low hand")
end

local function testHighCardWithJoker()
    local cards = {
        testUtils.card("Joker"),
        testUtils.card("K", "Clubs"),
        testUtils.card("Q", "Diamonds"),
        testUtils.card("J", "Spades"),
        testUtils.card("10", "Hearts"),
        testUtils.card("9", "Clubs"),
        testUtils.card("8", "Diamonds")
    }

    local result = highCard.splitHighCard(cards)

    -- Joker should be in high hand (highest card)
    local hasJoker = false
    for _, card in ipairs(result.high) do
        if card.rank == "Joker" then
            hasJoker = true
            break
        end
    end
    testUtils.assert(hasJoker, "Joker should be in high hand")
end

local function runHighCardTests()
    testUtils.runTest("BasicHighCard", testBasicHighCard)
    testUtils.runTest("HighCardWithJoker", testHighCardWithJoker)
end

return {
    runHighCardTests = runHighCardTests
}
