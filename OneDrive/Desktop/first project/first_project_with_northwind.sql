--> Let's sort all the data in the product table alphabetically by product name and get the sorted version with all columns.

SELECT * FROM productsc
ORDER BY "ProductName" ASC;

--> Let's list the products in descending order according to their unit prices and get the name and price information of the first 3 most expensive products.

SELECT "ProductName", "UnitPrice" FROM products
ORDER BY "UnitPrice" DESC
LIMIT 3;

--> Orders with a freight cost between 40 and 80 (including 40 and 80) to the order date first (descending),
--then sort by delivery country (ascending) and get the order date, delivery country and service cost values in this order.

SELECT "OrderDate", "ShipCountry", "Freight"  FROM orders
WHERE "Freight" >= 40 AND "Freight" <= 80
ORDER BY "OrderDate" DESC, "ShipCountry" ASC;

--> Let's get the name and category information of the 4 categories that come after the first 3 products from the categories in the category table.

SELECT "CategoryName" , "CategoryID" FROM categories
LIMIT 4 OFFSET 3;

--> Let's get the total number of customers registered in the system.

SELECT COUNT(*) AS total_customer_number FROM customers

--> Let's calculate the average unit price of all products registered in the system.

SELECT AVG("UnitPrice") AS avg_unit_price FROM products;

--> Calculate the total number of products in each category, 
-- let's get the ids of the first 3 categories with the most products and the total number of products.

SELECT "CategoryID", COUNT("ProductID") AS total_product_number FROM products
GROUP BY "CategoryID"
ORDER BY total_product_number DESC
LIMIT 3;

--> In the order table, let's calculate the total number of orders created by EACH customer
--> and let's get the ids of the customers whose total number of orders is greater than 10 and the total number of orders of these customers.

SELECT "CustomerID", COUNT("OrderID") FROM orders
GROUP BY "CustomerID"
HAVING COUNT("OrderID") > 10;

-->) Products in categories with category id between 1 and 5 (including 1 and 5)
--let's calculate the average unit prices for each category.

SELECT "CategoryID", AVG("UnitPrice") AS avg_unit_price FROM products
WHERE "CategoryID" >=1 AND "CategoryID" <=5
GROUP BY "CategoryID";

--> Get the categories with a calculated category-based average value greater than 2 and their averages.

SELECT "CategoryID", AVG("UnitPrice") AS ort_birim_fiyat FROM products
WHERE "CategoryID" >=1 AND "CategoryID" <=5
GROUP BY "CategoryID"
HAVING AVG("UnitPrice") > 2;

--> Let's get the names of all categories and product names registered in the system in a single column using UNION.

SELECT "CategoryName" FROM categories
UNION
SELECT "ProductName" FROM products

--> Let's get the id of the created orders and the information (ContactName) by which customer they were created.

SELECT o."OrderID", c."ContactName"
FROM orders o
JOIN customers c ON o."CustomerID" = c."CustomerID"

--> Let's calculate how many total orders each customer has created.
--> Let's get the customer's “contactname” information and the total number of orders created.

SELECT c."ContactName", COUNT(o."OrderID") AS order_number
FROM orders o
JOIN customers c ON o."CustomerID" = c."CustomerID"
GROUP BY c."ContactName" 

--> Names of all products registered in the system, 
--let's get the names of the category they belong to and supplier information (contactname, companyname).

SELECT p."ProductName", c."CategoryName", s."ContactName", s."CompanyName"
FROM products p
JOIN categories c ON p."CategoryID" = c."CategoryID"
JOIN suppliers s ON s."SupplierID" = p."SupplierID"

--> Let's get the contact information of all customers who created an order and not created an order.

SELECT c."ContactName", c."ContactTitle"
FROM customers c
LEFT JOIN orders o ON c."CustomerID" = o."CustomerID"

--> List the first and last name of all customers registered in the system, along with the names of the products they ordered.

SELECT c."ContactName" , p."ProductName"
FROM customers c
JOIN orders o ON o."CustomerID" = c."CustomerID"
JOIN order_details od ON o."OrderID" = od."OrderID"
JOIN products p ON p."ProductID" = od."ProductID"

--> Let's calculate how many products were ordered from each category.
--Let's get the names of the first 3 categories with the highest number of orders and the total number of orders.

SELECT c."CategoryName", COUNT(od."Quantity")
FROM order_details od
JOIN products p ON od."ProductID" = p."ProductID"
JOIN categories c ON p."CategoryID" = c."CategoryID"
GROUP BY c."CategoryName"
ORDER BY COUNT(od."Quantity") DESC
LIMIT 3

--> Let's calculate the average stock quantity of products in each category.
--> And create Low (<20), Medium (btw 20 and 50), or High (others) stock categories based on this stock quantity. 
--> Get the category name, average stock quantity and stock category.
--> Let's display the average stock quantity with 2 digits after the comma.

SELECT  c."CategoryName", ROUND(AVG(p."UnitsInStock"),2) AS avg_stock_quantity,
      CASE
	      WHEN AVG(p."UnitsInStock") < 20 THEN 'Low'
		  WHEN AVG(p."UnitsInStock") BETWEEN 20 AND 50 THEN 'Medium'
		  ELSE 'High'
		  END AS stock_category
FROM categories c
JOIN products p ON c."CategoryID" = p."CategoryID"
GROUP BY  c."CategoryName"

--> Let's determine the experience level of the employees according to their HireDate.
--> Let's classify employees with more than 10 years as “Senior”, employees with 5-10 years as “Intermediate”, employees with less than 5 years as “New”.
--> Let's show the results with employee name and experience level.

SELECT "FirstName", EXTRACT(YEAR FROM AGE(NOW(), "HireDate")) AS experience_year,
    CASE 
        WHEN EXTRACT(YEAR FROM AGE(NOW(), "HireDate")) > 10 THEN 'Senior'
        WHEN EXTRACT(YEAR FROM AGE(NOW(), "HireDate")) BETWEEN 5 AND 10 THEN 'Intermediate'
        WHEN EXTRACT(YEAR FROM AGE(NOW(), "HireDate")) < 5 THEN 'New'
    END AS experience_level
FROM employees

--> Let's calculate the total payment amount of each customer. sum of all orders (unit price * quantity)
--> Let's categorize all orders as Low for those who pay less than 1000, Medium for those who pay between 1000 and 5000, and High for others.
--> Let's get the id of the customer, the name of the company, the total payment amount and the payment category created.
--> Let's sort the results in descending order by total payment amount.

SELECT c."CustomerID", c."CompanyName", SUM("UnitPrice" * "Quantity" ) AS total_payment_category,
      CASE 
	      WHEN SUM("UnitPrice" * "Quantity" ) < 1000 THEN 'Low'
	      WHEN SUM("UnitPrice" * "Quantity" ) BETWEEN 1000 AND 5000 THEN 'Medium'
		  ELSE 'High'
		  END AS payment_category
FROM customers c
JOIN orders o ON o."CustomerID" = c."CustomerID"
JOIN order_details od ON o."OrderID" = od."OrderID"
GROUP BY c."CustomerID", c."CompanyName"
ORDER BY SUM("UnitPrice" * "Quantity" ) DESC

--> Calculate the total value of the products provided by each supplier (unit price * quantity in stock).
--> Based on this value let's create Low (<5000), Medium (btw 5000 and 20000) or High (others) supplier categories.
--> Let's show supplier name, total product value and supplier category.
--> Let's sort in descending order by total value amount.

SELECT s."CompanyName" , SUM(p."UnitPrice" * p."UnitsInStock") AS total_product_value ,
      CASE 
	      WHEN SUM(p."UnitPrice" * p."UnitsInStock") < 5000 THEN 'Low'
		  WHEN SUM(p."UnitPrice" * p."UnitsInStock") BETWEEN 5000 AND 20000 THEN 'Medium'
		  ELSE 'High'
	  END AS supplier_category
FROM suppliers s 
JOIN products p ON p."SupplierID" = S."SupplierID"
GROUP BY s."CompanyName"
ORDER BY SUM(p."UnitPrice" * p."UnitsInStock") DESC 

--> According to the number of orders placed by customers 
--> Create categories “New Customer (order count 0)”, “Loyal Customer (btw 1 5)” and “VIP Customer (greater than 5)”.
--> Show customer ID, company name, number of orders and loyalty category.
--> Let's sort the results in descending order by the number of orders.

SELECT c."CustomerID", c."CompanyName", COUNT(o."OrderID") AS order_number,
      CASE 
	      WHEN COUNT(o."OrderID") = 0 THEN 'New customer'
		  WHEN COUNT(o."OrderID") BETWEEN 1 AND 5 THEN 'Loyal customer'
		  WHEN COUNT(o."OrderID") > 5 THEN 'VIP customer'
		  END AS loyalty_category
FROM orders o
JOIN customers c ON c."CustomerID" = o."CustomerID"
GROUP BY c."CustomerID", c."CompanyName"
ORDER BY COUNT(o."OrderID") DESC