--!native
--!strict

local AccountConstructor = require("../Classes/BankAccount")
local Options = require("../Modules/AccountOptions")
local stdio = require("@lune/stdio")

type BankApp = {
	__index: {},
	Init: (self: BankApp, Restart: boolean?, Account: BankAccount?) -> (),
	Accounts: { [string]: BankAccount },
	GetAccount: (Name: { FirstName: string, LastName: string }) -> BankAccount,
}

type BankAccount = AccountConstructor.BankAccount

local App = {} :: BankApp
App.__index = App
App.Accounts = {}

function App.Init(self: BankApp, Restart: boolean?, PrevAccount: BankAccount?)
	if PrevAccount then
		local Option = stdio.prompt("select", "What would you like to do?", {
			"View Balance",
			"Deposit Money",
			"Withdraw Money",
			"View Transactions",
			"Use Debit Card",
			"Exit",
		})

		Options.Option(Option, PrevAccount)

		if Option == 6 then
			self:Init(true)
		else
			self:Init(false, PrevAccount)
		end

		return
	elseif not Restart then
		print("Welcome to the Bank App!")
	end
	local Name = stdio.prompt("text", "Please enter your first and last name: ")

	local SplitName = string.split(Name, " ")
	if #SplitName < 2 then
		print("Invalid name format.")
		self:Init(true)
	else
		local Account = self.GetAccount({ FirstName = SplitName[1], LastName = SplitName[2] })
		print("Welcome, " .. Account.Owner.FirstName .. " " .. Account.Owner.LastName .. "!")
		self:Init(false, Account)
	end
end

function App.GetAccount(Name)
	local Account = App.Accounts[Name.FirstName .. "_" .. Name.LastName]

	if Account then
		return Account
	else
		local NewAccount = AccountConstructor.new(Name)
		App.Accounts[Name.FirstName .. "_" .. Name.LastName] = NewAccount
		return NewAccount
	end
end

return App
