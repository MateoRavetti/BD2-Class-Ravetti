Use sakila;
#get all customers from Argentina
SELECT CONCAT(first_name, ' ', last_name) AS full_name,
       address,
       city
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Argentina';

#Show film title, language, and rating (with full text rating description)
SELECT f.title AS film_title,
       l.name AS language,
       CASE 
           WHEN f.rating = 'G' THEN 'General Audiences'
           WHEN f.rating = 'PG' THEN 'Parental Guidance Suggested'
           WHEN f.rating = 'PG-13' THEN 'Parents Strongly Cautioned'
           WHEN f.rating = 'R' THEN 'Restricted'
           WHEN f.rating = 'NC-17' THEN 'Adults Only'
           ELSE 'Not Rated'
       END AS full_rating
FROM film f
JOIN language l ON f.language_id = l.language_id;

#Show all the films (title and release year) an actor was part of
SELECT f.title AS film_title,
       f.release_year
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE CONCAT(a.first_name, ' ', a.last_name) LIKE CONCAT('%', ?, '%');

#Find all the rentals done in May and June. Show the film title, customer name, and if it was returned or not
SELECT f.title AS film_title,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       CASE
           WHEN r.return_date IS NOT NULL THEN 'Yes'
           ELSE 'No'
       END AS returned
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE MONTH(r.rental_date) IN (5, 6);



#5) Funciones CAST y CONVERT: Diferencias y Ejemplos
#Diferencias:

#La función CONVERT tiene la capacidad adicional de cambiar el conjunto de caracteres de los datos, lo cual es útil para adaptar datos a diferentes codificaciones. Por otro lado, CAST se utiliza principalmente para cambiar el tipo de datos de una expresión, pero no maneja la conversión de conjuntos de caracteres.
#Ejemplos en la base de datos Sakila:

#CAST: Convierte un campo de tipo DATETIME a DATE para mostrar solo la parte de la fecha.

#SELECT CAST(last_update AS DATE) AS fecha_solo
#FROM rental;
#CONVERT: Cambia el conjunto de caracteres de un campo VARCHAR a latin1.


#SELECT actor_id, first_name, CONVERT(first_name USING latin1) AS nombre_latin1
#FROM actor
#LIMIT 10;
#6) Funciones NVL, ISNULL, IFNULL, COALESCE: Explicación y Ejemplos
#Las funciones como NVL, ISNULL, IFNULL y COALESCE se utilizan para proporcionar un valor alternativo cuando una expresión resulta ser NULL. Estas funciones se encuentran en diferentes sistemas de gestión de bases de datos, lo que las hace más específicas para cada entorno. En MySQL, solo están disponibles IFNULL y COALESCE, mientras que NVL e ISNULL son de Oracle y SQL Server, respectivamente.

#IFNULL: Devuelve un valor alternativo si el campo address2 es NULL.


#SELECT address_id, address, IFNULL(address2, 'Valor alternativo')
#FROM address
#LIMIT 10;
#COALESCE: Similar a IFNULL, pero puede aceptar múltiples argumentos y devuelve el primero que no sea NULL.


#SELECT address_id, address, COALESCE(address2, 'Valor alternativo')
#FROM address
#LIMIT 10;