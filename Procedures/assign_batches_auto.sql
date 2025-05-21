DELIMITER //

CREATE PROCEDURE bitter_melons.assign_batches_auto(IN batch_count INT)
BEGIN
    DECLARE total_rows INT DEFAULT 0;
    DECLARE batch_size INT DEFAULT 0;
    DECLARE current_batch INT DEFAULT 1;

    update rotten_tomatoes_critic_reviews2 set batch = 0 where is_migrated = 0;
    
    -- Get total number of unmigrated reviews
    SELECT COUNT(*) INTO total_rows
    FROM rotten_tomatoes_critic_reviews2
    WHERE is_migrated = 0;

    -- Calculate number of batches needed
    SET batch_size = CEIL(total_rows / batch_count);

    -- Loop through batches and assign
    WHILE current_batch <= batch_count DO

        UPDATE rotten_tomatoes_critic_reviews2
        SET 
            batch = current_batch
        WHERE is_migrated = 0 and batch = 0
        ORDER BY id ASC
        LIMIT batch_size;

        -- Optional logging
        INSERT INTO migration_logs (log_message)
        VALUES (CONCAT('[AUTO BATCHING] Assigned batch ', current_batch, 
                       ' of size ', batch_size));

        SET current_batch = current_batch + 1;
    END WHILE;
END //

DELIMITER ;
