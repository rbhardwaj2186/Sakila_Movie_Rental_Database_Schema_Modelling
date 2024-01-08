use sakila;

select * from rental;
use classicmodels;
select * from customers limit 200;
select customerName, creditLimit
from customers
where country <> 'USE' and creditLimit=0;
--
select country, avg(creditLimit)
from customers
where creditLimit <> 0
group by country
order by avg(creditLimit) desc;
--
select salesRepEmployeeNumber, count(*)
from customers
group by salesRepEmployeeNumber
order by count(*) desc;
--
select productLine, count(*)
from products
group by productLine
order by count(*) desc;
--
select * from products;
--
select productScale, productLine, count(*)
from products
group by 1,2
order by 1 asc, 3 desc;
--
select min(orderDate) as "Earliest Order", max(orderDate) as "Latest Order"
from orders
 limit 10;
 --
select customerNumber, orderDate , count(*) as "Number of Orders"
from orders
where orderDate between '2003-03-01' and '2003-03-31'
group by customerNumber,2
order by count(*) asc;
--
select count(*) from orders;
select count(*) from orderdetails;
--
select  count(*) 
 from orders o
 left join orderdetails od
 on od.orderNumber = o.orderNumber;
 --
 select e.employeeNumber, c.customerNumber
 from employees e
 inner join customers c
 on c.salesRepEmployeeNumber = e.employeeNumber;
 --
 select c.customerNumber, e.employeeNumber, c.state as "Customer State", o.state as "Employees State"
 from customers c
 inner join employees e
 on c.salesRepEmployeeNumber = e.employeeNumber
 inner join offices o
 on e.officeCode = o.officeCode
 where o.state = c.state;
 --
 select productName, productCode, productLine, max(MSRP) as "Maximum Price"
 from products
 group by 1,2,3;
 --
 select p.productLine, p.productCode, p.productName, p.MSRP
 from products p
 inner join
 (select productLine, max(MSRP) as maxprice 
 from products group by productLine) as maxi
 on p.MSRP = maxi.maxprice
 and p.productLine = maxi.productLine;
 --
 select p.productName, p.MSRP, (select avg(MSRP) from products p3) as AVGP
 from products p
where p.MSRP >  (select avg(MSRP) from products p2 where p2.productCode = p.productCode);