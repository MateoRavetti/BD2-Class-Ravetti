Use sakila;


# Ejercicio 1: Insertar un nuevo empleado con email nulo
INSERT INTO employees (employeeNumber, lastName, firstName, extension, email, officeCode, jobTitle)
VALUES (1037, 'Ravetti', 'Mateo', 'x1234', NULL, '2', 'Manager');
# El intento de insertar un valor nulo en el campo de email no es permitido si está definido como NOT NULL.

# Ejercicio 2: Actualizar el número de empleado
UPDATE employees
SET employeeNumber = employeeNumber - 20;
# Esto reduce en 20 el valor del campo employeeNumber en todas las filas.

UPDATE employees
SET employeeNumber = employeeNumber + 20;
# Al intentar revertir el cambio anterior sumando 20, puede ocurrir un conflicto de clave primaria
# si algún valor de employeeNumber ya existe en la tabla. Esto viola la restricción de unicidad.

# Ejercicio 3: Añadir columna de edad con restricción de valores permitidos
ALTER TABLE employees
    ADD age TINYINT UNSIGNED CHECK (age >= 16 AND age <= 70);
# Se agrega la columna de edad con una restricción que solo permite valores entre 16 y 70 años.

# Ejercicio 4: Integridad referencial entre tablas film, actor, y film_actor
# La tabla film almacena información sobre películas, mientras que la tabla actor guarda datos de los actores.
# La tabla film_actor sirve como tabla de relación, conectando películas con actores. 
# Esto se debe a la naturaleza de la relación muchos-a-muchos, donde una película puede tener múltiples actores,
# y un actor puede participar en varias películas.

#Ejercicio 5: Crear columnas para registrar la última actualización y usuario, con triggers
ALTER TABLE employees
    ADD lastModified DATETIME;
ALTER TABLE employees
    ADD lastModifiedBy VARCHAR(100);

CREATE TRIGGER before_employee_update
    BEFORE UPDATE
    ON employees
    FOR EACH ROW
BEGIN
    SET NEW.lastModified = NOW(),
        NEW.lastModifiedBy = USER();
END;

CREATE TRIGGER before_employee_insert
    BEFORE INSERT
    ON employees
    FOR EACH ROW
BEGIN
    SET NEW.lastModified = NOW(),
        NEW.lastModifiedBy = USER();
END;

-- Ejercicio 6: Análisis de triggers relacionados con la tabla film_text

# Trigger que establece la fecha de creación al insertar un nuevo cliente.
CREATE TRIGGER set_customer_creation_date
    BEFORE INSERT
    ON customer
    FOR EACH ROW
    SET NEW.creationDate = NOW();

# Trigger que borra las entradas correspondientes en film_text cuando se elimina una película.
CREATE TRIGGER after_film_delete
    AFTER DELETE
    ON film
    FOR EACH ROW
BEGIN
    DELETE FROM film_text WHERE film_id = OLD.film_id;
END;

-- Trigger que inserta datos en film_text después de agregar una nueva película.
CREATE TRIGGER after_film_insert
    AFTER INSERT
    ON film
    FOR EACH ROW
BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (NEW.film_id, NEW.title, NEW.description);
END;

# Trigger que actualiza film_text cuando se modifican datos en la tabla film.
CREATE TRIGGER after_film_update
    AFTER UPDATE
    ON film
    FOR EACH ROW
BEGIN
    IF (OLD.title != NEW.title) OR (OLD.description != NEW.description) OR (OLD.film_id != NEW.film_id) THEN
        UPDATE film_text
            SET title = NEW.title,
                description = NEW.description,
                film_id = NEW.film_id
        WHERE film_id = OLD.film_id;
    END IF;
END;

#Trigger que establece la fecha de pago al insertar un nuevo pago.
CREATE TRIGGER set_payment_date
    BEFORE INSERT
    ON payment
    FOR EACH ROW
    SET NEW.paymentDate = NOW();
