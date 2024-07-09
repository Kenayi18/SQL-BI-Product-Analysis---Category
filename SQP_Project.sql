Create Database SQLProject

Use [SQLProject]

CREATE TABLE Customers
(
	CustomerID INT PRIMARY KEY,
	CustomerName VARCHAR(200),
	ContactName VARCHAR(200),
	Country VARCHAR(70)
)

--Let's Insert values into Customer table

INSERT INTO Customers (CustomerID, CustomerName, ContactName, Country) VALUES
						(1, 'Acme Corp', 'John Doe', 'USA'),
						(2, 'Globex Corporation', 'Jane Smith', 'Canada'),
						(3, 'Initech', 'Bill Lumbergh', 'USA'),
						(4, 'Umbrella Corp', 'Alice Abernathy', 'UK'),
						(5, 'Hooli', 'Gavin Belson', 'USA')


--let's create a product table and populate it with values

CREATE TABLE Products
(
	ProductID INT PRIMARY KEY,
	ProductName VARCHAR (200),
	Category varchar(200),
	UnitPrice DECIMAL
)

--inserting values

INSERT INTO Products(ProductID, ProductName, Category, UnitPrice) VALUES
					(1, 'Laptop', 'Electronics', 999.99),
					(2, 'Smartphone', 'Electronics', 599.99),
					(3, 'Desk', 'Furniture', 299.99),
					(4, 'Chair', 'Furniture', 149.99),
					(5, 'Monitor', 'Electronics', 199.99),
					(6, 'Table', 'Furniture', 399.99),
					(7, 'Notebook', 'Office Supplies', 4.99);

--Next is to create an the ORDER table. For this i'm going use chatGPT to help generate values

CREATE TABLE Orders
(
	OrderID INT PRIMARY KEY,
	CustomerID INT,
	OrderDate DATE,
	FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
)

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
					(1, 1, '2024-04-01'),
					(2, 1, '2024-04-15'),
					(3, 2, '2024-05-05'),
					(4, 2, '2024-06-10'),
					(5, 3, '2024-04-20'),
					(6, 4, '2024-05-25'),
					(7, 5, '2024-06-01'),
					(8, 1, '2024-06-15'),
					(9, 2, '2024-06-20'),
					(10, 3, '2024-06-25');

--Again i'm using chatGPT to help generate columns and VALUES for this Table

CREATE TABLE OrderDetails 
(
	OrderDetailID INT PRIMARY KEY,
	OrderID INT,
	ProductID INT,
	Quantity INT,
	FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
	FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
)

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES
						(1, 1, 1, 1),
						(2, 1, 3, 2),
						(3, 2, 2, 1),
						(4, 3, 4, 4),
						(5, 4, 3, 1),
						(6, 4, 4, 2),
						(7, 5, 5, 3),
						(8, 6, 6, 1),
						(9, 7, 7, 10),
						(10, 8, 1, 1),
						(11, 9, 3, 2),
						(12, 10, 2, 1)

--Great! Having generated the dataset for the task, lets proceed to answer some business Question

--Retrieve the following; 
--Total Sales by Product Category:
--Total Quantity Sold by Product Category:
--Average Sales Per Order by Category:
--Monthly Sales by Product Category:
--Top selling products by Revenue


--I will begin by simply JOINNING all 4 tables together

SELECT 
*
FROM SQLProject.dbo.Orders O
JOIN SQLProject.dbo.Customers C
ON O.CustomerID = C.CustomerID
JOIN SQLProject.dbo.OrderDetails OD
ON OD.OrderID = O.OrderID
JOIN SQLProject.dbo.Products P
ON P.ProductID = OD.ProductID

-----Total Sales by Product Category:

SELECT 
P.Category,
SUM(OD.Quantity*P.UnitPrice) AS TOTALSALES
FROM SQLProject.dbo.Orders O
JOIN SQLProject.dbo.Customers C
ON O.CustomerID = C.CustomerID
JOIN SQLProject.dbo.OrderDetails OD
ON OD.OrderID = O.OrderID
JOIN SQLProject.dbo.Products P
ON P.ProductID = OD.ProductID
GROUP BY P.Category


-----Total Quantity Sold by Product Category:

SELECT
P.Category,
SUM(OD.Quantity) AS QTY
FROM SQLProject.dbo.Orders O
JOIN SQLProject.dbo.Customers C
ON O.CustomerID = C.CustomerID
JOIN SQLProject.dbo.OrderDetails OD
ON OD.OrderID = O.OrderID
JOIN SQLProject.dbo.Products P
ON P.ProductID = OD.ProductID
GROUP BY P.Category


-----Average Sales Per Order by Category:

SELECT
P.Category,
AVG(OD.Quantity*P.UnitPrice) AS AveragePrice
FROM SQLProject.dbo.Orders O
JOIN SQLProject.dbo.Customers C
ON O.CustomerID = C.CustomerID
JOIN SQLProject.dbo.OrderDetails OD
ON OD.OrderID = O.OrderID
JOIN SQLProject.dbo.Products P
ON P.ProductID = OD.ProductID
GROUP BY P.Category


-----Monthly Sales by Product Category

SELECT
FORMAT(O.OrderDate,'MMMM') Month,
P.Category,
SUM(OD.Quantity*P.UnitPrice) AS MonthlySales
FROM SQLProject.dbo.Orders O
JOIN SQLProject.dbo.Customers C
ON O.CustomerID = C.CustomerID
JOIN SQLProject.dbo.OrderDetails OD
ON OD.OrderID = O.OrderID
JOIN SQLProject.dbo.Products P
ON P.ProductID = OD.ProductID
Group by Category, FORMAT(O.OrderDate,'MMMM')
ORDER BY  P.Category, Month


-----Top selling products by Revenue

SELECT 
P.Category,
P.ProductName,
SUM(OD.Quantity*P.UnitPrice) as TotalSales
FROM SQLProject.dbo.Orders O
JOIN SQLProject.dbo.Customers C
ON O.CustomerID = C.CustomerID
JOIN SQLProject.dbo.OrderDetails OD
ON OD.OrderID = O.OrderID
JOIN SQLProject.dbo.Products P
ON P.ProductID = OD.ProductID
GROUP BY P.Category, P.ProductName
ORDER BY TotalSales DESC

