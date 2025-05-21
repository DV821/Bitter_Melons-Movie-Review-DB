DELIMITER //

CREATE PROCEDURE table_creation()
BEGIN

drop table if exists migration_logs;

create table if not exists migration_logs (
log_id int primary key auto_increment,
log_message text,
log_time timestamp default current_timestamp
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Log Table Created'));

create table if not exists publishers (
publisher_id int primary key auto_increment,
publisher_name varchar(50), 
index (publisher_id, publisher_name)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Publishers Table Created'));

create table if not exists critics (
critic_id int primary key auto_increment,
critic_name varchar(50),
top_critic tinyint,
index (critic_id, critic_name)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Critics Table Created'));

create table if not exists authors (
authors_id int primary key auto_increment,
authors varchar(500),
index (authors_id, authors)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Authors Table Created'));

create table if not exists directors (
directors_id int primary key auto_increment,
directors varchar(500),
index (directors_id, directors)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Directors Table Created'));

create table if not exists genres (
genres_id int primary key auto_increment,
genres varchar(200),
index (genres_id, genres)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Genres Table Created'));

create table if not exists actors (
actors_id int primary key auto_increment,
actors text,
index (actors_id)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Actors Table Created'));

create table if not exists age_rating (
rating_id int primary key auto_increment,
rating varchar(50),
index (rating_id, rating)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Age Rating Table Created'));

create table if not exists production (
production_id int primary key auto_increment,
production_company varchar(100),
index (production_id, production_company)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Production Table Created'));

create table if not exists movies (
movies_id int primary key auto_increment,
movie_link varchar(200),
movie_title varchar(200),
movie_desc varchar(1000),
index (movies_id, movie_link)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Movies Table Created'));

create table if not exists movie_info (
info_id int primary key auto_increment,
movies_id int,
directors_id int,
authors_id int,
production_id int,
actors_id int,
rating_id int,
genres_id int,
original_release_dt text,
streaming_release_dt text,
runtime decimal,
foreign key(movies_id) references movies(movies_id),
foreign key(directors_id) references directors(directors_id),
foreign key(authors_id) references authors(authors_id),
foreign key(actors_id) references actors(actors_id),
foreign key(rating_id) references age_rating(rating_id),
foreign key(genres_id) references genres(genres_id),
foreign key(production_id) references production(production_id),
index (movies_id)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Movie Info Table Created'));

create table if not exists reviews (
review_id int primary key auto_increment,
movies_id int,
critic_id int,
publisher_id int,
review_date text,
review_type varchar(20),
review_content text,
foreign key(movies_id) references movies(movies_id),
foreign key(critic_id) references critics(critic_id),
foreign key(publisher_id) references publishers(publisher_id),
index (movies_id)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Reviews Table Created'));

create table if not exists audience_ratings (
movies_id int,
audience_count double,
sweet_count bigint,
sour_count bigint,
sweetness_index double,
melon_certification varchar(20),
foreign key(movies_id) references movies(movies_id),
index (movies_id)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Audience Ratings Table Created'));

create table if not exists critic_ratings (
movies_id int,
critics_count double,
sweet_count bigint,
sour_count bigint,
top_critics_count bigint,
sweetness_index double,
melon_certification varchar(20),
critics_consensus varchar(1000),
foreign key(movies_id) references movies(movies_id),
index (movies_id)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Critic Ratings Table Created'));

create table if not exists ratings (
rating_id int primary key auto_increment,
rating varchar(20),
verdict varchar(10),
category varchar(100),
index(rating_id, rating)
);

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Ratings Table Created'));

INSERT INTO migration_logs (log_message)
VALUES (CONCAT('Procedure Call For Table Creation Completed.'));

END //

DELIMITER ;