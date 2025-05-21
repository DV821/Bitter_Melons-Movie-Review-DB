DELIMITER //

CREATE TRIGGER trg_prevent_blank_or_duplicate_movie_title
BEFORE INSERT ON movies
FOR EACH ROW
BEGIN
    DECLARE existing_count INT DEFAULT 0;

    -- Check for blank title
    IF TRIM(NEW.movie_title) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Movie title cannot be blank.';
    END IF;

    -- Check for duplicate title
    SELECT COUNT(*) INTO existing_count
    FROM movies
    WHERE movie_title = NEW.movie_title;

    IF existing_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = CONCAT('Duplicate movie title: "', NEW.movie_title, '" already exists.');
    END IF;
END //

DELIMITER ;



-- FAIL
-- INSERT INTO bitter_melon.movies (movie_link, movie_title, movie_desc) VALUES ('/m/my_movie', '', 'No title given');

-- FAIL
-- INSERT INTO bitter_melon.movies (movie_link, movie_title, movie_desc) VALUES ('/m/duplicate', 'Avengers', 'Duplicate entry');
