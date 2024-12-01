DELIMITER $$

CREATE PROCEDURE create_payment_and_history (
    IN p_order_id INT,
    IN p_payment_amount INT,
    IN p_payment_method VARCHAR(30),
    IN p_transaction_date DATE
)
BEGIN
    DECLARE v_payment_id INT;
    DECLARE v_payment_history_id INT;

    -- Start transaction
    START TRANSACTION;

    -- Step 1: Insert into payment
    INSERT INTO payment (amount, order_id, method)
    VALUES (p_payment_amount, p_order_id, p_payment_method);
    SET v_payment_id = LAST_INSERT_ID();

    -- Step 2: Insert into payment_history
    INSERT INTO payment_history (method, amount, status, transaction_date, payment_id)
    VALUES (p_payment_method, p_payment_amount, 2, p_transaction_date, v_payment_id);
    SET v_payment_history_id = LAST_INSERT_ID();

    -- Commit transaction
    COMMIT;

    -- Return payment ID (for chaining)
    SELECT v_payment_id AS payment_id;
END$$

DELIMITER ;
