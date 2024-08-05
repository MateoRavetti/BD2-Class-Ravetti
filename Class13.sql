#Add a new customer

INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date)
VALUES (
    1, 
    'Mateo', 
    'Ravetti', 
    'mateo.ravetti@gmail.com', 
    (SELECT address_id FROM address WHERE country_id = (SELECT country_id FROM country WHERE country = 'United States') ORDER BY address_id DESC LIMIT 1), 
    1, 
    NOW()
);


#Add a new rental
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
    NOW(),
    (SELECT inventory_id FROM inventory WHERE film_id = (SELECT film_id FROM film WHERE title = 'film title') ORDER BY inventory_id DESC LIMIT 1),
    (SELECT customer_id FROM customer ORDER BY customer_id DESC LIMIT 1),
    (SELECT staff_id FROM staff WHERE store_id = 2 ORDER BY staff_id LIMIT 1)
);

#Update film year based on the rating
UPDATE film
SET release_year = CASE 
    WHEN rating = 'G' THEN 2001
    WHEN rating = 'PG' THEN 2002
    WHEN rating = 'PG-13' THEN 2003
    WHEN rating = 'R' THEN 2004
    ELSE release_year
END;

#Return a film
UPDATE rental
SET return_date = NOW()
WHERE rental_id = (
    SELECT rental_id 
    FROM rental 
    WHERE return_date IS NULL 
    ORDER BY rental_date DESC 
    LIMIT 1
);



#Attempting to delete a film
DELETE FROM film WHERE title = 'film title';


#Delete from film_text
DELETE FROM film_text WHERE film_id = (SELECT film_id FROM film WHERE title = 'film title');

#Delete from film_category
DELETE FROM film_category WHERE film_id = (SELECT film_id FROM film WHERE title = 'film title');

#Delete from film_actor
DELETE FROM film_actor WHERE film_id = (SELECT film_id FROM film WHERE title = 'film title');

#Delete from inventory
DELETE FROM inventory WHERE film_id = (SELECT film_id FROM film WHERE title = 'film title');

#Delete from film
DELETE FROM film WHERE title = 'film title';


# Rent a film

#Find an available inventory id
SET available_inventory_id = (
    SELECT inventory_id 
    FROM inventory 
    WHERE film_id = (
        SELECT film_id 
        FROM film 
        ORDER BY film_id DESC 
        LIMIT 1
    ) 
    AND inventory_id NOT IN (
        SELECT inventory_id 
        FROM rental 
        WHERE return_date IS NULL
    ) 
    LIMIT 1
);

#Select the latest customer
SET latest_customer_id = (
    SELECT customer_id 
    FROM customer 
    ORDER BY customer_id DESC 
    LIMIT 1
);

#Select any staff from Store 2
SET any_staff_id = (
    SELECT staff_id 
    FROM staff 
    WHERE store_id = 2 
    ORDER BY staff_id 
    LIMIT 1
);

#Add a rental entry
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
    NOW(),
    available_inventory_id,
    latest_customer_id,
    any_staff_id
);

#Add a payment entry
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (
    latest_customer_id,
    any_staff_id,
    (SELECT rental_id FROM rental WHERE inventory_id = available_inventory_id ORDER BY rental_date DESC LIMIT 1),
    (SELECT rental_rate FROM film WHERE film_id = (SELECT film_id FROM inventory WHERE inventory_id = available_inventory_id)),
    NOW()
);
