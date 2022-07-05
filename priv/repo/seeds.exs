alias Kraken.Repo
alias Kraken.Customers
alias Kraken.Customers.Customer
alias Kraken.CustomerTransactions.CustomerTransaction
alias Kraken.CustomerTransactions.CustomerlessTransaction

Repo.delete_all(Customer)
Repo.delete_all(CustomerTransaction)
Repo.delete_all(CustomerlessTransaction)


Customers.create("Wesley Crusher", "mvd6qFeVkqH6MNAS2Y2cLifbdaX5XUkbZJ")
Customers.create("Leonard McCoy", "mmFFG4jqAtw9MoCC88hw5FNfreQWuEHADp")
Customers.create("Jonathan Archer", "mzzg8fvHXydKs8j9D2a8t7KpSXpGgAnk4n")
Customers.create("Jadzia Dax", "2N1SP7r92ZZJvYKG2oNtzPwYnzw62up7mTo")
Customers.create("Montgomery Scott", "mutrAf4usv3HKNdpLwVD4ow2oLArL6Rez8")
Customers.create("James T. Kirk", "miTHhiX3iFhVnAEecLjybxvV5g8mKYTtnM")
Customers.create("Spock", "mvcyJMiAcSXKAEsQxbW9TYZ369rsMG6rVV")
