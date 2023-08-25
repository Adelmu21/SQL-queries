-- Q1 query
select CompanyName, Phone, 
	   case
	     when Phone like '1 (%' then 'International'
		 else 'US/Canada'
	   end as Location
from SalesLT.Customer 


-- Q2 query
select CustomerID, concat(Title, ' ', FirstName, ' ', LastName, ' ', Suffix) as FullName, CompanyName
from SalesLT.Customer

-- Q3 query
select ProductNumber, Name, ProductCategoryID, ListPrice
from SalesLT.Product
where ProductCategoryID in (5, 6, 7)
order by ListPrice desc

-- Q4 query

--average price
select avg(ListPrice) as AverageListPrice
from SalesLT.Product 
where Color like 'red'
-- average price is 1401.95

-- lowest price with color red
select Color, ListPrice
from SalesLT.Product
where Color like 'red' and ListPrice = (select min(ListPrice) 
										from SalesLT.Product
										where Color like 'red')
-- lowest price is 34.99

-- highest price with color red
select Color, ListPrice
from SalesLT.Product
where Color like 'red' and ListPrice = (select max(ListPrice) 
										from SalesLT.Product)
-- highest price is 3578.27

-- Q5 query
select SalesOrderNumber, CustomerID, convert(date, OrderDate) as OrderDate, convert(date, DueDate) as DueDate, datediff(day, OrderDate, isnull(DueDate, getdate())) as DaysDue
from SalesLT.SalesOrderHeader


-- Q6 query
select o.CustomerID, SalesOrderNumber, TotalDue, FirstName, LastName, CompanyName
from SalesLT.SalesOrderHeader o join SalesLT.Customer c
	on o.CustomerID = c.CustomerID
order by CompanyName

-- Q7 query
select  ProductID, count(OrderQty) as OrderQty  
from SalesLT.SalesOrderDetail
group by ProductID
order by OrderQty desc

-- Q8 query
select  o.ProductID, p.Name, count(OrderQty) as OrderQty
from SalesLT.SalesOrderDetail o join SalesLT.Product p
	on o.ProductID = p.ProductID
group by o.ProductID, p.Name
order by OrderQty desc

-- Q9 query
select AddressID, AddressLine1, City, StateProvince, CountryRegion 
from SalesLT.Address 
where CountryRegion like 'Canada'
order by StateProvince, City


-- Q10 query
select m.ProductModelID, m.Name, count(m.ProductModelID) as ProductCount
from SalesLT.ProductModel m join SalesLT.Product p
      on p.ProductModelID = m.ProductModelID
group by m.ProductModelID, m.Name
having count(m.ProductModelID) >= 10
order by ProductCount desc

-- Q11 query
select ListPrice, ProductCategoryID, ListPrice * 0.9 as DiscountedListPrice
from SalesLT.Product 
where ListPrice IS NOT NULL and ProductCategoryID = 15
 



-- Q12 query
select * 
into SalesLT.CustomerCopy
from SalesLT.Customer

select * 
from SalesLT.CustomerCopy
delete from SalesLT.CustomerCopy
where CustomerID in (1)

select * 
from SalesLT.CustomerCopy


