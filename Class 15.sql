Use sakila;
#Create a view named list_of_customers, it should contain the following columns:
CREATE VIEW list_of_customers AS
SELECT 
    c.customer_id AS "Customer ID",
    CONCAT(c.first_name, ' ', c.last_name) AS "Customer Full Name",
    a.address AS "Address",
    a.postal_code AS "Zip Code",
    a.phone AS "Phone",
    ci.city AS "City",
    co.country AS "Country",
    IF(c.active = 1, 'active', 'inactive') AS "Status",
    c.store_id AS "Store ID"
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

#Create a view named film_details, it should contain the following columns: film id, title, description, category, price, length, rating, actors - as a string of all the actors separated by comma. Hint use GROUP_CONCAT
CREATE VIEW film_details AS
SELECT 
    f.film_id AS "Film ID",
    f.title AS "Title",
    f.description AS "Description",
    c.name AS "Category",
    f.rental_rate AS "Price",
    f.length AS "Length",
    f.rating AS "Rating",
    GROUP_CONCAT(CONCAT(a.first_name, ' ', a.last_name) ORDER BY a.last_name SEPARATOR ', ') AS "Actors"
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.film_id;

#Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
CREATE VIEW sales_by_film_category AS
SELECT 
    c.name AS "Category",
    COUNT(r.rental_id) AS "Total Rental"
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;
#Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
CREATE VIEW actor_information AS
SELECT 
    a.actor_id AS "Actor ID",
    a.first_name AS "First Name",
    a.last_name AS "Last Name",
    COUNT(fa.film_id) AS "Film Count"
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id;
#Analyze view actor_info, explain the entire query and specially how the sub query works. Be very specific, take some time and decompose each part and give an explanation for each.
CREATE VIEW actor_info AS
SELECT 
    a.actor_id,
    a.first_name,
    a.last_name,
    (SELECT COUNT(fa.film_id) 
     FROM film_actor fa 
     WHERE fa.actor_id = a.actor_id) AS film_count
FROM actor a;

#Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.
#Materialized Views: Description
#A materialized view is a database object that contains the results of a query. Unlike a standard view that dynamically computes its results each time it is queried, a materialized view stores the results physically in the database. This means that the data is precomputed and can be retrieved quickly, improving query performance.

#Key Features:
#Storage: Materialized views store data in a physical format, which allows for faster retrieval compared to regular views.
#Refreshing: They can be refreshed to update the stored data with the latest changes from the underlying tables. Refreshing can be done manually or automatically at defined intervals.
#Snapshot: They represent a snapshot of data at a specific point in time, which can be useful for reporting and analytical queries.
#Why Materialized Views Are Used
#Performance Improvement:
#They significantly reduce the time needed to execute complex queries that involve joins, aggregations, or large datasets by avoiding the need to recompute results each time.
#Resource Efficiency:
#Materialized views minimize the computational load on the database server by storing precomputed results, which can be especially beneficial in read-heavy applications.
#Simplified Querying:
#They can encapsulate complex queries, allowing users to access simplified data structures without having to understand or rewrite the underlying queries.
#Data Consistency for Reporting:
#Materialized views can provide a consistent view of the data for reporting purposes, especially when the underlying data is frequently changing.