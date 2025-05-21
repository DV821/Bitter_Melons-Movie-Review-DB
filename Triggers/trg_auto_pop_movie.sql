DELIMITER //

CREATE TRIGGER trg_smart_auto_populate_movie
AFTER INSERT ON movies
FOR EACH ROW
BEGIN
    DECLARE v_directors_id INT DEFAULT -999;
    DECLARE v_authors_id INT DEFAULT -999;
    DECLARE v_production_id INT DEFAULT -999;
    DECLARE v_actors_id INT DEFAULT -999;
    DECLARE v_genres_id INT DEFAULT -999;
    DECLARE v_rating_id INT DEFAULT -999;

    -- Example: Assume movie form collected director, author, production_company, actors, genres, rating
    -- If not, this would be NULL or you set to default
    
    -- 1. Check or Insert Director
    IF (NEW.movie_director IS NOT NULL) THEN
        SET v_directors_id = (SELECT directors_id FROM directors WHERE directors = NEW.movie_director LIMIT 1);
        IF (v_directors_id = -999) THEN
            INSERT INTO directors (directors) VALUES (NEW.movie_director);
            SET v_directors_id = (SELECT directors_id FROM directors WHERE directors = NEW.movie_director LIMIT 1);
        END IF;
    END IF;

    -- 2. Check or Insert Author
    IF (NEW.movie_author IS NOT NULL) THEN
        SET v_authors_id = (SELECT authors_id FROM authors WHERE authors = NEW.movie_author LIMIT 1);
        IF (v_authors_id = -999) THEN
            INSERT INTO authors (authors) VALUES (NEW.movie_author);
            SET v_authors_id = (SELECT authors_id FROM authors WHERE authors = NEW.movie_author LIMIT 1);
        END IF;
    END IF;

    -- 3. Check or Insert Production
    IF (NEW.production_company IS NOT NULL) THEN
        SET v_production_id = (SELECT production_id FROM production WHERE production_company = NEW.production_company LIMIT 1);
        IF (v_production_id = -999) THEN
            INSERT INTO production (production_company) VALUES (NEW.production_company);
            SET v_production_id = LAST_INSERT_ID();
        END IF;
    END IF;

    -- 4. Check or Insert Actors
    IF (NEW.movie_actors IS NOT NULL) THEN
        SET v_actors_id = (SELECT actors_id FROM actors WHERE actors = NEW.movie_actors LIMIT 1);
        IF (v_actors_id = -999) THEN
            INSERT INTO actors (actors) VALUES (NEW.movie_actors);
            SET v_actors_id = LAST_INSERT_ID();
        END IF;
    END IF;

    -- 5. Check or Insert Genres
    IF (NEW.movie_genres IS NOT NULL) THEN
        SET v_genres_id = (SELECT genres_id FROM genres WHERE genres = NEW.movie_genres LIMIT 1);
        IF (v_genres_id = -999) THEN
            INSERT INTO genres (genres) VALUES (NEW.movie_genres);
            SET v_genres_id = LAST_INSERT_ID();
        END IF;
    END IF;

    -- 6. Check or Insert Rating
    IF (NEW.movie_age_rating IS NOT NULL) THEN
        SET v_rating_id = (SELECT rating_id FROM age_rating WHERE rating = NEW.movie_age_rating LIMIT 1);
        IF (v_rating_id = -999) THEN
            INSERT INTO age_rating (rating) VALUES (NEW.movie_age_rating);
            SET v_rating_id = LAST_INSERT_ID();
        END IF;
    END IF;

    -- 7. Insert into movie_info using all resolved IDs
    INSERT INTO movie_info (
        movies_id, directors_id, authors_id, production_id, actors_id, rating_id, genres_id,
        original_release_dt, streaming_release_dt, runtime
    )
    VALUES (
        NEW.movies_id,
        COALESCE(v_directors_id, -999),
        COALESCE(v_authors_id, -999),
        COALESCE(v_production_id, -999),
        COALESCE(v_actors_id, -999),
        COALESCE(v_rating_id, -999),
        COALESCE(v_genres_id, -999),
        'Not Provided',
        'Not Provided',
        0
    );

    -- 8. Insert default blank audience_ratings
    INSERT INTO audience_ratings (
        movies_id, audience_count, sweet_count, sour_count, sweetness_index, melon_certification
    )
    VALUES (
        NEW.movies_id,
        0, 0, 0, 0, 'HoneyDont'
    );

    -- 9. Insert default blank critic_ratings
    INSERT INTO critic_ratings (
        movies_id, critics_count, sweet_count, sour_count, top_critics_count, sweetness_index, melon_certification, critics_consensus
    )
    VALUES (
        NEW.movies_id,
        0, 0, 0, 0, 0, 'HoneyDont', 'No consensus yet.'
    );

    -- 10. Insert log
    INSERT INTO migration_logs (log_message)
    VALUES (CONCAT('[SMART AUTO] Movie inserted and linked successfully: ', NEW.movie_title));
END //

DELIMITER ;
