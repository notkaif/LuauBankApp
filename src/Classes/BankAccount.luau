--!native
--!strict

local Signal = require("../Packages/Signal")
local Card = require("./BankDebitCard")

type Signal = Signal.Signal
type BankDebitCard = Card.BankDebitCard

export type BankAccount = {
	Owner: {
		FirstName: string,
		LastName: string,
	},
	Details: {
		Number: number,
		SortCode: number,
	},
	Balance: number,
	Transactions: { { Date: number, Name: string, Amount: number } },

	Card: BankDebitCard,

	Deposit: (self: BankAccount, Amount: number, Name: string) -> boolean,
	Withdraw: (self: BankAccount, Amount: number, Name: string) -> boolean,

	BalanceChanged: Signal,
}

local Account = {}
Account.__index = Account

function Account.new(Name: { FirstName: string, LastName: string }): BankAccount
	local self = setmetatable({
		Owner = Name,
		Details = {
			Number = math.random(10000000, 99999999),
			SortCode = math.random(100000, 999999),
		},
		Balance = 0,
		Transactions = {},

		Card = Card.new(),

		BalanceChanged = Signal.new(),
	}, Account)

	self.Card.Charged:Connect(function(Amount: number, Name: string)
		self:Withdraw(Amount, Name)
	end)

	self.Card.Refunded:Connect(function(Amount: number, Name: string)
		self:Deposit(Amount, Name)
	end)

	return self
end

function Account.Deposit(self: BankAccount, Amount: number, Name: string): boolean
	assert(Amount > 0, "You cannot deposit negative amounts")
	self.Balance += Amount
	table.insert(self.Transactions, { Date = os.time(), Name = Name, Amount = Amount })
	self.BalanceChanged:Fire()
	return true
end

function Account.Withdraw(self: BankAccount, Amount: number, Name: string): boolean
	assert(Amount > 0, "You cannot withdraw negative amounts")
	self.Balance -= Amount
	table.insert(self.Transactions, { Date = os.time(), Name = Name, Amount = -Amount })
	self.BalanceChanged:Fire()
	return true
end

return Account
