USE sakila;
DROP PROCEDURE IF EXISTS contarNumeroDePeliculas;
#Write a function that returns the amount of copies of a film in a store in sakila-db. Pass either the film id or the film name and the store id.
DELIMITER //
CREATE PROCEDURE contarNumeroDePeliculas(IN tiendaId INT, IN peliculaId INT)
BEGIN
    SELECT f.title, COUNT(inv.inventory_id) AS cantidad_de_peliculas, inv.store_id
    FROM film f
    INNER JOIN inventory inv ON inv.film_id = f.film_id
    WHERE f.film_id = peliculaId
    AND inv.store_id = tiendaId
    GROUP BY f.title, inv.store_id;
END //
DELIMITER ;

CALL contarNumeroDePeliculas(2, 5);

#Write a stored procedure with an output parameter that contains a list of customer first and last names separated by ";", that live in a certain country. You pass the country it gives you the list of people living there. USE A CURSOR, do not use any aggregation function (ike CONTCAT_WS).
DROP PROCEDURE IF EXISTS obtenerListaDeClientes;
DELIMITER //
CREATE PROCEDURE obtenerListaDeClientes(IN nombrePais VARCHAR(100), OUT listaClientes VARCHAR(255))
BEGIN
    DECLARE terminado INT DEFAULT 0;
    DECLARE clienteSeleccionado VARCHAR(255) DEFAULT "";
    DECLARE cursorClientes CURSOR FOR 
        SELECT CONCAT(c.first_name, " ", c.last_name) AS cliente 
        FROM customer c
        INNER JOIN address ad ON ad.address_id = c.address_id
        INNER JOIN city ci ON ci.city_id = ad.city_id
        INNER JOIN country co ON co.country_id = ci.country_id
        WHERE co.country = nombrePais;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET terminado = 1;

    SET listaClientes = "";
    OPEN cursorClientes;
    agregarClientesACadena: LOOP
        FETCH cursorClientes INTO clienteSeleccionado;

        IF terminado = 1 THEN
            LEAVE agregarClientesACadena;
        END IF;

        IF clienteSeleccionado IS NOT NULL THEN
            SET listaClientes = CONCAT(listaClientes, ";", clienteSeleccionado);
        END IF;
    END LOOP agregarClientesACadena;
    
    CLOSE cursorClientes;
    SELECT listaClientes;
END //
DELIMITER ;

SET @listaClientes = "";
CALL obtenerListaDeClientes("", @listaClientes);

SELECT @listaClientes;

SELECT inventory_in_stock(5, 2); # Verifica si la película con id 5 está en stock en la tienda con id 2.

CALL film_in_stock(5, 2, @stockDisponible); #Devuelve el número de copias de la película con id 5 disponibles en la tienda con id 2.
SELECT @stockDisponible; #Muestra el resultado del stock disponible.
