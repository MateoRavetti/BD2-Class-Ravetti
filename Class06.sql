use sakila;

#List all the actors that share the last name. Show them in order
SELECT first_name, last_name FROM actor a
WHERE EXISTS (SELECT * FROM actor b WHERE a.last_name = b.last_name AND  a.actor_id <> b.actor_id)
ORDER BY last_name;

#Find actors that don't work in any film
SELECT a1.first_name, a1.last_name FROM film_actor fa
INNER JOIN actor a1 ON a1.actor_id = fa.actor_id
WHERE NOT EXISTS(select * from actor a2 where a1.actor_id = a2.actor_id);

#Find customers that rented only one film
SELECT c.customer_id, c.first_name, c.last_name FROM customer c 
INNER JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id HAVING COUNT(r.rental_id) = 1;

#Find customers that rented more than one film
SELECT c.customer_id, c.first_name, c.last_name FROM customer c 
INNER JOIN rental r ON r.customer_id = c.customer_id
GROUP BY c.customer_id HAVING COUNT(r.rental_id) > 1;

#List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
SELECT a.first_name, a.last_name, group_concat(f.title) FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film f ON fa.film_id = f.film_id
WHERE f.title IN ('BETRAYED REAR','CATCH AMISTAD') GROUP BY a.actor_id;

#List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
SELECT a.first_name, a.last_name, f.title FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'BETRAYED REAR' AND a.actor_id NOT IN (SELECT actor_id FROM film_actor fa INNER JOIN film f ON f.film_id = fa.film_id WHERE f.title = 'CATCH AMISTAD');

#List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
SELECT a.first_name, a.last_name, group_concat(f.title) FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
INNER JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'BETRAYED REAR' AND a.actor_id IN (SELECT actor_id FROM film_actor fa INNER JOIN film f ON f.film_id = fa.film_id WHERE f.title = 'CATCH AMISTAD') GROUP BY a.actor_id;

#List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
SELECT a.first_name, a.last_name FROM actor a 
WHERE a.actor_id NOT IN (SELECT actor_id FROM film_actor fa 
INNER JOIN film f ON fa.film_id = f.film_id 
WHERE f.title = 'BETRAYED REAR') AND actor_id NOT IN (SELECT actor_id FROM film_actor fa INNER JOIN film f ON fa.film_id = f.film_id WHERE f.title = 'CATCH AMISTAD');