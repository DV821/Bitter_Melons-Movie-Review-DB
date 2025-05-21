DROP PROCEDURE IF EXISTS migrate_movies_data;

DELIMITER //

CREATE PROCEDURE migrate_movies_data()
BEGIN
    -- Declare variables
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_rotten_tomatoes_link TEXT;
    DECLARE v_directors TEXT;
    DECLARE v_authors TEXT;
    DECLARE v_production_company TEXT;
    DECLARE v_actors TEXT;
    DECLARE v_content_rating TEXT;
    DECLARE v_genres TEXT;
    DECLARE v_original_release_date TEXT;
    DECLARE v_streaming_release_date TEXT;
    DECLARE v_runtime DOUBLE;
    
    -- Cursor for movies
    DECLARE cur_movies CURSOR FOR
        SELECT rotten_tomatoes_link, directors, authors, production_company, actors, content_rating, genres, original_release_date, streaming_release_date, runtime
        FROM rotten_tomatoes_movies;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Insert movies data 

    INSERT INTO migration_logs (log_message)
    VALUES ('Cursor for movie_info table generated.');

    -- Open cursor
    OPEN cur_movies;

    read_loop: LOOP
        FETCH cur_movies INTO v_rotten_tomatoes_link, v_directors, v_authors, v_production_company, v_actors, v_content_rating, v_genres, v_original_release_date, v_streaming_release_date, v_runtime;
        
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Separate nested block for exception handling inside each iteration
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            BEGIN
                INSERT INTO migration_logs (log_message)
                VALUES (CONCAT('[ERROR] Insertion failed into movie_info for movie_link: ', v_rotten_tomatoes_link));
            END;

            -- Try to insert movie_info
            INSERT INTO migration_logs (log_message)
            VALUES (CONCAT('Inserting movie_info for movie_link: ', v_rotten_tomatoes_link));

            INSERT INTO movie_info (movies_id, directors_id, authors_id, production_id, actors_id, rating_id, genres_id, original_release_dt, streaming_release_dt, runtime)
            VALUES (
                (SELECT movies_id FROM movies WHERE movie_link = v_rotten_tomatoes_link),
                (SELECT directors_id FROM directors WHERE directors = IFNULL(v_directors, ' ')),
                (SELECT authors_id FROM authors WHERE authors = IFNULL(v_authors, ' ')),
                (SELECT production_id FROM production WHERE production_company = IFNULL(v_production_company, ' ')),
                (SELECT actors_id FROM actors WHERE actors = IFNULL(v_actors, ' ')),
                (SELECT rating_id FROM age_rating WHERE rating = IFNULL(v_content_rating, ' ')),
                (SELECT genres_id FROM genres WHERE genres = IFNULL(v_genres, ' ')),
                IFNULL(v_original_release_date, ' '),
                IFNULL(v_streaming_release_date, ' '),
                v_runtime
            );

            -- Log successful insertion
            INSERT INTO migration_logs (log_message)
            VALUES (CONCAT('Inserted movie_info for movie_link: ', v_rotten_tomatoes_link));
        END;

    END LOOP;

    CLOSE cur_movies;

    INSERT INTO migration_logs (log_message)
    VALUES ('Insertions in movie_info completed.');

    -- Insert audience_ratings and critic_ratings in bulk

    INSERT INTO audience_ratings (movies_id, audience_count, sweet_count, sour_count)
    SELECT 
        (SELECT movies_id FROM movies WHERE movie_link = a.rotten_tomatoes_link),
        IFNULL(audience_count, 0),
        ROUND(IFNULL(audience_count, 0) * IFNULL(audience_rating / 100, 0)),
        IFNULL(audience_count, 0) - ROUND((IFNULL(audience_count, 0) * IFNULL(audience_rating, 0))/100)
    FROM rotten_tomatoes_movies a;

    UPDATE audience_ratings 
    SET sweetness_index = calculate_sweetness_index(audience_count, sweet_count);

    UPDATE audience_ratings 
    SET melon_certification = update_melon_certification(sweetness_index, 'Audience');

    INSERT INTO migration_logs (log_message)
    VALUES ('Insertions in audience_ratings completed.');

    INSERT INTO critic_ratings (movies_id, critics_count, sweet_count, sour_count, top_critics_count, critics_consensus)
    SELECT 
        (SELECT movies_id FROM movies WHERE movie_link = a.rotten_tomatoes_link),
        tomatometer_count,
        tomatometer_fresh_critics_count,
        tomatometer_rotten_critics_count,
        tomatometer_top_critics_count,
        critics_consensus
    FROM rotten_tomatoes_movies a;

    UPDATE critic_ratings 
    SET sweetness_index = calculate_sweetness_index(critics_count, sweet_count);

    UPDATE critic_ratings 
    SET melon_certification = update_melon_certification(sweetness_index, 'Critics');

    INSERT INTO migration_logs (log_message)
    VALUES ('Insertions in movie_info completed.');

    INSERT INTO migration_logs (log_message)
    VALUES (CONCAT('Procedure Call For Movies Info Insertions Completed.'));
END //

DELIMITER ;
