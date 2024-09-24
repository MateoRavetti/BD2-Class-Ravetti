#MUST BE DONE WITH ADMIN PRIVILEGES USER
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY 'mateo1234';

#MUST BE DONE WITH ADMIN PRIVILEGES USER
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';

#LOGIN WITH data_analyst USER
USE sakila;

CREATE TABLE testing_table
(
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255)
);
#[42000][1142] CREATE command denied to user 'data_analyst'@'localhost' for table 'testing_table'

UPDATE film
SET title = 'FAST AND FURIOUS'
WHERE film_id = 1;

# MUST BE DONE WITH ADMIN PRIVILEGES USER
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';

# LOGOUT AND LOGIN WITH data_analyst USER

UPDATE film
SET title = 'BATMAN'
WHERE film_id = 1;
# [42000][1142] UPDATE command denied to user 'data_analyst'@'localhost' for table 'film'