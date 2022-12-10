use sakila;
select * from address;
select * from city;
select * from country;
select * from customer;
select * from staff;
select * from rental;
select * from film;

#1.

#select film_id, language_id,length,rating,special_features,rental_rate,stf.store_id,city_id,country_id,actor_id,category_id from rental r inner join inventory i using (inventory_id) inner join film f using (film_id) inner join film_actor fa using (film_id) inner join film_category fc using (film_id) inner join staff stf using (staff_id) inner join address addr using (address_id) inner join city cty using (city_id) inner join country cntry using (country_id) where YEAR(rental_date)=2005;
select film_id, language_id,length,rating,special_features,rental_rate,stf.store_id,city_id,country_id,category_id from rental r inner join inventory i using (inventory_id) inner join film f using (film_id) inner join film_category fc using (film_id) inner join staff stf using (staff_id) inner join address addr using (address_id) inner join city cty using (city_id) inner join country cntry using (country_id) where YEAR(rental_date)=2005;

select film_id, language_id,length,rating,special_features,rental_rate,rental_duration,replacement_cost from rental r inner join inventory i using (inventory_id) inner join film f using (film_id) inner join film_category fc using (film_id) where YEAR(rental_date)=2005 group by film_id, language_id,length,rating,special_features,rental_rate,category_id having count(*)>1;

#2.
select film_id, max(rented_may_2005) as rented_may_2005 from (
select film_id,
CASE
WHEN  MONTH(RENTAL_DATE)=5 AND YEAR(RENTAL_DATE)=2005 then 1
else 0
END AS 'rented_may_2005'
from rental r inner join inventory i using (inventory_id) inner join film f using (film_id)) as rented_may_2005
group by film_id;

#3.
select * from
(select film_id, language_id,length,rating,special_features,rental_rate,rental_duration,replacement_cost from rental r inner join inventory i using (inventory_id) inner join film f using (film_id) inner join film_category fc using (film_id) where YEAR(rental_date)=2005 group by film_id, language_id,length,rating,special_features,rental_rate,category_id having count(*)>1) as query_1
inner join
(select film_id, max(rented_may_2005) as rented_may_2005 from (
select film_id,
CASE
WHEN  MONTH(RENTAL_DATE)=5 AND YEAR(RENTAL_DATE)=2005 then 1
else 0
END AS 'rented_may_2005'
from rental r inner join inventory i using (inventory_id) inner join film f using (film_id)) as rented_may_2005
group by film_id) as query_2
using (film_id);


SELECT *
FROM   (SELECT film_id,
               language_id,
               length,
               rating,
               special_features,
               rental_rate,
               rental_duration,
               replacement_cost
        FROM   rental r
               INNER JOIN inventory i using (inventory_id)
               INNER JOIN film f using (film_id)
               INNER JOIN film_category fc using (film_id)
        WHERE  Year(rental_date) = 2005
        GROUP  BY film_id,
                  language_id,
                  length,
                  rating,
                  special_features,
                  rental_rate,
                  category_id
        HAVING Count(*) > 1) AS query_1
       INNER JOIN (SELECT film_id,
                          Max(rented_may_2005) AS rented_may_2005
                   FROM   (SELECT film_id,
                                  CASE
                                    WHEN Month(rental_date) = 5
                                         AND Year(rental_date) = 2005 THEN 1
                                    ELSE 0
                                  END AS 'rented_may_2005'
                           FROM   rental r
                                  INNER JOIN inventory i using (inventory_id)
                                  INNER JOIN film f using (film_id)) AS
                          rented_may_2005
                   GROUP  BY film_id) AS query_2 using (film_id); 



