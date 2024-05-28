use sakila;
#Find all the film titles that are not in the inventory.
SELECT title FROM film
WHERE NOT EXISTS (SELECT 1 FROM inventory WHERE inventory.film_id = film.film_id);

#Find all the films that are in the inventory but were never rented.
SELECT f.title, i.inventory_id
FROM film f
LEFT JOIN rental r ON f.film_id = r.film_id
LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE r.rental_id IS NULL;

#Generate a report with:customer (first, last) name, store id, film title,when the film was rented and returned for each of these customers order by store_id, customer last_name
SELECT c.first_name, c.last_name, s.store_id, f.title, r.rental_date, r.return_date
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
INNER JOIN store s ON i.store_id = s.store_id
ORDER BY s.store_id, c.last_name;

#Show sales per store (money of rented films)show store's city, country, manager info and total sales (money)(optional) Use concat to show city and country and manager first and last name
SELECT s1.store_id AS 'Tienda',
CONCAT(co.country, ', ', ci.city) AS 'Location', CONCAT(sta.first_name, ' ', sta.last_name) AS 'Manager',
concat("$",(SELECT sum(p.amount) from rental 
INNER JOIN inventory USING(inventory_id) 
INNER JOIN store s2 USING(store_id) 
INNER JOIN payment p USING(rental_id) 
where s1.store_id=s2.store_id)) as total_sales
from store s1
INNER JOIN address USING(address_id)
INNER JOIN city ci USING(city_id)
INNER JOIN country co USING(country_id)
INNER JOIN staff sta ON sta.staff_id = s1.manager_staff_id;

#Which actor has appeared in the most films?
SELECT a.first_name, a.last_name, COUNT(f.film_id) AS film_count
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film f ON fa.film_id = f.film_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY film_count DESC
LIMIT 1;
LIMIT 1;
