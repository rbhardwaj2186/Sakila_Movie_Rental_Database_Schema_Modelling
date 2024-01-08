use sakila;
-- 1. . What is the most watched film (number of rentals) by each category?
-- SOLN : film_category(film_id)->inventory(* & inventory_id) -> rentals
select * from rentalrental;
select * from category;
select * from film;
--
select category_idrental, film_id, title, (select max(rental_duration) from film) As MOSTWATCHED
from category c
inner join film_category fc
on c.category_id = fc.category_id
inner join film f
on fc.film_id = f.film_id
group by f.name, f.film_id
order by MOSTWATCHED;
--

--
use classicmodels;
--
select orderNumber, count(productCode)
from orderdetails
group by orderNumber;
--
use sakila;
select * from category;
select * from film;
--
select c.name, count(f.title)
from category c
inner join film_category fc
on c.category_id = fc.category_id
inner join film f
on fc.film_id = f.film_id
group by c.name;
--
select * from category;
select * from customer;
select * from rental;
select * from inventory;
select * from film;
-- 2.. What is the total rental amount per category?
select a.name as "Categroy Name", sum(a.amount) as "Total Amount"
from (select c.name, p.amount
from category c
inner join film_category fc
on fc.category_id = c.category_id
inner join film f
on fc.film_id = f.film_id
inner join inventory i
on f.film_id = i.film_id
inner join rental r
on i.inventory_id = r.inventory_id
inner join payment p
on r.rental_id = p.rental_id) a
group by a.name;
--














--
select a.customer_id, a from (
select customer_id, count(rental_id), rank() over (partition by customer_id )
from rental
group by customer_id) a;
 -- 3. For each category, list the customer who is the second most renter
 select * from (select c.name, r.customer_id, count(r.rental_id) As "TOTAL RENTALS",
 rank() over (partition by c.name order by count(r.rental_id) desc) AS RANKK
 from category c
inner join film_category fc
on fc.category_id = c.category_id
inner join film f
on fc.film_id = f.film_id
inner join inventory i
on f.film_id = i.film_id
inner join rental r
on i.inventory_id = r.inventory_id
group by c.name, r.customer_id
order by count(r.rental_id) desc) a
where rankk =2;
--
use sakila;
select * from rental;
select distinct customer_id, staff_id, count(rental_id) over(partition by customer_id)
from rental r;
--
select distinct customer_id, staff_id, (select count(rental_id) from rental r2 where r2.customer_id = r1.customer_id)
from rental r1
order by customer_id,staff_id;
--
select * from payment;
--
select customer_id, staff_id,
count(*) over(partition by staff_id) staff_count,
payment_id,
count(*) over(partition by customer_id) customer_count
from payment p;
--
use sakila;
--
select * from rental;
select * from inventory;
select * from film;
select * from film_category;
select * from category;
--  What is the second most popular movie title?
select * from (select f.title, count(r.rental_id),
rank() over(order by count(r.rental_id) desc) AS RANKMX
from film f
inner join inventory i
on f.film_id = i.film_id
inner join rental r
on i.inventory_id = r.inventory_id
group by f.title
order by count(r.rental_id) desc)a
where RANKMX=2;
--
-- 
select c.category_id, sum(r.rental_id)
from category c
inner join film_category fc
on c.category_id = c.category_id
inner join film f
on fc.film_id = f.film_id
inner join inventory i
on f.film_id = i.film_id
inner join rental r
on i.inventory_id = r.inventory_id
group by c.category_id
order by count(r.rental_id) desc;
--
select * from film_category;
--
use sakila;
-- What are the most popular categories?
select c.category_id as "Category ID", c.name as "Category Name", a.rentals as "Count of Rentals" from (select f.film_id, f.title, count(*) as rentals
from rental r
inner join inventory i
on r.inventory_id = i.inventory_id
inner join film f
on i.film_id = f.film_id
group by 1,2) a
inner join film_category fc
on a.film_id = fc.film_id
inner join category c 
on c.category_id = fc.film_id
group by c.category_id
order by a.rentals desc;



-- What is the most watched film (number of rentals) by each category?
select ranking.category_id, c.name, ranking.film_id, f.title, ranking.rentals
from(select fcr.category_id, fcr.film_id, rentals,
dense_rank() over (partition by category_Id order by rentals desc) as rankOfFilm
 from(select fc.film_id, fc.category_id, count(*) as rentals
 from rental as r inner join inventory as i on i.inventory_id=r.inventory_id inner join film_category as fc on fc.film_id=i.film_id group by 1,2) as fcr ) as ranking
 inner join category as c on c.category_id=ranking.category_id inner join film as f on f.film_id=ranking.film_id where rankOfFilm=1;
 --
 select * from rental;
 select * from inventory;
 select * from film;
--
use sakila;
-- What are the most popular categories?
select b.category_id, b.film_id, b.rentals, b.rnk from (select a.category_id, a.film_id, rentals,
dense_rank() over(partition by category_id order by rentals desc) as rnk
 from (select c.category_id, f.film_id, count(*) as rentals
from rental r inner join inventory i
on r.inventory_id = i.inventory_id
inner join film f
on i.film_id = f.film_id
inner join film_category fc 
on f.film_id = fc.film_id
inner join category c
on fc.category_id = c.category_id
group by 1,2)a) b ;-- redo it understand
--
select * from film;
-- (original What is the most watched film (number of rentals) by each category?
select rankings.category_id, c.name, rankings.film_id, fd.title,  rankings.rentals from (select fcr.category_id, fcr.film_id, rentals,
dense_rank() over(partition by category_id order by rentals desc) as rankxx
from (select fc.category_id, f.film_id, count(*) as rentals
from rental r
inner join inventory i
on r.inventory_id = i.inventory_id
inner join film f
on i.film_id = f.film_id
inner join film_category fc
on f.film_id = fc.film_id
group by 1,2)fcr) rankings
inner join category c
on rankings.category_id = c.category_id
inner join film fd
on fd.film_id = rankings.film_id
where rankings.rankxx = 1;
--
-- 5. What are the most popular categories?
select rankings.category_id as "Category ID", c.name as "Category Name",rankings.rentals as "Number of Rentals", rankings.rank_category as "Ranking" from (select fcr.category_id, rentals,
dense_rank() over(order by rentals desc) as rank_category
from (select fc.category_id, count(*) as rentals
from rental r
inner join inventory i
on r.inventory_id = i.inventory_id
inner join film f
on i.film_id = f.film_id
inner join film_category fc
on f.film_id = fc.film_id
group by 1)fcr) rankings
inner join category c
on rankings.category_id = c.category_id
order by rankings.rank_category asc;
--
-- 6.  What are the top 10 most rented movies by category? (REWORK)
select dd.film_id, fcr.title, fcr.rankk, fcr.rentals 
from (select a.film_id, a.title, a.rentals, dense_rank() over (order by rentals desc) rankk from  (select f.film_id, f.title, count(*) as rentals
from rental r
inner join inventory i
on r.inventory_id = i.inventory_id
inner join film f
on f.film_id = i.film_id
group by f.film_id)a ) fcr
inner join film dd
on dd.film_id = fcr.film_id
group by 1
order by rankk asc
limit 10;



--
select * from film;
--
select rankings.category_id, c.name, rankings.film_id, fd.title,  rankings.rentals, rankings.rankxx from (select fcr.category_id, fcr.film_id, rentals,
dense_rank() over(partition by category_id order by rentals desc) as rankxx
from (select fc.category_id, f.film_id, count(*) as rentals
from rental r
inner join inventory i
on r.inventory_id = i.inventory_id
inner join film f
on i.film_id = f.film_id
inner join film_category fc
on f.film_id = fc.film_id
group by 1,2)fcr) rankings
inner join category c
on rankings.category_id = c.category_id
inner join film fd
on fd.film_id = rankings.film_id
where rankings.rankxx  between 1 AND 2
order by rankings.category_id, rankings.film_id, rankings.rentals desc;
--
-- 7.  What are the average rental days for each movie?
select * from rental;
select * from inventory;
select * from film;
select f.film_id, count(*) as rentals
from rental r
inner join inventory i
on i.inventory_id = r.inventory_id
inner join film f
on i.film_id = f.film_id
group by 1;
--
select f.film_id,f.title, round(avg(datediff(return_date, rental_date))) as "Rental Days"
from rental r
inner join inventory i
on r.inventory_id = i.inventory_id
inner join film f
on f.film_id = i.film_id
group by f.film_id;
--
-- 8.What are the top 10 most rented movies by day of the week?
select * from rental;
select * from  (select  

    sum(case when dayname(rental_date) ='Tuesday' then 1 else 0 end) as TUESDAY
     when dayname(rental_date) = 'Monday' then 'Monday'
     when dayname(rental_date) = 'Sunday' then 'Sunday'
     when dayname(rental_date) = 'Saturday' then 'Saturday'
     when dayname(rental_date) = 'Friday' then 'Friday'
     when dayname(rental_date) = 'Thursday' then 'Thursday'
     when dayname(rental_date) = 'Wednesday' then 'Wednesday'
	 when dayname(return_date) ='Tuesday' then 'Tuesday'
	 when dayname(return_date) = 'Monday' then 'Monday'
	 when dayname(return_date) = 'Sunday' then 'Sunday'
	 when dayname(return_date) = 'Saturday' then 'Saturday'
	 when dayname(return_date) = 'Friday' then 'Friday'
	 when dayname(return_date) = 'Thursday' then 'Thursday'
	 when dayname(return_date) = 'Wednesday' then 'Wednesday'
     ELSE 3 
     END as Days
     from rental)a;
     --
	select f.film_id, a.day_rented, a.rentals from (select rental_date, dayname(rental_date) as day_rented,
     return_date, dayname(return_date) as day_returned, count(*) as rentals
     from  rental r
     inner join inventory i
     on r.inventory_id = i.inventory_id) a
     inner join film f
     on f.film_id = a.film_id
     group by a.day_rented;
     --
     select 
     sum(case when dayname(rental_date) ='Tuesday' then 1 else 0 end) as TUESDAY,
     sum(case when dayname(rental_date) ='Wednesday' then 1 else 0 end) as WEDNESDAY,
     sum(case when dayname(rental_date) ='Thursday' then 1 else 0 end) as THURSDAY,
     sum(case when dayname(rental_date) ='Friday' then 1 else 0 end) as FRIDAY,
     sum(case when dayname(rental_date) ='Saturday' then 1 else 0 end) as SATURDAY,
     sum(case when dayname(rental_date) ='Sunday' then 1 else 0 end) as SUNDAY,
     sum(case when dayname(rental_date) ='Monday' then 1 else 0 end) as Monday
     from rental;
     --
     select * from rental;
     --
     select dd.film_id, fcr.title, fcr.rankk, fcr.rentals 
from (select a.film_id, a.title, a.rentals, row_number() over (order by rentals desc ) rankk from  (select f.film_id, f.title,  count(*) as rentals
from rental r
inner join inventory i
on r.inventory_id = i.inventory_id
inner join film f
on f.film_id = i.film_id
group by f.film_id )a ) fcr
inner join film dd
on dd.film_id = fcr.film_id
group by 1
order by rankk asc
limit 10;
     --
   select b.DAYNAMES, count(b.title) from (select a.DAYNAMES, a.film_id, a.title from (select dayname(r.rental_date) as DAYNAMES,f.film_id,f.title, count(*) 
   from rental r
   inner join inventory i
   on i.inventory_id = r.inventory_id
   inner join film f
   on f.film_id = i.film_id
   group by 1,2)a
   group by 1,2)b
   --
   select * from film;
   --
   use sakila;
   --
   select  f.film_id, f.title as Movie, dayname(rental_date) as daynames, count(*) as rentals, 
   rank() over (partition by 
   from rental r
   inner join inventory i
   on r.inventory_id = i.inventory_id
   inner join film f
   on i.film_id = f.film_id;
   -- Q.8 What are the top 10 most rented movies by day of the week?
   select a.daynames, a.title, a.rentals, a.rankk from (select f.film_id, f.title, dayname(rental_date) as daynames, count(*) as rentals,
   rank() over ( order by count(*) desc) as rankk
   from rental r
   inner join inventory i
   on r.inventory_id = i.inventory_id
   inner join film f
   on i.film_id = f.film_id
   group by 1,2,3)a
   where a.rankk between 1 and 10
   group by 1,2,3
   order by a.daynames;
   
   --
   -- Q9. What is the total rental revenue (total amount of all rentals) by day of the week?
   --
   select dayname(payment_date), sum(amount)
   from payment
   group by 1;
   --
   -- Q10. What are the most popular movies by each reward tier?
   --
   select * from category;
   select * from staff;
   select * from customer;
   select * from film;
   select * from rental;
   select * from inventory;
   select * from film_text;
   select * from film_category;
   select * from payment;
   select * from address;
   describe actor;
   

--
select * from rental;
--
--
select a.daynames, a.rentals from (select distinct dayname(rental_date) as daynames, f.film_id, f.title, count(*) as Rentals, rank() over (partition by dayname(rental_date) order by  dayname(rental_date), count(*) desc) rankk 
from rental r
inner join inventory i
on r.inventory_id = i.inventory_id
inner join film f
on i.film_id = f.film_id
group by 1,2)a
where a.rankk in (1,2,3,4,5,6,7,8,9,10)
group by a.daynames, a.rentals;

 