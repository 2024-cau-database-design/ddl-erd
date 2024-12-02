DELIMITER $$

CREATE PROCEDURE create_order_and_items (
    IN p_booking_id INT,       -- Booking ID from the booking table
    IN p_restaurant_id INT,    -- Restaurant ID
    IN p_customer_id INT,      -- Customer ID
    IN p_reservation_fee INT,  -- Reservation fee
    IN p_menu_json JSON        -- JSON containing menu items
)
BEGIN
    -- Declare variables
    DECLARE v_order_id INT;    
    DECLARE v_total_price INT DEFAULT 0;
    DECLARE v_menu_id INT;
    DECLARE v_quantity INT;
    DECLARE v_price INT;
    DECLARE done INT DEFAULT 0;

    -- Declare cursor
    DECLARE menu_cursor CURSOR FOR 
        SELECT jt.menu_id, jt.quantity
        FROM JSON_TABLE(
            p_menu_json, '$[*]' COLUMNS (
                menu_id INT PATH '$.menu_id',
                quantity INT PATH '$.quantity'
            )
        ) AS jt;

    -- Declare handlers
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 @p_error_message = MESSAGE_TEXT;
        ROLLBACK;
        SELECT CONCAT('Transaction rolled back due to an error: ', @p_error_message) AS error_message;
    END;

    -- Step 1: Validate `p_booking_id`
    IF (SELECT COUNT(*) FROM booking WHERE id = p_booking_id) = 0 THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Invalid booking_id';
    END IF;

    -- Step 2: Insert into `order`
    INSERT INTO `order` (status_id, created_at, total_price, restaurant_id, customer_id, reservation_fee, booking_id)
    VALUES (1, UNIX_TIMESTAMP(), 0, p_restaurant_id, p_customer_id, p_reservation_fee, p_booking_id);
    SET v_order_id = LAST_INSERT_ID();

    -- Step 3: Process menu JSON
    OPEN menu_cursor;

    menu_loop: LOOP
        FETCH menu_cursor INTO v_menu_id, v_quantity;
        IF done THEN
            LEAVE menu_loop;
        END IF;

        -- Validate menu_id and restaurant_id relationship
        SELECT price INTO v_price
        FROM restaurant_menu
        WHERE id = v_menu_id AND restaurant_id = p_restaurant_id;

        IF v_price IS NULL THEN
            SIGNAL SQLSTATE '45000' 
                SET MESSAGE_TEXT = 'Invalid menu_id or restaurant_id';
        END IF;

        -- Accumulate total price
        SET v_total_price = v_total_price + (v_quantity * v_price);

        -- Insert into order_item
        INSERT INTO order_item (quantity, price, order_id, menu_id)
        VALUES (v_quantity, v_price, v_order_id, v_menu_id);
    END LOOP;

    CLOSE menu_cursor;

    -- Step 4: Update total price in `order`
    UPDATE `order` SET total_price = v_total_price + p_reservation_fee WHERE id = v_order_id;

    -- Return results
    SELECT v_order_id AS order_id, v_total_price AS total_price;
END$$

DELIMITER ;
