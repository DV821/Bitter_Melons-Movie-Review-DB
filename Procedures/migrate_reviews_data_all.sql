DROP PROCEDURE IF EXISTS migrate_reviews_data_all;

DELIMITER //

CREATE PROCEDURE migrate_reviews_data_all(a_batch INT, a_limit INT)
BEGIN
    DECLARE remaining INT DEFAULT 1;

    -- Loop as long as there are records to migrate
    WHILE remaining > 0 DO

        -- Call your 100-row procedure
        CALL migrate_reviews_data(a_batch, a_limit);

        -- Recalculate how many are left
        SELECT COUNT(*) INTO remaining
        FROM rotten_tomatoes_critic_reviews
        WHERE is_migrated = 0 AND batch = a_batch;

    END WHILE;

    -- Final log
    INSERT INTO migration_logs (log_message)
    VALUES (CONCAT('Full review migration completed for [BATCH]: ', a_batch));
END //

DELIMITER ;
