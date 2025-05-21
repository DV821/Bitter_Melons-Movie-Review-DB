DELIMITER //

CREATE PROCEDURE master_table_insertions()

BEGIN

insert into ratings (rating, verdict, category) values ('HoneyDew', 'Positive', 'Critics');
insert into ratings (rating, verdict, category) values ('Sweet', 'Positive', 'Audience');
insert into ratings (rating, verdict, category) values ("HoneyDon't", 'Negative', 'Critics');
insert into ratings (rating, verdict, category) values ('Sour', 'Negative', 'Audience');

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Insertion in Ratings Table Completed'));

insert into publishers (publisher_name)
(select distinct ifnull(publisher_name, ' ') from rotten_tomatoes_critic_reviews
where publisher_name is not null);
insert into publishers (publisher_id, publisher_name) values (-999, ' ');

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Insertion in Publishers Table Completed'));

insert into critics (critic_name, top_critic)
(select distinct ifnull(critic_name, ' '), ifnull(top_critic,0) from rotten_tomatoes_critic_reviews
where critic_name is not null);
insert into critics (critic_id, critic_name, top_critic) values (-999, ' ', false);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Insertion in Critics Table Completed'));

insert into authors (authors)
(select distinct ifnull(authors,' ') from rotten_tomatoes_movies 
	where authors is not null);
insert into authors (authors_id, authors) values (-999, ' ');

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Insertion in Authors Table Completed'));

insert into directors (directors)
(select distinct ifnull(directors,' ') from rotten_tomatoes_movies
	where directors is not null);
insert into directors (directors_id, directors) values (-999, ' ');

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Insertion in Directors Table Completed'));

insert into genres (genres)
(select distinct ifnull(genres,' ') from rotten_tomatoes_movies
	where genres is not null);
insert into genres (genres_id, genres) values (-999, ' ');

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Insertion in Genres Table Completed'));

insert into actors (actors)
(select distinct ifnull(actors,' ') from rotten_tomatoes_movies
	where actors is not null);
insert into actors (actors_id, actors) values (-999, ' ');

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Insertion in Actors Table Completed'));

insert into age_rating (rating)
(select distinct ifnull(content_rating,' ') from rotten_tomatoes_movies
	where content_rating is not null);
insert into age_rating (rating_id, rating) values (-999, ' ');

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Insertion in Age Rating Table Completed'));

insert into production (production_company)
(select distinct ifnull(production_company,' ') from rotten_tomatoes_movies
	where content_rating is not null);
insert into production (production_id, production_company) values (-999, ' ');

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Insertion in Production Table Completed'));

insert into movies(movie_link, movie_title, movie_desc)
(select ifnull(rotten_tomatoes_link, ' '), ifnull(movie_title , ' '), ifnull( movie_info, ' ')
from rotten_tomatoes_movies);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Insertion in Movies Table Completed'));

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Procedure Call For Master Table Insertions Completed.'));

END //

DELIMITER ;