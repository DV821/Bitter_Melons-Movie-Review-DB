DELIMITER //

CREATE FUNCTION calculate_sweetness_index(total_count INT, sweet_count INT)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    DECLARE sweetness DOUBLE DEFAULT 0.0;

    IF total_count > 0 THEN
        SET sweetness = round(sweet_count / total_count, 2) * 100;
    ELSE
        SET sweetness = 0.0;
    END IF;

    RETURN sweetness;
END //

DELIMITER ;