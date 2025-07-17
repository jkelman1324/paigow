-- test_utils.lua
local M = {}

-- Helper to create cards easily
function M.card(rank, suit)
    return { rank = rank, suit = suit or "Hearts" }
end

-- Simple assertion framework
function M.assert(condition, message)
    if not condition then
        error("Test failed: " .. (message or "assertion failed"))
    end
end

function M.assertEqual(actual, expected, message)
    if actual ~= expected then
        error("Test failed: " .. (message or "") .. 
              "\nExpected: " .. tostring(expected) .. 
              "\nActual: " .. tostring(actual))
    end
end

-- Helper to check if hand contains specific cards
function M.containsCards(hand, expectedCards)
    if #hand ~= #expectedCards then
        return false
    end

    for _, expectedCard in ipairs(expectedCards) do
        local found = false
        for _, handCard in ipairs(hand) do
            if handCard.rank == expectedCard.rank and handCard.suit == expectedCard.suit then
                found = true
                break
            end
        end
        if not found then
            return false
        end
    end
    return true
end

-- Print test results
function M.runTest(testName, testFunction)
    local success, error = pcall(testFunction)
    if success then
        print("✓ " .. testName)
    else
        print("✗ " .. testName .. ": " .. error)
    end
end

return M
