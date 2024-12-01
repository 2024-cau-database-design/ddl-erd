DELIMITER $$

CREATE PROCEDURE create_pickup_transaction (
    IN p_pickup_at DATE,
    IN p_restaurant_id INT,
    IN p_customer_id INT,
    IN p_reservation_fee INT,
    IN p_total_price INT,
    IN p_menu_json JSON,
    IN p_payment_method VARCHAR(30),
    IN p_payment_amount INT,
    IN p_transaction_date DATE
)
BEGIN
    DECLARE v_booking_id INT;
    DECLARE v_order_id INT;
    DECLARE v_payment_id INT;

    -- Step 1: Create booking, pickup, and pickup history
    CALL create_booking_and_pickup(p_pickup_at, p_restaurant_id, p_customer_id);
    SELECT booking_id INTO v_booking_id;

    -- Step 2: Create order and order items
    CALL create_order_and_items(v_booking_id, p_total_price, p_restaurant_id, p_customer_id, p_reservation_fee, p_menu_json);
    SELECT order_id INTO v_order_id;

    -- Step 3: Create payment and payment history
    CALL create_payment_and_history(v_order_id, p_payment_amount, p_payment_method, p_transaction_date);
    SELECT payment_id INTO v_payment_id;
END$$

DELIMITER ;
