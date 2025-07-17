Player = {}
Player.__index = Player

function Player:new(name)
    local p = {
        name = name,
        hand = {},
        highHand = {},
        lowHand = {},
    }
    setmetatable(p, Player)
    return p
end

function Player:receiveCards(cards)
    self.hand = cards
end

return Player

