use sakila;
select * from address;
select * from city;
select * from country;
select * from customer;
select * from staff;
select * from rental;
select * from film;

#1. Create a query or queries to extract the information you think may be relevant for building the prediction model. It should include some film features and some rental features. Use the data from 2005.

SELECT film_id,
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
HAVING Count(*) > 1; 

#2. Create a query to get the list of films and a boolean indicating if it was rented last month (August 2005). This would be our target variable.

SELECT film_id,
       Max(rented_may_2005) AS rented_may_2005
FROM   (SELECT film_id,
               CASE
                 WHEN Month(rental_date) = 5
                      AND Year(rental_date) = 2005 THEN 1
                 ELSE 0
               END AS 'rented_may_2005'
        FROM   rental r
               INNER JOIN inventory i using (inventory_id)
               INNER JOIN film f using (film_id)) AS rented_may_2005
GROUP  BY film_id; 

#3. Join #1 and #2 - Query to be used in Jupyter

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