--MODULE 1 EXAMPLES
--------------------

-- product names, with list prices, and standard cost
select Name, ListPrice, StandardCost 
from SalesLT.Product

-- add markup - calculated column
select Name, ListPrice, StandardCost,
       ListPrice - StandardCost as Markup -- alias
from SalesLT.Product

-- combine (concatenate) two columns
select ProductNumber, Color, Size
from SalesLT.Product

select ProductNumber, Color, Size, 
       Color + isnull(', ' + Size, '') as ProductDetails
from SalesLT.Product

-- NULL - no value
-- ISNULL(expression, replacement_value_for_null)

-- + means different thing for strings and different for numbers
select  345+12

-- need for temporarily change the type (cast) of ProductID to nvarchar
select cast(ProductID as varchar(5)) + ': ' + Name as [Product Info]
from SalesLT.Product

select cast(ProductID as nvarchar(5)) + ': ' + Name as "Product Info"
from SalesLT.Product

-- use convert to change data type
select convert(varchar(5), ProductID) + ': ' + Name as [Product Info]
from SalesLT.Product

-- advantage of convert - additional parameter for formatting
select ProductNumber, SellStartDate -- "zero time"
from SalesLT.Product

select ProductNumber, SellStartDate,
       convert(nvarchar(20), SellStartDate) as DefaultFormat,
	   convert(nvarchar(20), SellStartDate, 107) as SpecialFormat
from SalesLT.Product

select getdate() -- current date and time
select convert(date, getdate()) -- current date
select convert(time, getdate(), 20) -- current time (with miliseconds)

select format(getdate(), 'hh:mm:ss')
select format(getdate(), 'MMMM dd, yyyy')
select format(getdate(), 'dd-MMM-yyyy')

-- CAST cause error if cannot convert
select Name, cast(Size as int) as NumericSize -- error
from SalesLT.Product
-- solution TRY_CAST
select Name, try_cast(Size as int) as NumericSize 
from SalesLT.Product
-- can further replace null with empty string
select Name, isnull(try_cast(Size as int), ' ') as NumericSize 
from SalesLT.Product

-- let's play with NULL
-- if color is Multi, replace it with null
-- NULLIF(expression, value)
select Name, nullif(Color, 'Multi') as Color
from SalesLT.Product

-- COALESCE compares multiple columns and finds the first one 
-- that is not null

select Name, SellStartDate, SellEndDate,
       coalesce(SellEndDate, SellStartDate) as LastUpdated
from salesLT.Product

-- searched CASE expression
select Name, SellStartDate, SellEndDate,
       case
	     when SellEndDate is null then 'Available'
		 else 'Discontinued'
	   end as SaleStatus
from salesLT.Product

-- simple case expression

select Name, Size,
       case Size
	     when 'S' then 'Small'
		 when 'M' then 'Medium'
		 when 'L' then 'Large'
		 when 'XL' then 'Extra Large'
		 else isnull(Size, 'N/A')
	   end as SpelledOutSize
from SalesLT.Product

-------------------------
-- Module 2
---------------------------

-- 10 most expensive products
select ProductID, ProductNumber, Name, ListPrice
from SalesLT.Product
order by ListPrice -- ascending order from smalles to largest

select ProductID, ProductNumber, Name, ListPrice
from SalesLT.Product
order by ListPrice desc -- from largest to smallest

select top 10 ProductID, ProductNumber, Name, ListPrice
from SalesLT.Product
order by ListPrice desc

-- get 20 heaviest products
select top 20 ProductID, ProductNumber, Name, Weight
from SalesLT.Product
order by Weight desc

-- with ties
select top 7 with ties ProductID, ProductNumber, Name, ListPrice
from SalesLT.Product
order by ListPrice desc

-- get 10% of most expensive products
select top 10 percent ProductID, ProductNumber, Name, ListPrice
from SalesLT.Product
order by ListPrice desc

-- get pages of data
-- OFFSET and FETCH
select ProductID, ProductNumber, Name, ListPrice
from SalesLT.Product
order by ListPrice desc
-- retrieve records, 10 at a time, alphabetically ordered by name
-- first page
select ProductID, ProductNumber, Name, ListPrice
from SalesLT.Product
order by Name offset 0 rows fetch next 10 rows only

-- second page
select ProductID, ProductNumber, Name, ListPrice
from SalesLT.Product
order by Name offset 10 rows fetch next 10 rows only

-- third page
select ProductID, ProductNumber, Name, ListPrice
from SalesLT.Product
order by Name offset 20 rows fetch next 10 rows only

-- ALL and DISTINCT
-- what colours are the products?
select Color
from SalesLT.Product

select all Color -- same because ALL is the default
from SalesLT.Product

select distinct Color -- displays distinct values
from SalesLT.Product  -- side effect orders in ascending order

-- what different weights are the products coming in?
select distinct Weight
from SalesLT.Product

-- filter results with WHERE condition
-- get names, colour, and size of products from ProductModelID 6
select Name, Color, Size, ProductModelID
from SalesLT.Product
where ProductModelID = 6

-- get names, colour, and size of products from ProductModelID other than 6
select Name, Color, Size, ProductModelID
from SalesLT.Product
where ProductModelID <> 6
order by ProductModelID, Name
-- or - only in T-SQL 
select Name, Color, Size, ProductModelID
from SalesLT.Product
where ProductModelID != 6
order by ProductModelID, Name

-- names and list prices of products with price more than 1000
select Name, ListPrice
from SalesLT.Product
where ListPrice > 1000

-- search with partial information
-- names and list prices of products whose name satrst with 'Road'
select Name, ListPrice
from SalesLT.Product
where Name = 'Road' -- no results
-- "wildcard" characters
-- % stands for arbitrary string and _ stands for a single arbitrary character
select Name, ListPrice
from SalesLT.Product
where Name like 'Road%' 

-- products that end with letter e
select Name, ListPrice
from SalesLT.Product
where Name like '%e'

-- products that have word 'tour' in the name
select Name, ListPrice
from SalesLT.Product
where Name like '%tour%'
-- products that have word 'large' in the name
select Name, ListPrice
from SalesLT.Product
where Name like '%large%'

-- Product Number starts with HL-, then arbitrary letter, 
-- followed by three digits, 
-- and maybe additional string
select ProductNumber, Name
from SalesLT.Product
where ProductNumber like 'HL-[a-zA-Z][0-9][0-9][0-9]%'

-- searching for NULL values
-- products that  do not have SellEndDate
select Name, SellStartDate, SellEndDate
from SalesLT.Product
where SellEndDate = null -- no results

select Name, SellStartDate, SellEndDate
from SalesLT.Product
where SellEndDate is null

-- discontinued products
--(SellEndDate is provided)
select Name, SellStartDate, SellEndDate
from SalesLT.Product
where SellEndDate is not null

-- BETWEEN ... AND ...
-- products with prices 100 - 200
select ProductNumber, Name, ListPrice
from SalesLT.Product
where ListPrice between 100 and 200 -- both end values are included
order by ListPrice

-- same
select ProductNumber, Name, ListPrice
from SalesLT.Product
where ListPrice >= 100 and ListPrice <= 200 -- both end values are included
order by ListPrice

-- products with name that starts with M or more in the alphabet
select ProductNumber, Name, ListPrice
from SalesLT.Product
where Name >= 'M'
order by Name

-- products with name that starts with up to letter K
select ProductNumber, Name, ListPrice
from SalesLT.Product
where Name  < 'L'
order by Name

-- comparisons and  BETWEEN apply to dates too
-- products with SellEnddate in June 2006

select getdate() -- default format yyyy-MM-dd

select ProductNumber, Name, SellEndDate
from SalesLT.Product
where SellEndDate between '2006-06-01' and '2006-06-30'

-- compare to a list of things
-- products from category 5, 7, or 9
-- IN operator, with a list of values
select ProductNumber, Name, ProductCategoryID
from SalesLT.Product
where ProductCategoryID in (5, 7, 9)
order by ProductCategoryID, Name

-- products from categories other than 5, 7, 9
select ProductNumber, Name, ProductCategoryID
from SalesLT.Product
where ProductCategoryID not in (5, 7, 9)
order by ProductCategoryID, Name

-- more complex conditions
--products from categories 5, 7, 9 
--that are still being sold (SellEndDate is null)
select ProductNumber, Name, ProductCategoryID, SellEndDate
from SalesLT.Product
where ProductCategoryID in (5, 7, 9) and SellEndDate is null
order by ProductCategoryID, Name

--or
select ProductNumber, Name, ProductCategoryID, SellEndDate
from SalesLT.Product
where (ProductCategoryID = 5 or  
       ProductCategoryID = 7 or 
	   ProductCategoryID =  9) and SellEndDate is null
order by ProductCategoryID, Name


--Join Examples

-- get some top level data of then order, like
-- SalesOrderNumber, OrderDate, TotalDue, CustomerID (from SalesOrderHeader),
-- but add FirstName, LastName, and CompanyName of this customer (from Customer)

select SalesOrderNumber, OrderDate, TotalDue, SalesLT.Customer.CustomerID,
       FirstName, LastName, CompanyName
from SalesLT.SalesOrderHeader join SalesLT.Customer
   on SalesLT.SalesOrderHeader.CustomerID = SalesLT.Customer.CustomerID

-- simplify by renaming the tables (table aliases)
select SalesOrderNumber, OrderDate, TotalDue, cust.CustomerID,
       FirstName, LastName, CompanyName
from SalesLT.SalesOrderHeader as ord 
   join SalesLT.Customer as cust
      on ord.CustomerID = cust.CustomerID

-- old syntax
select SalesOrderNumber, OrderDate, TotalDue, SalesLT.Customer.CustomerID,
       FirstName, LastName, CompanyName
from SalesLT.SalesOrderHeader, SalesLT.Customer
--where SalesLT.SalesOrderHeader.CustomerID = SalesLT.Customer.CustomerID

-- without WHERE, it is a cross join (Cartesian product)
-- common error!!

-- old syntax allows table aliases too
select SalesOrderNumber, OrderDate, TotalDue, cust.CustomerID,
       FirstName, LastName, CompanyName
from SalesLT.SalesOrderHeader as ord, SalesLT.Customer as cust
where ord.CustomerID = cust.CustomerID

-- we will be using the new syntax (EXPLICIT JOIN)

-- another example:
-- we want a report of products available in each category:
-- category name (from ProductCategory table), and
-- ProductNumber and Name (from Product table)
-- order alphabetically by category name, and for each category by product name

select c.Name as CategoryName, p.Name as ProductName, ProductNumber
from SalesLT.ProductCategory c join SalesLT.Product p
  on c.ProductCategoryID = p.ProductCategoryID
order by CategoryName, ProductName

-- join means inner join

-- report of customers (first and last names) and their orders 
-- (sales order number and date)
-- but would like to include customers who do not have orders (use outer join)
-- order alphabetically by last name, then first name, then order number

-- only customers who have orders are displayed
select c.LastName, c.FirstName, c.CustomerID, o.SalesOrderNumber, 
       convert(date, o.OrderDate) as OrderDate
from SalesLT.Customer c inner join SalesLT.SalesOrderHeader o
   on c.CustomerID = o.CustomerID
order by LastName, FirstName, SalesOrderNumber

--include customers who do not have orders 
select c.LastName, c.FirstName, c.CustomerID, o.SalesOrderNumber, 
       convert(date, o.OrderDate) as OrderDate
from SalesLT.Customer c left join SalesLT.SalesOrderHeader o
   on c.CustomerID = o.CustomerID
order by LastName, FirstName, SalesOrderNumber

select * from SalesLT.Customer
order by LastName, FirstName

-- rule out customers with IDs below 1000
select c.LastName, c.FirstName, c.CustomerID, o.SalesOrderNumber, 
       convert(date, o.OrderDate) as OrderDate
from SalesLT.Customer c join SalesLT.SalesOrderHeader o
   on c.CustomerID = o.CustomerID
where c.CustomerID >= 1000
order by LastName, FirstName, SalesOrderNumber

select c.LastName, c.FirstName, c.CustomerID, o.SalesOrderNumber, 
       convert(date, o.OrderDate) as OrderDate
from SalesLT.Customer c left join SalesLT.SalesOrderHeader o
   on c.CustomerID = o.CustomerID
where c.CustomerID >= 1000
order by LastName, FirstName, SalesOrderNumber

-- what if the Customer table was listed on the right of JOIN
select c.LastName, c.FirstName, c.CustomerID, o.SalesOrderNumber, 
       convert(date, o.OrderDate) as OrderDate
from SalesLT.SalesOrderHeader o right join SalesLT.Customer c
   on c.CustomerID = o.CustomerID
where c.CustomerID >= 1000
order by LastName, FirstName, SalesOrderNumber

-- display only customers with IDs >= 1000 who do not have orders
select LastName, FirstName, c.CustomerID
from SalesLT.SalesOrderHeader o right join SalesLT.Customer c
   on c.CustomerID = o.CustomerID
where SalesOrderNumber is null -- rules out customers who have orders
and c.CustomerID >= 1000
order by LastName, FirstName

-- cross join
-- every combination of any record from one table matched with 
-- any record from the other table

-- every combination of customer and product (really, it does not make sense)
select LastName, FirstName, Name as ProductName
from SalesLT.Customer cross join SalesLT.Product -- rarely useful
order by LastName, FirstName, ProductName

-- self-join - useful then table is related to itself
-- there is relationship between categories

-- report parent categories with their subcategories
select parent.Name as ParentCategory, sub.Name as Subcategory
from SalesLT.ProductCategory parent join SalesLT.ProductCategory sub
    on parent.ProductCategoryID = sub.ParentProductCategoryID

-- list products from each category
select p.Name as ParentCategory, s.Name as Subcategory,
       pr.name as ProductName
from SalesLT.ProductCategory p 
   join SalesLT.ProductCategory s
      on p.ProductCategoryID = s.ParentProductCategoryID
   join SalesLT.Product pr
      on pr.ProductCategoryID = s.ProductCategoryID
order by ParentCategory, Subcategory, ProductName

-- join of three tables but without self join
-- display orders (order number and  date), 
-- with products ordered (name), and quantity ordered
select ord.SalesOrderNumber, 
       convert(date, ord.OrderDate) as OrderDate,
       prod.Name as ProductName, det.OrderQty
from SalesLT.SalesOrderHeader ord 
   join SalesLT.SalesOrderDetail det
     on ord.SalesOrderID = det.SalesOrderID
   join SalesLT.Product prod
     on det.ProductID = prod.ProductID


---------------
-- Module 3 Subqueries
----------------------

--  which products have price > 1000?
select Name
from SalesLT.Product
where ListPrice > 1000

-- which product has the largest list price?
--      what is the largest list price (there is MAX function)
        select max(ListPrice)
		from SalesLT.Product
		-- 3578.27
select Name, ListPrice
from SalesLT.Product
where ListPrice = 3578.27

-- put it together
select Name, ListPrice -- outer query
from SalesLT.Product
where ListPrice = (select max(ListPrice) -- a subquery
		           from SalesLT.Product)
--Execution order:
-- first the subquery runs and produces result
-- the result of the subquery is used in running of the outer query

-- which products have list price > average list price of all  products
-- Tip: there is AVG

-- Auxilliary question: what is the average list price?
select avg(ListPrice)
from SalesLT.Product
--744.5952

select Name, ListPrice
from SalesLT.Product
where ListPrice > (select avg(ListPrice)
                   from SalesLT.Product)
order by ListPrice

-- find the names of products that have been ordered 
-- in quantity of 20 or more

select ProductID 
from SalesLT.SalesOrderDetail
where OrderQty >= 20

-- use a join query
select distinct prod.ProductID, prod.Name 
from SalesLT.SalesOrderDetail det join SalesLT.Product prod
    on det.ProductID = prod.ProductID
where OrderQty >= 20

-- can also use a subquery
select ProductID, Name
from SalesLT.Product
where ProductID IN (select ProductID 
                    from SalesLT.SalesOrderDetail
                    where OrderQty >= 20)
-- as a rule of thumb, a query with join runs faster 
-- than one with a subquery

-- correlated  subqueries
-- for each product that has been ordered, 
-- get the order with maximum order quantity

-- let's start with simpler query: get order ID, product id , and quantity
-- for each order
select SalesOrderID, ProductID, OrderQty
from SalesLT.SalesOrderDetail
order by ProductID desc

-- get only product order records for which the q-antity ordered is
-- maximum for this product
select SalesOrderID, ProductID, OrderQty
from SalesLT.SalesOrderDetail od
where OrderQty = ( select max(OrderQty)
                   from SalesLT.SalesOrderDetail
				   where ProductID = od.ProductID)
				   -- it is the same product
                 
-- product ID  from outer query must be passed to the inner query

-- excution of correlated subqueries is an iteration:
-- for each row from the outer query,
--    a value is passed to the inner query
--    the inner query executes
--    the result of the inner query is used to determine 
--    if the row from the outer query should be included in the result
--    and then next row from the outer query is examined

-- we looked at subquery that is placed on the WHERE clause
-- a subquery can appear in other places

-- get order iD , date, and customer ID for every order
select SalesOrderID, convert(date, OrderDate) as OrderDate, 
       CustomerID
from SalesLT.SalesOrderHeader

-- want to include customer name (first name and last name)
-- use join
select SalesOrderID, convert(date, OrderDate) as OrderDate, 
       cust.CustomerID, FirstName, LastName
from SalesLT.SalesOrderHeader ord join SalesLT.Customer cust
     on ord.CustomerID = cust.CustomerID

--or, use a subquery to get data from Customer table
-- but have to combine both name into one column
select SalesOrderID, convert(date, OrderDate) as OrderDate, 
       CustomerID, (select FirstName + ' ' + LastName 
	                from SalesLT.Customer cust
					where cust.CustomerID = ord.CustomerID
					) as CustName
from SalesLT.SalesOrderHeader ord

-- the join is better!


-- Module 4: Scalar Functions

-- which year each product was introduced for sale?
-- there is function YEAR
select Name, year(SellStartDate) as SellStartYear
from SalesLT.Product

-- add how many years this product is/was selling 
select Name,
       year(SellStartDate) as SellStartYear,
	   datediff(year, SellStartDate, 
	        isnull(SellEndDate, getdate())) as YearsSelling
from SalesLT.Product

-- what month was each product introduced
-- functions MONTH, DATEPART, and DATENAME

select Name, convert(date, SellStartDate) as SellStartDate,
       month(SellStartDate) as MonthStarted,
	   datepart(month, SellStartDate) as MonthStarted2,
	   datename(month, SellStartDate) as MonthStarted3
from SalesLT.Product

-- what day of week did each product start selling?
select Name, 
       datepart(weekday, SellStartDate) as WeekDayStarted,
	   datename(weekday, SellStartDate) as WeekDayStarted2
from SalesLT.Product

-- which products started selling on a Friday
select Name
from SalesLT.Product
where datepart(weekday, SellStartDate) = 6
--or
select Name
from SalesLT.Product
where datename(weekday, SellStartDate) = 'Friday'

-- CONCAT function
-- get fullname of each customer
select CustomerID, FirstName + ' ' + LastName as FullName
from SalesLT.Customer 
-- or
select CustomerID, concat(FirstName, ' ', LastName) as FullName
from SalesLT.Customer 
-- or
select CustomerID, concat_ws(' ', FirstName, LastName) as FullName
from SalesLT.Customer 

-- get full addesses from Address table
select AddressID, 
       concat_ws(', ', AddressLine1, City, StateProvince,
	                   CountryRegion, PostalCode) as FullAddress
from SalesLT.Address

-------------------------
-- Module 4 Logical Functions

-- display product names and sizes, adding column SizeType that says 
-- 'Numeric' or 'Non-numeric' depending on whether size 
-- is a number or not

-- there is a function ISNUMERIC - returns 1 or 0 depending on
-- whether the argument is a number or not
select Name, Size, 
       iif(isnumeric(Size)= 1, 'Numeric', 
	       iif(Size is null, NULL, 'Non-numeric') )as SizeType
from SalesLT.Product

-- get product names, category names from products, and
-- add a calculated column ProductType that reads 'Bikes', 
-- 'Components', 'Clothing', or 'Accessories', based on 
-- the parent category of the product's category

select p.Name as ProductName, p.ProductCategoryID, 
       c.Name as CategoryName, c.ParentProductCategoryID,
	   choose(c.ParentProductCategoryID, 
	   'Bikes', 'Components', 'Clothing','Accessories') as ProductType
from SalesLT.Product p join SalesLT.ProductCategory c
   on p.ProductCategoryID = c.ProductCategoryID

-------------------------
-- Module 4 Aggregate Functions

-- how many products?
select count(*) as ProductsCount from SalesLT.Product
-- or better
select count(ProductID) as ProductsCount from SalesLT.Product
-- can use any not null column
select count(Name) as ProductsCount from SalesLT.Product
-- what if we use a column that has null values?
select count(Color) as ProductsCount from SalesLT.Product 
   -- counts only the not null values
-- how many different colours products have?
select count(distinct Color) as NrColours from  SalesLT.Product

-- how many different customers have orders?
select count(distinct CustomerID) as NrCustomers
from SalesLT.SalesOrderHeader

-- what is average total of an order
select avg(TotalDue) as AverageTotal
from SalesLT.SalesOrderHeader
-- format as currency
select format(avg(TotalDue),'c') as AverageTotal
from SalesLT.SalesOrderHeader

-- what is the largest and smallest order total?
select format(min(TotalDue),'c') as Smallest,
       format(max(TotalDue),'c') as Largest
from SalesLT.SalesOrderHeader

-- how much money did all the orders bring?
select format(sum(TotalDue),'c') as GrandTotal
from SalesLT.SalesOrderHeader

-- how many bike models are there? Count ProductIDs for bikes 
-- (category name contains the word Bike)
select count(ProductID) as BikeCount
from SalesLT.Product p join SalesLT.ProductCategory c
    on p.ProductCategoryID = c.ProductCategoryID
where c.Name like '%Bike%'

-- how many customers are assigned to salesperson adventure-works\jillian0
select count(CustomerID) as CustomerCount
from SalesLT.Customer
where SalesPerson = 'adventure-works\jillian0'

--  how many customers are assigned to each salesperson?
select SalesPerson, count(CustomerID) as CustomerCount
from SalesLT.Customer
group by SalesPerson

-- find 5 sales people with largest number of customers
select top 5 SalesPerson, count(CustomerID) as CustomerCount
from SalesLT.Customer
group by SalesPerson
order by CustomerCount desc

-- total sales revenue for each salesperson
-- we will sum SubTotal for each order of customers with the salesperson
select SalesPerson, format(isnull(sum(Subtotal),10), 'c') as TotalRevenue
from SalesLT.Customer c left join SalesLT.SalesOrderHeader o
   on c.CustomerID = o.CustomerID
group by SalesPerson
order by TotalRevenue desc

-- let's go back to the query for number of customers per salespareson
-- but want to see only salespersons with more than 100 customers
select SalesPerson, count(CustomerID) as CustomerCount
from SalesLT.Customer
group by SalesPerson
having count(CustomerID) > 100
order by CustomerCount desc

-- display categories and how many products are in each category
select p.ProductCategoryID, c.Name, count(ProductID) as ProductCount
from SalesLT.Product p join SalesLT.ProductCategory c
      on p.ProductCategoryID = c.ProductCategoryID
group by p.ProductCategoryID, c.Name
order by ProductCount desc

-- display only categories that have 10 or more products
select p.ProductCategoryID, c.Name, count(ProductID) as ProductCount
from SalesLT.Product p join SalesLT.ProductCategory c
      on p.ProductCategoryID = c.ProductCategoryID
group by p.ProductCategoryID, c.Name
having count(ProductID) >= 10
order by ProductCount desc

---------------------------------

-- Module 5

-- Inserting data
-------------------

-- create a table
create table SalesLT.CallLog
(
   CallID int identity primary key,
   CallTime datetime not null default getdate(),
   SalesPerson nvarchar(256) not null,
   CustomerID int not null references SalesLT.Customer(CustomerID), --FK
   PhoneNumber nvarchar(25) not null,
   Notes nvarchar(max) -- null
)

select * from SalesLT.CallLog

-- insert a row of data - all data provided
insert into SalesLT.CallLog(CallTime, SalesPerson, CustomerID,
             PhoneNumber, Notes)
values(convert(datetime,'2023-03-22 8:45:00'),
       'adventure-works\pamela0', 1, '245-555-0173', 'Returning call')
-- with default value
insert into SalesLT.CallLog(CallTime, SalesPerson, CustomerID,
             PhoneNumber, Notes)
values(default, 'adventure-works\david8', 2, '170-555-0127', NULL)

-- you can also apply default values by skipping the columns
insert into SalesLT.CallLog(SalesPerson, CustomerID,
             PhoneNumber)
values('adventure-works\david8', 5, '234-123-4545')

select * from SalesLT.CallLog

-- you can also insert multiple rows at the samme time
insert into SalesLT.CallLog(CallTime, SalesPerson, CustomerID, PhoneNumber)
values
('2023-03-22 12:00:00', 'adventure-works\pamela0', 2, '345-234-1234'),
(getdate(), 'adventure-works\david8', 4, '123-987-1234')

--how to get the identity value that was generated
select SCOPE_IDENTITY() -- last generated identity value

-- last generated identity value for specific table
select IDENT_CURRENT('SalesLt.CallLog')

-- Updating data

select * from SalesLT.CallLog

-- put 'No notes' where there is NULL
update SalesLT.CallLog
set Notes = 'No Notes'
where Notes is null

-- add one hour to call time for CallID 1
update SalesLT.CallLog
set CallTime = dateadd(hour, 1, CallTime)
where CallID = 1

-- you can update more than one column
-- change callID 3 to record different customer and phone
update SalesLT.CallLog
set CustomerID =3, PhoneNumber = '234-456-67890'
where CallID = 3

-- fix the phone number
update SalesLT.CallLog
set PhoneNumber = '234-456-6789'
where CallID = 3

select * from SalesLT.CallLog

-- you can get data from another table for the update
-- get salesperson and phone nuber from the Customer table
update SalesLT.CallLog
set SalesPerson = c.SalesPerson, PhoneNumber = c.Phone
from  SalesLT.Customer as c
where SalesLT.CallLog.CustomerID = c.CustomerID
-- the update applies to all rows

select * from SalesLT.CallLog

-- if no where condition - all rows are updated
update SalesLT.CallLog
set Notes = null

-- deleting data
--remove call ogs for customer 2
delete from SalesLT.CallLog
where CustomerID = 2

select * from SalesLT.CallLog

-- transaction is a unit of work - either the whole thing succeeds,
--    or the whole thing fails (there is no part way complete)
-- BEGIN TRAN - starts a transaction
-- COMMIT TRAN - make it all permanent
-- ROLLBACK TRAN - take it all back (undo it)

begin tran

insert into SalesLT.CallLog(CallTime, SalesPerson, CustomerID,
             PhoneNumber, Notes)
values(default, 'adventure-works\david8', 2, '170-555-0127', NULL)

select * from SalesLT.CallLog

-- inteded to delete the first record, but forgot to put WHERE
delete from SalesLT.CallLog

select * from SalesLT.CallLog -- no data

rollback tran
select * from SalesLT.CallLog -- data is back to the state at the begin tran

--transaction ended with rollback, so if you want to start transaction
begin tran