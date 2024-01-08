use sakila;
--
--
-- 1.	What is the most watched film (number of rentals) by each category?


select ranking.category_id, c.name, ranking.film_id, f.title, ranking.rentals
from(select fcr.category_id, fcr.film_id, rentals,
dense_rank() over (partition by category_Id order by rentals desc) as rankOfFilm
 from(select fc.film_id, fc.category_id, count(*) as rentals
 from rental as r inner join inventory as i on i.inventory_id=r.inventory_id inner join film_category as fc on fc.film_id=i.film_id group by 1,2) as fcr ) as ranking
 inner join category as c on c.category_id=ranking.category_id inner join film as f on f.film_id=ranking.film_id where rankOfFilm=1;


-- 2. What is the total rental amount per category?


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
-- 3.	For each category, list the customer who is the second most renter.


select * from (select c.name, r.customer_id, count(r.rental_id) As "TOTAL RENTALS",
 dense_rank() over (partition by c.name order by count(r.rental_id) desc) AS RANKK
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
--
-- 4.	What is the second most popular movie title?


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
-- 5.	. What are the most popular categories?


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

--
--
-- 6.	. What are the top 10 most rented movies by category?


select dd.film_id, fcr.title, fcr.rankk, fcr.rentals 
from (select a.film_id, a.title, a.rentals, row_number() over (order by rentals desc) rankk from  (select f.film_id, f.title, count(*) as rentals
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
--
-- 7.	 What are the average rental days for each movie?


select f.film_id,f.title, round(avg(datediff(return_date, rental_date))) as "Rental Days"
from rental r
inner join inventory i
on r.inventory_id = i.inventory_id
inner join film f
on f.film_id = i.film_id
group by f.film_id;

--
--
-- 8.	What are the top 10 most rented movies by day of the week?


select fc.film_id as "ID Category",fc.title as "Popular Movies",fc.daynames "Day of the Week",fc.rankk as "Rank Order", fc.rentals as "Number of Rentals" from (select a.film_id,a.title,a.daynames,a.rentals, row_number() over(partition by a.daynames order by rentals desc)as rankk from (select f.film_id,f.title,dayname(r.rental_date)as daynames, count(*) as rentals
from rental r
inner join inventory i
on r.inventory_id = i.inventory_id
inner join film f
on i.film_id = f.film_id
group by 1,2,3
order by 4 desc) a)fc
where fc.rankk in (1,2,3,4,5,6,7,8,9,10)
order by fc.daynames;

--
--
-- 9.	What is the total rental revenue (total amount of all rentals) by day of the week?


select dayname(payment_date), sum(amount)
   from payment
   group by 1;
   
--
--
-- 10.	. What are the most popular days to rent movies?


   select 
     sum(case when dayname(rental_date) ='Tuesday' then 1 else 0 end) as TUESDAY,
     sum(case when dayname(rental_date) ='Wednesday' then 1 else 0 end) as WEDNESDAY,
     sum(case when dayname(rental_date) ='Thursday' then 1 else 0 end) as THURSDAY,
     sum(case when dayname(rental_date) ='Friday' then 1 else 0 end) as FRIDAY,
     sum(case when dayname(rental_date) ='Saturday' then 1 else 0 end) as SATURDAY,
     sum(case when dayname(rental_date) ='Sunday' then 1 else 0 end) as SUNDAY,
     sum(case when dayname(rental_date) ='Monday' then 1 else 0 end) as Monday
     from rental;







