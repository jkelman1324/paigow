-- test-runner.lua

package.path = package.path .. ";../?.lua"

local helperTests = require("test-helpers")
local highCardTests = require("test-high-card")
local onePairTests = require("test-one-pair")
local twoPairTests = require("test-two-pair")
local setTests = require("test-set")

local function runAllTests()
    print("Running Pai Gow Poker Split Evaluator Tests")
    print("=" .. string.rep("=", 45))

    -- Load and run each test file
    print("\nHelper Tests:")
    helperTests.runHelperTests()

    print("\nHigh Card Tests:")
    highCardTests.runHighCardTests()

    print("\nOne Pair Tests:")
    onePairTests.runOnePairTests()

    print("\nTwo Pair Tests:")
    twoPairTests.runTwoPairTests()

    print("\nSet Tests:")
    setTests.runSetTests()

    print("\nAll tests completed!")
end

-- Run tests
runAllTests()
