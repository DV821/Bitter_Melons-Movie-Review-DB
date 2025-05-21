DELIMITER //

CREATE FUNCTION update_melon_certification(sweetness_index INT, target varchar(100))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE rating INT;
    
    SET rating = CASE WHEN sweetness_index >= 60 THEN
        (SELECT rating_id from bitter_melon.ratings where verdict = 'Positive' and upper(category) = upper(target))
    ELSE 
        (SELECT rating_id from bitter_melon.ratings where verdict = 'Negative' and upper(category) = upper(target))
    END;
    
    RETURN rating;
    
END //

DELIMITER ;