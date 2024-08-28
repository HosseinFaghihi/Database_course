--1( ??? ????? ?? ????? ??? ???????

select count(ord.ORDERID) majmoe_sefareshat from orders ord

--2( ????? ???? ?? ??? ??????? ???? ???? ????

SELECT SUM (o.quantity * p.price) daramad_kol
 FROM orderdetails o INNER JOIN products p ON o.PRODUCTID = p.PRODUCTID

--3(  5????? ???? ?? ?? ???? ?????? ?? ??? ??????? ???? ????. ID? ??? ? ????? ??? ??? ?? ?? ?? ????? ????

with t1 as
(
select cu.CUSTOMERID, cu.CUSTOMERNAME ,ord.ORDERID from customers cu
inner join orders ord on cu.CUSTOMERID = ord.CUSTOMERID
),
t2 as
(
select o.ORDERID ,o.QUANTITY*p.price  price from orderdetails o
inner join products p on o.PRODUCTID=p.PRODUCTID
)
select t1.CUSTOMERID , t1.CUSTOMERNAME ,sum(t2.price) as total_price from t1
inner join t2 on t2.ORDERID = t1.ORDERID
group by t1.CUSTOMERID, t1.CUSTOMERNAME
order by total_price desc
fetch first 5 rows only

--4( ??????? ????? ? ??????? ?? ????? ?? ?? ????? ID ? ??? ?? ????? ????. )?? ????? ????? ???? ???(

with t1 as
(
select cu.CUSTOMERID, cu.CUSTOMERNAME ,ord.ORDERID from customers cu
inner join orders ord on cu.CUSTOMERID = ord.CUSTOMERID
),
t2 as
(
select o.ORDERID ,o.QUANTITY*p.price  price from orderdetails o
inner join products p on o.PRODUCTID=p.PRODUCTID
)
select t1.customerid , t1.CUSTOMERNAME ,avg(t2.price) av from t1
inner join t2 on t2.ORDERID = t1.ORDERID
group by t1.CUSTOMERID , t1.CUSTOMERNAME
order by av desc

--5( ????? ?? ?? ?? ???? ????? ?? ?????? ??????? ???????? ????? ??? ??? ??????? ? ?? ?? ??? ?????? ?? ????? ?? 5 ????? ???????

with t1 as
(
select cu.CUSTOMERID, cu.CUSTOMERNAME ,ord.ORDERID from customers cu
inner join orders ord on cu.CUSTOMERID = ord.CUSTOMERID
),
t2 as
(
select o.ORDERID ,o.QUANTITY*p.price  price from orderdetails o
inner join products p on o.PRODUCTID=p.PRODUCTID
)
select t1.customerid , t1.CUSTOMERNAME , count(t1.orderid) tedad_sefaresh,sum(t2.price) majmoe_hazine from t1
inner join t2 on t2.ORDERID = t1.ORDERID
group by t1.CUSTOMERID , t1.CUSTOMERNAME
having count(t1.ORDERID)>5
order by majmoe_hazine desc

--6-???? ????? ?? ?? ??????? ??? ??? ??????? ????? ?? ????? ???? ???? )?? ????? ID ? ??? ????? ????(

select  o.PRODUCTID,p.PRODUCTNAME,sum(o.QUANTITY) tedad_sefaresh, sum(o.QUANTITY * p.price) daramad from orderdetails o
inner join products p on p.PRODUCTID = o.PRODUCTID
group by o.PRODUCTID , p.PRODUCTNAME
order by daramad desc
fetch first 1 row only

--7( ?? ???? )category )??? ????? ????? )?? ????? ????? ???? ????(

SELECT p.CATEGORYID,ca.CATEGORYNAME, COUNT(p.PRODUCTID) AS tedad
FROM products p
inner join categories ca on p.CATEGORYID = ca.CATEGORYID
GROUP BY p.CATEGORYID,ca.CATEGORYNAME
ORDER BY tedad DESC

--8( ????? ?????? ?? ?? ???? ?? ???? ????? ?? ????? ????.

WITH t1 AS (
    SELECT 
        p.productname, 
        p.categoryid,
        SUM(o.quantity) AS tedad_forosh,
        ROW_NUMBER() OVER(PARTITION BY p.categoryid ORDER BY SUM(o.quantity) DESC) AS rn
    FROM products p
    INNER JOIN orderdetails o ON o.PRODUCTID = p.PRODUCTID
    GROUP BY p.productname, p.categoryid
)
SELECT productname, categoryid, tedad_forosh
FROM t1
WHERE rn = 1;

--9( 5 ?????? ???? ?? ???????? ????? ?? ????? ????? ?? ????? ID ? ??? + � � + ??? ???????? ????? ????.

WITH t1 AS (
    SELECT em.employeeid, em.firstname || ' ' || em.lastname AS full_name, ord.orderid
    FROM employees em
    INNER JOIN orders ord ON ord.employeeid = em.employeeid
),
t2 AS (
    SELECT ord.orderid, ord.quantity * p.price AS total_sales
    FROM orderdetails ord
    INNER JOIN products p ON p.productid = ord.productid
)
    SELECT t1.employeeid, t1.full_name, SUM(t2.total_sales) AS total_sales
    FROM t1
    INNER JOIN t2 ON t1.orderid = t2.orderid
    GROUP BY t1.employeeid, t1.full_name
    ORDER BY total_sales DESC
    fetch first 5 rows only

--10-( ??????? ????? ?? ?????? ?? ???? ?? ????? ???? ???????? )?? ????? ????? ???? ????

WITH t1 AS (
    SELECT em.employeeid, em.firstname || ' ' || em.lastname AS full_name, ord.orderid
    FROM employees em
    INNER JOIN orders ord ON ord.employeeid = em.employeeid
),
t2 AS (
    SELECT ord.orderid, ord.quantity * p.price AS sales
    FROM orderdetails ord
    INNER JOIN products p ON p.productid = ord.productid
)
    SELECT t1.employeeid, t1.full_name, avg(t2.sales) AS avrage_sale
    FROM t1
    INNER JOIN t2 ON t1.orderid = t2.orderid
    GROUP BY t1.employeeid, t1.full_name
    ORDER BY avrage_sale DESC

--11???? ???? ??????? ????? ??????? ?? ??? ???? ???? )??? ???? ?? ?? ????? ????? ??????? ????? ????

select su.COUNTRY , count(ord.quantity) tedad_sefaresh from suppliers su
inner join products pr on pr.SUPPLIERID = su.SUPPLIERID
inner join orderdetails ord on ord.PRODUCTID = pr.PRODUCTID
group by su.country
order by tedad_sefaresh desc
fetch first 1 rows only

--12( ????? ????? ?? ??????? ?? ???? ???? ????? )?? ????? ??? ???? ? ?? ????? ????? ???? ????

select su.COUNTRY , sum(ord.quantity*pr.price) daramad from suppliers su
inner join products pr on pr.SUPPLIERID = su.SUPPLIERID
inner join orderdetails ord on ord.PRODUCTID = pr.PRODUCTID
group by su.country
order by daramad desc

--13 ??????? ???? ?? ???? ???? ???? )?? ????? ??? ???? ? ?? ????? ????? ????? ????

with t1 as
(
  SELECT ca.CATEGORYNAME,
         p.categoryid,
         avg(p.PRICE) AS miangin_gheimat,
         ROW_NUMBER () OVER (PARTITION BY p.categoryid ORDER BY  avg(p.price) DESC) AS rn
    FROM products p INNER JOIN categories ca ON p.CATEGORYID = ca.CATEGORYID
GROUP BY ca.CATEGORYNAME, p.categoryid
)
select t1.CATEGORYNAME , t1.MIANGIN_GHEIMAT from t1

--14???? ???? ???? ???? ???? ???? )?? ????? ??? ???? ????? ????

with t1 as
(
  SELECT ca.CATEGORYNAME,
         p.categoryid,
         sum(p.PRICE) AS gheimat,
         ROW_NUMBER () OVER (PARTITION BY p.categoryid ORDER BY  sum(p.price) DESC) AS rn
    FROM products p INNER JOIN categories ca ON p.CATEGORYID = ca.CATEGORYID
GROUP BY ca.CATEGORYNAME, p.categoryid
)
select t1.CATEGORYNAME , t1.gheimat from t1
fetch first 1 rows only

--15?? ??? 1996 ?? ??? ??? ????? ??? ??? ????

SELECT TO_CHAR(OrderDate, 'MM') Month, COUNT(OrderID) TotalOrders
FROM Orders
WHERE EXTRACT(YEAR FROM OrderDate) = 1996
GROUP BY TO_CHAR(OrderDate, 'MM')
ORDER BY TO_NUMBER(TO_CHAR(OrderDate, 'MM'));

--16 ??????? ????? ? ????? ??? ??????? ?? ????? ???? ????? )?? ????? ??? ????? ? ?? ???? ???? ???? ????

SELECT 
    c.CustomerName,
    AVG(time_diff) AS AvgTimeBetweenOrders
FROM (
    SELECT 
        o.CustomerID,
        o.OrderDate - LAG(o.OrderDate) OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate) AS time_diff
    FROM 
        Orders o
) time_diffs
JOIN 
    Customers c ON time_diffs.CustomerID = c.CustomerID
WHERE 
    time_diff IS NOT NULL 
GROUP BY 
    c.CustomerID, c.CustomerName
ORDER BY 
    AvgTimeBetweenOrders DESC;

--17?? ?? ??? ??? ??????? ???? ???????? )?? ???? ????? ???? ????

SELECT 
    TO_CHAR(o.OrderDate, 'YYYY') AS Year,
    CASE 
        WHEN TO_CHAR(o.OrderDate, 'MM') IN ('03', '04', '05') THEN 'Spring'
        WHEN TO_CHAR(o.OrderDate, 'MM') IN ('06', '07', '08') THEN 'Summer'
        WHEN TO_CHAR(o.OrderDate, 'MM') IN ('09', '10', '11') THEN 'Autumn'
        ELSE 'Winter'
    END AS Season,
    SUM(od.Quantity * p.Price) AS TotalOrderAmount
FROM 
    Orders o
inner JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
inner JOIN 
    Products p ON od.ProductID = p.ProductID
GROUP BY 
    TO_CHAR(o.OrderDate, 'YYYY'),
    CASE 
        WHEN TO_CHAR(o.OrderDate, 'MM') IN ('03', '04', '05') THEN 'Spring'
        WHEN TO_CHAR(o.OrderDate, 'MM') IN ('06', '07', '08') THEN 'Summer'
        WHEN TO_CHAR(o.OrderDate, 'MM') IN ('09', '10', '11') THEN 'Autumn'
        ELSE 'Winter'
    END
ORDER BY 
    Year DESC,
    Season DESC;
    
--18-( ???? ????? ????? ??????? ????? ???? ?? ????? ???? ???? )?? ????? ??? ? ID ????? ????
    
    SELECT 
    s.SupplierID,
    s.SupplierName,
    COUNT(p.ProductID) AS TotalProductsSupplied
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY TotalProductsSupplied DESC
fetch first 1 rows only;

--19-( ??????? ???? ????? ????? ??? ???? ?? ????????? ???? ????? )?? ????? ??? ? ID ? ?? ???? ???? ????? ????(

SELECT 
    s.SupplierID,
    s.SupplierName,
    AVG(p.Price) AS AveragePrice
FROM Suppliers s
JOIN Products p ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY AveragePrice DESC;

