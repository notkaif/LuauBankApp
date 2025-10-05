--!native
--!strict

local Signal = require("../Packages/Signal")

local Card = {}
Card.__index = Card

type Signal = Signal.Signal

type Card = {
    Number: number,
    Expiry: number,
    CVV: number,

    Charged: Signal,
    Refunded: Signal,

    Charge: (self: Card, Amount: number, Name: string) -> boolean,
    Refund: (self: Card, Amount: number, Name: string) -> boolean,
}

export type BankDebitCard = typeof(setmetatable({} :: Card, Card))

function Card.new()
    local self = setmetatable({
        Number = math.random(10000000000000, 99999999999999),
        Expiry = os.time() + 60 * 60 * 24 * 365 * 3,
        CVV = math.random(100, 999),

        Charged = Signal.new(),
        Refunded = Signal.new(),
    }, Card)

    return self :: BankDebitCard
end

function Card.Charge(self: Card, Amount: number, Name: string)
    assert(Amount > 0, "You cannot charge negative amounts")
    self.Charged:Fire(Amount, Name)
    return true
end

function Card.Refund(self: Card, Amount: number, Name: string)
    assert(Amount > 0, "You cannot refund negative amounts")
    self.Refunded:Fire(Amount, Name)
    return true
end

return Card