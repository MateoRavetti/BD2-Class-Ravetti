USE sakila;

#Show title and special features of films that are PG-13
SELECT title,special_features FROM film
WHERE rating = 'PG-13';

#Get a list of all the different films duration
SELECT length from film GROUP BY length;

#Show title , rental_rate and replacement_cost of films that have replacement_cost form 20:00 up to 24:00
SELECT title, rental_rate, replacement_cost FROM film WHERE replacement_cost BETWEEN 20.00 and 24.00;

#Show title , category rating of films that have 'Behind the scenes' as special_features
SELECT film.title, category.name, film.rating FROM film
INNER JOIN film_category ON film.film_id = film_category.film_id
INNER JOIN category ON category.category_id = film_category.category_id
WHERE film.special_features LIKE '%Behind the Scenes%';

#Show first name and lastname of actors that acted in 'ZOOLANDER FICTION'
SELECT a.first_name, a.last_name from film_actor f_a
INNER JOIN actor a ON a.actor_id = f_a.actor_id
INNER JOIN film f ON f.film_id = f_a. film_id
WHERE f.title = 'ZOOLANDER FICTION';

#Show the address , city and country of the store with id 1 
SELECT a.address, ci.city, co.country FROM store s
INNER JOIN address a ON a.address = s.address_id
INNER JOIN city ci ON ci.city_id = a.city_id
INNER JOIN country co ON co.country = ci.country_id
WHERE s.store_id = 1;

#Show pair of film titles and rating of films that have the same rating
SELECT f1.title, f2.title, f1.rating FROM film f1, film f2 WHERE f1.rating = f2.rating;

#Get all the films that are available in store id 2 and the manager first/last name of this store 
SELECT f.title, sta.first_name, sta.last_name FROM inventory i 
INNER JOIN store s ON s.store_id = i.store_id
INNER JOIN staff sta ON sta.staff_id = s.manager_staff_id
INNER JOIN film f ON f.film_id = i.film_id
WHERE s.store_id = 2;

