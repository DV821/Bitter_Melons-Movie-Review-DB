DELIMITER //

CREATE FUNCTION get_movie_certification(movieId INT, category VARCHAR(20))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE cert VARCHAR(20);

    IF lower(category) = 'critics' THEN
        SELECT rating  INTO cert FROM ratings where rating_id = 
        (SELECT melon_certification
        FROM critic_ratings
        WHERE movies_id = movieId);
    ELSEIF lower(category) = 'audience' THEN
        SELECT rating  INTO cert FROM ratings where rating_id = 
        (SELECT melon_certification
        FROM audience_ratings
        WHERE movies_id = movieId);
    ELSE
        SET cert = 'Unknown';
    END IF;
    
    RETURN cert;
END //

DELIMITER ;