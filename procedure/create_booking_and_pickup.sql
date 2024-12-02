DELIMITER $$

CREATE PROCEDURE create_booking_and_pickup (
    IN p_pickup_at DATE,
    IN p_restaurant_id INT,
    IN p_customer_id INT,
    IN p_pickup_time_id INT
)
BEGIN
    DECLARE v_booking_id INT;
    DECLARE v_pickup_id INT;
    DECLARE v_pickup_history_id INT;

    -- Error handling: rollback on any exception
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
    END;

    -- Step 1: Insert into booking
    INSERT INTO booking (type) VALUES ('pickup');
    SET v_booking_id = LAST_INSERT_ID();

    -- Step 2: Insert into pickup
    -- Ensure p_pickup_time_id exists in pickup_time and p_restaurant_id is valid
    IF (SELECT COUNT(*) FROM pickup_time WHERE id = p_pickup_time_id AND restaurant_id = p_restaurant_id) = 0 THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Invalid pickup_time_id or restaurant_id';
    END IF;

    INSERT INTO pickup (id, pickup_at, restaurant_id, pickup_time_id)
    VALUES (v_booking_id, p_pickup_at, p_restaurant_id, p_pickup_time_id);
    SET v_pickup_id = LAST_INSERT_ID();

    -- Step 3: Insert into pickup_history
    INSERT INTO pickup_history (pickup_id, status_id, picked_at)
    VALUES (v_pickup_id, 1, NOW());
    SET v_pickup_history_id = LAST_INSERT_ID();

    -- Return the booking ID for further processing
    SELECT v_booking_id AS booking_id, v_pickup_id AS pickup_id;
END$$

DELIMITER ;

CALL create_booking_and_pickup(
    '2024-12-05', -- p_pickup_at
    1,            -- p_restaurant_id
    1,          -- p_customer_id
    1             -- p_pickup_time_id
);

SELECT * FROM booking;
SELECT * FROM pickup;
SELECT * FROM pickup_history;
