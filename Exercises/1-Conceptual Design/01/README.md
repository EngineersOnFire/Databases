# 1) A bank needs a relational database to manage information related to different aspects of its organisation and the products it offers.
[Solution](SOLVED.md)

 * The bank is organized into branches. Each branch is located in a city and it is identified by a unique code. It also has associated a name.

 * Bank customers are identified by the tax identification number. The bank stores each customer name and address. Customers can have several accounts. They also can ask for loans. Each customer has at least one account.

 * Bank employees have associated a unique identifier. The bank also stores the name and the telephone number of each employee. In addition, they need to know the employees that are subordinate to each employee, and the manager of each of them. The bank is interested in registering the start date of the employees’ labour contracts. Each customer has assigned an employee as a personal adviser.

 * The bank offers two types of accounts: savings accounts and checking accounts. Accounts can be associated with more than one client and a client can have more than one account. A unique account number is assigned to each account. The bank keeps track of the balance of each account and the last date each account holder accessed it.

 * A loan is subscribed in a particular branch and it may be associated with one or more customers. A loan is identified by a unique number. For each loan the bank registers the loan amount and loan payments (identified by consecutive numbers beginning at 1). You must take into account that, although a number of a loan payment identifies a particular payment for a specific loan, it does not uniquely identify it among all loans of the bank. For each payment the date of payment and the amount must be stored.

