--!native
--!strict

local BankAccount = require("../Classes/BankAccount")
type BankAccount = BankAccount.BankAccount

local stdio = require("@lune/stdio")

return {
	Option = function(option: number, Account: BankAccount)
		if option == 1 then
			print("Your balance is: $" .. string.format("%.2f", Account.Balance))
		elseif option == 2 then
			local Amount = stdio.prompt("text", "Enter amount to deposit: ")
			Amount = tonumber(Amount)
			if typeof(Amount) == "number" then
				Account:Deposit(Amount, "Cash Deposit")
				print(
					"Deposited $"
						.. string.format("%.2f", Amount)
						.. ". New balance: $"
						.. string.format("%.2f", Account.Balance)
				)
			end
		elseif option == 3 then
			local Amount = stdio.prompt("text", "Enter amount to withdraw: ")
			Amount = tonumber(Amount)
			if typeof(Amount) == "number" then
				if Account:Withdraw(Amount, "Cash Withdrawal") then
					print(
						"Withdrew $"
							.. string.format("%.2f", Amount)
							.. ". New balance: $"
							.. string.format("%.2f", Account.Balance)
					)
					print("Your money will be sent to your address in 1-6 hours.")
				else
					print("Insufficient funds.")
				end
			end
		elseif option == 4 then
			if #Account.Transactions == 0 then
				print("No transactions found.")
				return
			end
			print("Transactions:")
			for _, Transaction in Account.Transactions do
				local Sign = if Transaction.Amount >= 0 then "+" else "-"
				print(
					os.date("%Y-%m-%d %H:%M:%S", Transaction.Date)
						.. " | "
						.. Transaction.Name
						.. " | "
						.. Sign
						.. "$"
						.. string.format("%.2f", math.abs(Transaction.Amount))
				)
			end
		elseif option == 5 then
			if Account.Card then
				print("Your debit card details:")
				print("Card Number: " .. Account.Card.Number)
				print("Expiry Date: " .. os.date("%m-%Y", Account.Card.Expiry))
				print("CVV: " .. Account.Card.CVV)
			end
		end
	end,
}
