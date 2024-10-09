Use sakila;

SELECT *
FROM address AS a
         INNER JOIN city c ON a.city_id = c.city_id
         INNER JOIN country co ON c.country_id = co.country_id
WHERE postal_code IN ('72433', '25910', '93884', '55950'); -- 11ms


SELECT *
FROM address AS a
         INNER JOIN city c ON a.city_id = c.city_id
         INNER JOIN country co ON c.country_id = co.country_id
WHERE postal_code NOT IN ('72433', '25910', '93884', '55950'); -- 84ms

CREATE INDEX idx_postal_code ON address (postal_code); -- 13ms

SELECT *
FROM address AS a
         INNER JOIN city c ON a.city_id = c.city_id
         INNER JOIN country co ON c.country_id = co.country_id
WHERE postal_code IN ('72433', '25910', '93884', '55950'); -- 55ms


SELECT *
FROM address AS a
         INNER JOIN city c ON a.city_id = c.city_id
         INNER JOIN country co ON c.country_id = co.country_id
WHERE postal_code NOT IN ('72433', '25910', '93884', '55950');
-- 99ms

/* Con el indice, lo que tiene que hacer el motor es encontrar esos valores en el indice
   para obtener las direcciones de las filas de la tabla que contienen las filas con el valor especificado
   en el where. El where busca en el indice, quedan las direcciones de las filas y con esas se buscan en la tabla y
   se devuelven. */

SELECT *
FROM actor
WHERE first_name = 'Mateo';

SELECT *
FROM actor
WHERE last_name = 'Ravetti';

/* La diferencia es practicamente imperceptible en el tiempo de ejecucion pero existe un indice para el apellido */


ALTER TABLE film
    ADD FULLTEXT (description);

SELECT *
FROM film
WHERE description LIKE '%action%';


SELECT *
FROM film
WHERE MATCH(description) AGAINST('action');

#"En términos de rendimiento, en esta base de datos la mejora es prácticamente imperceptible. Un índice FULLTEXT está optimizado para gestionar de manera eficiente consultas en lenguaje natural, lo que permite buscar palabras o frases dentro de las columnas de texto de una tabla."