-- two-pair.lua
local helpers = require("helpers")

local M = {}

function M.splitTwoPair(cards, pairsFound, counts)
    if #pairsFound == 3 then
        -- Three pairs: keep highest pair in low hand, rest in high hand
        table.sort(pairsFound, function(a, b)
            return helpers.rankOrder[a] > helpers.rankOrder[b]
        end)
        local highPair = pairsFound[1]
        local highHand = {}
        local lowHand = helpers.findCardsByRank(cards, highPair, 2)

        for _, card in ipairs(cards) do
            if helpers.getEffectiveRank(card) ~= highPair then
                table.insert(highHand, card)
            end
        end

        return { high = highHand, low = lowHand }
    end

    local p1, p2 = pairsFound[1], pairsFound[2]
    local cat1, cat2 = helpers.pairCategory(p1), helpers.pairCategory(p2)

    -- Check for high cards (now properly handles Joker as Ace)
    local hasAce = (counts["A"] or 0) > 0
    local hasKing = (counts["K"] or 0) > 0

    local function playBothPairsInHigh()
        local highHand = {}
        for _, rank in ipairs(pairsFound) do
            local pairCards = helpers.findCardsByRank(cards, rank, 2)
            for _, c in ipairs(pairCards) do
                table.insert(highHand, c)
            end
        end
        local nonPairs = helpers.getNonPairCards(cards, counts)
        helpers.sortByRankDesc(nonPairs)
        local lowHand = { nonPairs[1], nonPairs[2] }
        return { high = highHand, low = lowHand }
    end

    local function splitPairs()
        local highHand = helpers.findCardsByRank(cards, p1, 2)
        local lowHand = helpers.findCardsByRank(cards, p2, 2)
        for _, card in ipairs(cards) do
            local effectiveRank = helpers.getEffectiveRank(card)
            if effectiveRank ~= p1 and effectiveRank ~= p2 then
                table.insert(highHand, card)
            end
        end
        return { high = highHand, low = lowHand }
    end

    -- Create canonical key for strategy lookup
    local cats = { cat1, cat2 }
    local catPriority = { Low = 1, Medium = 2, High = 3 }
    table.sort(cats, function(a, b)
        return catPriority[a] < catPriority[b]
    end)
    local key = cats[1] .. "-" .. cats[2]

    -- Strategy table based on pair categories and high cards
    local strategies = {
        ["Low-Low"] = function() return "bothHigh" end,
        ["Medium-Medium"] = function() return hasAce and "bothHigh" or "split" end,
        ["High-High"] = function() return "split" end,
        ["Low-Medium"] = function() return hasKing and "bothHigh" or "split" end,
        ["Low-High"] = function() return hasAce and "bothHigh" or "split" end,
        ["Medium-High"] = function() return (hasAce and hasKing) and "bothHigh" or "split" end,
    }

    local strategy = strategies[key]()

    if strategy == "bothHigh" then
        return playBothPairsInHigh()
    else
        return splitPairs()
    end
end

return M
