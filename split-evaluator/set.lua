-- set.lua
local helpers = require("helpers")

local M = {}

local function containsCard(list, card)
    for _, c in ipairs(list) do
        if c == card then return true end
    end
    return false
end

function M.splitSet(cards, setRank, counts)
    local function playHighThreeOfKind()
        local highHand = helpers.findCardsByRank(cards, setRank, 3)
        local nonSetCards = {}
        for _, card in ipairs(cards) do
            if helpers.getEffectiveRank(card) ~= setRank then
                table.insert(nonSetCards, card)
            end
        end
        helpers.sortByRankDesc(nonSetCards)
        local lowHand = { nonSetCards[1], nonSetCards[2] }
        table.insert(highHand, nonSetCards[3])
        table.insert(highHand, nonSetCards[4])
        return { high = highHand, low = lowHand }
    end

    -- Handle Aces (including Joker as Ace)
    if setRank == "A" then
        -- High hand: pair of Aces + three lowest non-Ace cards
        local highHand = helpers.findCardsByRank(cards, "A", 2)

        local nonAceCards = {}
        for _, card in ipairs(cards) do
            if helpers.getEffectiveRank(card) ~= "A" then
                table.insert(nonAceCards, card)
            end
        end

        -- Sort ascending to get lowest cards first
        table.sort(nonAceCards, function(a, b)
            return helpers.rankValue(a) < helpers.rankValue(b)
        end)

        -- Add three lowest non-Ace cards to high hand
        for i = 1, 3 do
            table.insert(highHand, nonAceCards[i])
        end

        -- Low hand: remaining Ace + highest remaining card
        local lowHand = {}

        -- Find the third Ace/Joker that wasn't used in the pair
        for _, card in ipairs(cards) do
            if helpers.getEffectiveRank(card) == "A" and not containsCard(highHand, card) then
                table.insert(lowHand, card)
                break
            end
        end

        table.insert(lowHand, nonAceCards[4])  -- highest of the 4 non-Ace cards

        return { high = highHand, low = lowHand }
    else
        return playHighThreeOfKind()
    end
end

return M
