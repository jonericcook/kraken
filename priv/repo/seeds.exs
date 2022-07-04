alias Kraken.Repo
alias Kraken.Customers
alias Kraken.Customers.Customer
alias Kraken.CustomerTransactions.CustomerTransaction

Repo.delete_all(Customer)
Repo.delete_all(CustomerTransaction)


Customers.create_customer(%{name: "Wesley Crusher", address: "mvd6qFeVkqH6MNAS2Y2cLifbdaX5XUkbZJ"})
Customers.create_customer(%{name: "Leonard McCoy", address: "mmFFG4jqAtw9MoCC88hw5FNfreQWuEHADp"})
Customers.create_customer(%{name: "Jonathan Archer", address: "mzzg8fvHXydKs8j9D2a8t7KpSXpGgAnk4n"})
Customers.create_customer(%{name: "Jadzia Dax", address: "2N1SP7r92ZZJvYKG2oNtzPwYnzw62up7mTo"})
Customers.create_customer(%{name: "Montgomery Scott", address: "mutrAf4usv3HKNdpLwVD4ow2oLArL6Rez8"})
Customers.create_customer(%{name: "James T. Kirk", address: "miTHhiX3iFhVnAEecLjybxvV5g8mKYTtnM"})
Customers.create_customer(%{name: "Spock", address: "mvcyJMiAcSXKAEsQxbW9TYZ369rsMG6rVV"})
