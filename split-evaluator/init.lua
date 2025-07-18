-- init.lua
local helpers = require("helpers")
local onePair = require("one-pair")
local twoPair = require("two-pair")
local set = require("set")
local highCard = require("high-card")

local M = {}

function M.houseWaySplit(cards)
    if #cards ~= 7 then
        error("Pai Gow poker requires exactly 7 cards")
    end

    helpers.sortByRankDesc(cards)
    local counts = helpers.countRanks(cards)

    -- Check for straights
    

    -- Check for sets
    for rank, count in pairs(counts) do
        if count == 3 then
            return set.splitSet(cards, rank, counts)
        end
    end

    -- Find pairs
    local pairsFound = {}
    for rank, count in pairs(counts) do
        if count == 2 then
            table.insert(pairsFound, rank)
        end
    end

    -- Sort pairs by rank value (highest first)
    table.sort(pairsFound, function(a, b)
        return helpers.rankOrder[a] > helpers.rankOrder[b]
    end)

    if #pairsFound >= 2 then
        return twoPair.splitTwoPair(cards, pairsFound, counts)
    elseif #pairsFound == 1 then
        return onePair.splitOnePair(cards, pairsFound[1], counts)
    end

    return highCard.splitHighCard(cards)
end

return M
