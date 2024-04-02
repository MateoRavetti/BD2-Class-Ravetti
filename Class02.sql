CREATE DATABASE imdb;
USE imdb;

CREATE TABLE film (
  film_id INT NOT NULL AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  release_year INT NOT NULL,
  PRIMARY KEY (film_id)
);

CREATE TABLE actor (
  actor_id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  PRIMARY KEY (actor_id)
);

CREATE TABLE film_actor (
  actor_id INT NOT NULL,
  film_id INT NOT NULL,
  PRIMARY KEY (actor_id, film_id)
);

ALTER TABLE film ADD last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE actor ADD last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE film_actor ADD FOREIGN KEY (actor_id) REFERENCES actor(actor_id);
ALTER TABLE film_actor ADD FOREIGN KEY (film_id) REFERENCES film(film_id);

