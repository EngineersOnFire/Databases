# 9) We need to design a database for supermarket that meets the following requirements:
[Solution @RamzaFFT](SOLVED_RamzaFFT.md)

[Solution @DevPGSV](SOLVED_DevPGSV.md)

The customers can place orders online if they have previously registered in the system. During the registration process they must indicate their name, e-mail, password, address (street, number, flat and postal code) and the credit card number they will use to pay the orders. Optionally, they can provide a phone number and a loyalty card (if they have one). Those customers who have a loyalty card will get discount vouchers.

The supermarket offers different products, which are identified by a bar code and have associated a description and a price. These products can be either fresh food (sold by weight) or packaged foods (sold by units). 

A customer can place an order in several sessions, during which may include and remove products in his "shopping cart". For each product they have to indicate the number of units (packaged foods) or weight (fresh foods) they want to buy. When the customer completes the order process, the products in the shopping cart will generate a new order and the cart is emptied, allowing the customer to place a new order. The order, which will have a unique ID, includes all the products in the shopping cart, the delivery date and the total amount of the order. Customers who have discount vouchers can apply them to their orders. Each discount voucher is identified by a number and presents the expiration date and the amount to be deducted from the total amount of the order. The number associated to discount vouchers not uniquely identifies it among all the discount vouchers, only among the customer discount vouchers 

Finally, orders are assigned to delivery men. The delivery men are identified by an employee number and has assigned different postal codes.
