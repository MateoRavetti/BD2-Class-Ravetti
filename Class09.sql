#Get the amount of cities per country in the database. Sort them by country, country_id.
SELECT c.country, c.country_id, COUNT(*) AS city_count
FROM city AS ct
INNER JOIN country AS c ON ct.country_id = c.country_id
GROUP BY c.country, c.country_id
ORDER BY c.country, c.country_id;

#Get the amount of cities per country in the database. Show only the countries with more than 10 cities, order from the highest amount of cities to the lowest
SELECT c.country, c.country_id, COUNT(*) AS city_count
FROM city AS ct
INNER JOIN country AS c ON ct.country_id = c.country_id
GROUP BY c.country, c.country_id
HAVING COUNT(*) > 10
ORDER BY city_count DESC;  

#Generate a report with customer (first, last) name, address, total films rented and the total money spent renting films.Show the ones who spent more money first .
SELECT cu.first_name, cu.last_name, 
       adr.address AS full_address,  -- Use address directly
       COUNT(*) AS total_films_rented,
       SUM(p.amount) AS total_spent
FROM customer cu
INNER JOIN address adr ON cu.address_id = adr.address_id
INNER JOIN rental r ON cu.customer_id = r.customer_id
INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY cu.customer_id, cu.first_name, cu.last_name, adr.address
ORDER BY SUM(p.amount) DESC;

#Which film categories have the larger film duration (comparing average) Order by average in descending order
SELECT c.name,avg(length) AS average_duration  FROM category c
INNER JOIN film_category fc ON fc.category_id= c.category_id
INNER JOIN film f ON f.film_id=fc.film_id
GROUP BY c.name
ORDER BY average_duration DESC;

#Show sales per film rating
SELECT rating, concat(sum(p.amount), ' USD') AS sales FROM film f
INNER JOIN inventory i ON i.film_id = f.film_id
INNER JOIN rental r ON r.inventory_id= i.inventory_id
INNER JOIN payment p ON r.rental_id= p.rental_id
GROUP BY rating
ORDER BY sales DESC;