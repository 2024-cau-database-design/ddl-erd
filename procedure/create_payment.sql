DELIMITER $$

CREATE PROCEDURE create_payment_and_history (
    IN p_order_id INT,              -- Order ID
    IN p_payment_amount INT,        -- Payment amount
    IN p_payment_method VARCHAR(30), -- Payment method
    IN p_transaction_at DATETIME        -- Transaction date
)
BEGIN
    DECLARE v_payment_id INT;          -- To store the generated payment ID
    DECLARE v_payment_history_id INT;  -- To store the generated payment history ID
    DECLARE v_payment_status_id INT;   -- To store the payment status ID (e.g., COMPLETE)

    -- Step 1: Validate `p_order_id`
    IF (SELECT COUNT(*) FROM `order` WHERE id = p_order_id) = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Invalid order_id';
    END IF;

    -- Step 2: Insert into payment
    INSERT INTO payment (amount, order_id, method, created_at, updated_at)
    VALUES (p_payment_amount, p_order_id, p_payment_method, NOW(), NOW());
    SET v_payment_id = LAST_INSERT_ID();

    -- Step 3: Get the payment status ID for 'COMPLETE'
    SELECT id INTO v_payment_status_id
    FROM payment_status
    WHERE type = 'COMPLETE'
    LIMIT 1;

    IF v_payment_status_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Payment status "COMPLETE" not found';
    END IF;

    -- Step 4: Insert into payment_history
    INSERT INTO payment_history (status_id, transaction_at, payment_id, created_at, updated_at)
    VALUES (v_payment_status_id, p_transaction_at, v_payment_id, NOW(), NOW());
    SET v_payment_history_id = LAST_INSERT_ID();

    -- Return the generated payment ID and payment history ID
    SELECT v_payment_id AS payment_id, v_payment_history_id AS payment_history_id;
END$$

DELIMITER ;
