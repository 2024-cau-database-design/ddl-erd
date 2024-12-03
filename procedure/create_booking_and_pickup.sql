DROP PROCEDURE create_booking_and_pickup;

DELIMITER $$

CREATE PROCEDURE create_booking_and_pickup (
    IN p_pickup_at DATETIME,
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
    INSERT INTO pickup (id, created_at, updated_at, is_deleted, restaurant_id, customer_id)
    VALUES (v_booking_id, NOW(), NOW(), 0, p_restaurant_id, p_customer_id);
    SET v_pickup_id = LAST_INSERT_ID();

    -- Step 3: Insert into pickup_history
    INSERT INTO pickup_history (pickup_id, status_id, picked_at, pickup_time_id, pickup_at)
    VALUES (v_pickup_id, 1, NULL, p_pickup_time_id, p_pickup_at);
    SET v_pickup_history_id = LAST_INSERT_ID();

    -- Return the booking ID for further processing
    SELECT * FROM pickup WHERE id = v_pickup_id;
END$$

DELIMITER ;

CALL create_booking_and_pickup(
    '2024-12-05T04:30:00', -- p_pickup_at
    1,            -- p_restaurant_id
    1,          -- p_customer_id
    1             -- p_pickup_time_id
);

SELECT * FROM booking;
SELECT * from customer;
SELECT * FROM pickup;
SELECT * FROM pickup_history;
