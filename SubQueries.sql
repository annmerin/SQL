--Question 1 Amazon Interview
--Write a SQL to get a list of top 5 customers with most number of ordered units from Seattle 
-- during last 30 days.

SELECT TOP 5 Customer_id, Order_quantity, Order_date, Customer_City FROM
(
SELECT  TOP 10 Customer_id, Order_Quantity, Order_date, Customer_city FROM tblCustomer_Orders 
WHERE Customer_city = 'Lowa'
ORDER BY Order_Quantity DESC
) city ORDER BY Order_date DESC

SELECT  count(customer_id) counts, Customer_city FROM tblCustomer_Orders
GROUP by Customer_city

SELECT count(Customer_id) counts, Order_date FROM tblCustomer_Orders
GROUP by Order_date

UPDATE tblCustomer_Orders
SET Customer_city = 'Lowa'
WHERE Customer_city = 'Hunsville'




