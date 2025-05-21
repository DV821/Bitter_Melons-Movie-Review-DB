DROP PROCEDURE IF EXISTS migrate_reviews_data;

DELIMITER //

CREATE PROCEDURE migrate_reviews_data(a_batch int, a_limit INT)
BEGIN
    -- Declare variables for review fields
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_rotten_tomatoes_link TEXT;
    DECLARE v_critic_name TEXT;
    DECLARE v_top_critic TINYINT;
    DECLARE v_publisher_name TEXT;
    DECLARE v_review_date TEXT;
    DECLARE v_review_type TEXT;
    DECLARE v_review_content TEXT;
    DECLARE v_id INT;

    -- Cursor to read from parent table
    DECLARE cur_reviews CURSOR FOR
        SELECT 
            id, rotten_tomatoes_link, critic_name, top_critic, publisher_name, 
            review_date, review_type, review_content
        FROM 
            rotten_tomatoes_critic_reviews where is_migrated = 0 and batch = a_batch limit a_limit;

    -- Handlers
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Open the cursor
    OPEN cur_reviews;

    -- Loop over each review
    read_loop: LOOP
        FETCH cur_reviews INTO 
            v_id, v_rotten_tomatoes_link, v_critic_name, v_top_critic, v_publisher_name, 
            v_review_date, v_review_type, v_review_content;

        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Nested block for handling insertion exceptions separately for each review
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            BEGIN
                -- Log error for failed insertion
                INSERT INTO migration_logs (log_message)
                VALUES (CONCAT('[ERROR] Review insertion failed for movie_link: ', v_rotten_tomatoes_link, ', critic: ', v_critic_name));
            END;

            -- Try inserting into reviews
            INSERT INTO reviews (
                movies_id, critic_id, publisher_id, review_date, review_type, review_content
            )
            VALUES (
                (SELECT movies_id FROM movies WHERE movie_link = v_rotten_tomatoes_link),
                (SELECT critic_id FROM critics WHERE critic_name = IFNULL(v_critic_name, ' ') AND top_critic = IFNULL(v_top_critic, 0)),
                (SELECT publisher_id FROM publishers WHERE publisher_name = IFNULL(v_publisher_name, ' ')),
                v_review_date,
                CASE WHEN lower(v_review_type) = 'fresh' then 1 else 3 END,
                v_review_content
            );

            UPDATE rotten_tomatoes_critic_reviews SET is_migrated = 1 where id = v_id;

            -- Log successful insertion
        --     INSERT INTO migration_logs (log_message)
        --     VALUES (CONCAT('Inserted review for movie_link: ', v_rotten_tomatoes_link, ', critic: ', v_critic_name));
        END;

    END LOOP;

    INSERT INTO migration_logs (log_message)
            VALUES (CONCAT('[BATCH]: ', a_batch ,', Records Migrated: ',(select count(*) from rotten_tomatoes_critic_reviews where is_migrated = 1 and batch = a_batch)));

    CLOSE cur_reviews;

    INSERT INTO migration_logs (log_message)
    VALUES ('Insertions in reviews completed.');

    INSERT INTO migration_logs (log_message)
    VALUES (CONCAT('Procedure Call For Reviews Insertions Completed.'));

END //

DELIMITER ;
