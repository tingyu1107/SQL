--  找出和最貴的產品同類別的所有產品
select CategoryID, ProductName
from Products
where CategoryID = (SELECT CategoryID FROM Products WHERE UnitPrice
					= (SELECT MAX(UnitPrice) FROM products))

-- 找出和最貴的產品同類別最便宜的產品
select CategoryID, ProductName, UnitPrice
from Products
where CategoryID = (SELECT CategoryID FROM Products WHERE UnitPrice
					= (SELECT MAX(UnitPrice) FROM products))
AND UnitPrice = (select min(UnitPrice) from  Products where CategoryID = (SELECT CategoryID FROM Products WHERE UnitPrice
					= (SELECT MAX(UnitPrice) FROM products)))

-- 計算出上面類別最貴和最便宜的兩個產品的價差
select max(UnitPrice) - min(UnitPrice) diff
from Products
where CategoryID = 1
-- 找出沒有訂過任何商品的客戶所在的城市的所有客戶
select CustomerID, City
from Customers
where City in (select City from Customers where CustomerID 
			not in (select CustomerID from Orders))

-- 找出第 5 貴跟第 8 便宜的產品的產品類別
select  CategoryID
from Products
order by UnitPrice desc
offset 4 rows 
fetch next 1 rows only

select CategoryName
from Categories
where CategoryID = 4

select  CategoryID
from Products
order by UnitPrice 
offset 7 rows 
fetch next 1 rows only

select CategoryName
from Categories
where CategoryID = 1

-- 找出誰買過第 5 貴跟第 8 便宜的產品
select distinct o.CustomerID
from Products p
inner join [Order Details] od on p.ProductID = od.ProductID
inner join Orders o on o.OrderID = od.OrderID
where p.CategoryID = 4

select distinct o.CustomerID
from Products p
inner join [Order Details] od on p.ProductID = od.ProductID
inner join Orders o on o.OrderID = od.OrderID
where p.CategoryID = 1

-- 找出誰賣過第 5 貴跟第 8 便宜的產品
select distinct o.EmployeeID
from Products p
inner join [Order Details] od on p.ProductID = od.ProductID
inner join Orders o on o.OrderID = od.OrderID
where p.CategoryID = 4

select distinct o.EmployeeID
from Products p
inner join [Order Details] od on p.ProductID = od.ProductID
inner join Orders o on o.OrderID = od.OrderID
where p.CategoryID = 1
-- 找出 13 號星期五的訂單 (惡魔的訂單)
select OrderID, OrderDate
from Orders
WHERE DAY(OrderDate) = 13 and DATEPART( WEEKDAY, OrderDate )= 6 
-- 找出誰訂了惡魔的訂單
select distinct  CustomerID
from Orders
WHERE DAY(OrderDate) = 13 and DATEPART( WEEKDAY, OrderDate )= 6 
-- 找出惡魔的訂單裡有什麼產品
select distinct od.ProductID
from Orders o
inner join [Order Details] od on o.OrderID = od.OrderID
WHERE DAY(OrderDate) = 13 and DATEPART( WEEKDAY, OrderDate )= 6 
-- 列出從來沒有打折 (Discount) 出售的產品
select distinct p.ProductName
from [Order Details] od
inner join Products p on p.ProductID = od.ProductID
where od.Discount = 0
-- 列出購買非本國的產品的客戶
select distinct o.CustomerID
from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.ProductID = od.ProductID
inner join Suppliers s on s.SupplierID = p.SupplierID
inner join Customers c on c.CustomerID = o.CustomerID
where s.Country != c.Country
-- 列出在同個城市中有公司員工可以服務的客戶
select distinct o.EmployeeID, o. CustomerID
from Orders o
inner join Employees e on o.EmployeeID = e.EmployeeID
inner join Customers c on o.CustomerID = c.CustomerID
where e.City = c.City
-- 列出那些產品沒有人買過
select p.ProductID, p.ProductName
from Products p
inner join [Order Details] od on od.ProductID = p.ProductID
inner join Orders o on o.OrderID = od.OrderID
where p.ProductID not in (od.ProductID) 
----------------------------------------------------------------------------------------
-- 列出所有在每個月月底的訂單
SELECT * 
FROM Orders
WHERE OrderDate = (EOMONTH(OrderDate))

-- 列出每個月月底售出的產品
select distinct p.ProductName
from Products p
inner join [Order Details] od on od.ProductID = p.ProductID
inner join Orders o on o.OrderID = od.OrderID
where o.OrderDate = (EOMONTH(o.OrderDate))
-- 找出有敗過最貴的三個產品中的任何一個的前三個大客戶(未完成
select top(3) p.ProductID, p.UnitPrice
from Products p
order by  p.UnitPrice desc

select top(3) o.CustomerID, sum(od.Quantity*od.UnitPrice*(1-od.Discount)) as Sales
from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
where od.ProductID = 38 or od.ProductID = 29 or od.ProductID = 9
group by o.CustomerID
order by Sales desc

-- 找出有敗過銷售金額前三高個產品的前三個大客戶
select top(3) od.ProductID, sum(od.Quantity*od.UnitPrice*(1-od.Discount))
from [Order Details] od
inner join Products p on p.ProductID = od.ProductID
group by od.ProductID
order by sum(od.Quantity*od.UnitPrice*(1-od.Discount)) desc

select top(3) o.CustomerID, sum(od.Quantity*od.UnitPrice*(1-od.Discount))
from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
where od.ProductID in(38, 29, 59)
group by o.CustomerID
order by sum(od.Quantity*od.UnitPrice*(1-od.Discount)) desc
-- 找出有敗過銷售金額前三高個產品所屬類別的前三個大客戶
select top(3) p.CategoryID, od.ProductID, sum(od.Quantity*od.UnitPrice*(1-od.Discount)) as Sales
from [Order Details] od
inner join Products p on p.ProductID = od.ProductID
group by p.CategoryID,od.ProductID
order by Sales desc --1, 6, 4

select top(3) o.CustomerID, sum(od.Quantity*od.UnitPrice*(1-od.Discount)) as Sales
from Products p
inner join [Order Details] od on od.ProductID = p.ProductID
inner join Orders o on od.OrderID = o.OrderID
where p.CategoryID in (1, 6, 4)
group by o.CustomerID
order by Sales desc
-- 列出消費總金額高於所有客戶平均消費總金額的客戶的名字，以及客戶的消費總金額(

select c.CompanyName ,sum(od.Quantity*od.UnitPrice*(1-od.Discount)) as Buy
from Customers c
inner join Orders o on o.CustomerID = c.CustomerID
inner join [Order Details] od on od.OrderID = o.OrderID
group by c.CompanyName 
having sum(od.Quantity*od.UnitPrice*(1-od.Discount))  > (select sum(od.Quantity*od.UnitPrice*(1-od.Discount)) / count( distinct c.CustomerID) 
														from Customers c
														inner join Orders o on o.CustomerID = c.CustomerID
														inner join [Order Details] od on od.OrderID = o.OrderID)

-- 列出最熱銷的產品，以及被購買的總金額
select top(1) ProductID
from [Order Details]
group by ProductID
order by  sum(Quantity) desc

select ProductID,sum(Quantity*UnitPrice*(1-Discount))
from [Order Details]
where ProductID = 60
group by ProductID
-- 列出最少人買的產品
select top(1) ProductID,sum(Quantity)
from [Order Details]
group by ProductID
order by  sum(Quantity) 
-- 列出最沒人要買的產品類別 (Categories)
select top(1) p.CategoryID,sum(od.Quantity)
from [Order Details] od
inner join Products p on p.ProductID = od.ProductID
group by p.CategoryID
order by  sum(od.Quantity) 
-- 列出跟銷售最好的供應商(12)買最多金額的客戶與購買金額 (含購買其它供應商的產品)
select top (1) s.SupplierID, sum(od.Quantity)--銷售最好的供應商
from Suppliers s
inner join Products p on p.SupplierID = s.SupplierID
inner join [Order Details] od on od.ProductID = p.ProductID
group by s.SupplierID
order by sum(od.Quantity) desc

select top(1) c.CustomerID--買最多金額的客戶
from Customers c
inner join Orders o on c.CustomerID = o.CustomerID
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.SupplierID = od.ProductID
inner join Suppliers s on s.SupplierID = p.SupplierID
where s.SupplierID = 12
order by od.Quantity desc

select c.CustomerID, sum(od.Quantity*od.UnitPrice*(1-od.Discount))--總購買金額
from Customers c
inner join Orders o on c.CustomerID = o.CustomerID
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.SupplierID = od.ProductID
inner join Suppliers s on s.SupplierID = p.SupplierID
where c.CustomerID = 'SAVEA'
group by c.CustomerID

-- 列出跟銷售最好的供應商買最多金額的客戶與購買金額 (不含購買其它供應商的產品)
select top(1) c.CustomerID,  od.Quantity*od.UnitPrice*(1-Discount) 
from Customers c
inner join Orders o on c.CustomerID = o.CustomerID
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.SupplierID = od.ProductID
inner join Suppliers s on s.SupplierID = p.SupplierID
where s.SupplierID = 12
order by od.Quantity desc

-- 列出沒有傳真 (Fax) 的客戶和它的消費總金額
select c.CustomerID, sum(od.UnitPrice * od.Quantity * (1-od.Discount))
from Customers c
inner join Orders o on c.CustomerID = o.CustomerID
inner join [Order Details] od on od.OrderID = o.OrderID
where c.Fax is NULL
group by c.CustomerID
-- 列出每一個城市消費的產品種類數量
select c.City, p.CategoryID, sum(Quantity)
from [Order Details] od
inner join Products p on p.SupplierID = od.ProductID
inner join Orders o on o.OrderID = od.OrderID
inner join Customers c on c.CustomerID = o.CustomerID
group by c.City, p.CategoryID
-- 列出目前沒有庫存的產品在過去總共被訂購的數量
select p.ProductID, sum(od.Quantity)
from Products p
inner join [Order Details] od on od.ProductID = p.ProductID
where p.UnitsInStock = 0
group by p.ProductID
-- 列出目前沒有庫存的產品在過去曾經被那些客戶訂購過
select distinct o.CustomerID
from Products p
inner join [Order Details] od on od.ProductID = p.ProductID
inner join Orders o on o.OrderID = od.OrderID
where p.UnitsInStock = 0
-- 列出每位員工的下屬的業績總金額
select e.ReportsTo , sum(od.UnitPrice*od.Quantity*(1-od.Discount)) as total
from Employees e
inner join Orders o on o.EmployeeID=e.ReportsTo
inner join [Order Details] od on od.OrderID=o.OrderID
group by e.ReportsTo

-- 列出每家貨運公司運送最多的那一種產品類別與總數量(?
select  o.ShipVia, p.CategoryID,sum(od.Quantity)
from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
inner join Products p on p.ProductID = od.ProductID
where p.CategoryID = 1
group by o.ShipVia, p.CategoryID
order by sum(od.Quantity) desc
		
-- 列出每一個客戶買最多的產品類別與金額
with CustomerBoughtType as (
	select
		c.CustomerID, p.CategoryID,sum(od.UnitPrice * od.Quantity) as LumpSum, sum(od.Quantity) as SumQuantity
	from Customers c
	join Orders o on c.CustomerID = o.CustomerID
	join [Order Details] od on o.OrderID = od.OrderID
	join Products p on od.ProductID = p.ProductID
	join Categories ca on p.CategoryID = ca.CategoryID
	group by c.CustomerID, p.CategoryID
),
CustomerMaxQuantity as (
	select
		CustomerID, MAX(SumQuantity) as MaxQuantity
	from CustomerBoughtType
	group by CustomerID
)
select 
	cbt.CustomerID, cbt.CategoryID, cbt.LumpSum
from CustomerBoughtType cbt
join CustomerMaxQuantity cmq on cbt.CustomerID = cmq.CustomerID and cbt.SumQuantity = cmq.MaxQuantity;

-- 列出每一個客戶買最多的那一個產品與購買數量
with CustomerBoughtQuantity as (
	select
		c.CustomerID, p.ProductID, p.ProductName, sum(od.Quantity) as Quantity
	from Customers c
	join Orders o on c.CustomerID = o.CustomerID
	join [Order Details] od on o.OrderID = od.OrderID
	join Products p on od.ProductID = p.ProductID
	group by c.CustomerID, p.ProductID, p.ProductName
),
CustomerMaxBoughtQuantity as (
	select
		CustomerID, max(Quantity) as MaxQuantity
	from CustomerBoughtQuantity 
	group by CustomerID
)
select
	cbq.CustomerID, cbq.ProductName, cbq.Quantity
from CustomerBoughtQuantity cbq
join CustomerMaxBoughtQuantity cmbq on cbq.CustomerID = cmbq.CustomerID and cbq.Quantity = cmbq.MaxQuantity
order by cbq.CustomerID

-- 按照城市分類，找出每一個城市最近一筆訂單的送貨時間
SELECT o.ShipCity, max(o.ShippedDate)
FROM Orders o
group by o.ShipCity
-- 列出購買金額第五名與第十名的客戶，以及兩個客戶的金額差距
select o.CustomerID, sum(od.UnitPrice * od.Quantity * (1-od.Discount)) as Buy
from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
group by o.CustomerID
order by Buy desc
offset 4 rows 
fetch next 1 rows only

select o.CustomerID, sum(od.UnitPrice * od.Quantity * (1-od.Discount)) as Buy
from Orders o
inner join [Order Details] od on od.OrderID = o.OrderID
group by o.CustomerID
order by Buy desc
offset 9 rows 
fetch next 1 rows only

select 49979.9050006866 - 27363.6050434113 as diff
