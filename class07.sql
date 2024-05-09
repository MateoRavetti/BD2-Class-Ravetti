USE sakila;
#Find the films with less duration, show the title and rating.
SELECT title,rating FROM film
WHERE `length` = (SELECT MIN(`length`)
FROM film);

#Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
SELECT title, rating FROM film
WHERE length = (SELECT DISTINCT length FROM film ORDER BY length ASC LIMIT 1);

#Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.
SELECT c.customer_id, c.first_name, c.last_name, a.address, MIN(p.amount) AS lowest_payment
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN payment p  ON c.customer_id = p.customer_id
GROUP BY  c.customer_id, c.first_name, c.last_name, a.address
HAVING MIN(p.amount) = ANY (SELECT amount FROM payment WHERE customer_id = c.customer_id);

#Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.
SELECT c.customer_id, c.first_name, c.last_name, a.address, 
	MAX(p.amount) AS highest_payment, MIN(p.amount) AS lowest_payment
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, a.address;

