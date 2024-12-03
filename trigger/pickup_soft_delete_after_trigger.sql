DROP TRIGGER pickup_soft_delete_after_trigger;

DELIMITER //

-- after trigger
CREATE TRIGGER pickup_soft_delete_after_trigger
AFTER UPDATE ON pickup
FOR EACH ROW
BEGIN
    IF NEW.is_deleted = TRUE AND OLD.is_deleted = FALSE THEN
        -- 1. Update deleted_at in pickup table

        -- 2. Insert new row in pickup_history with 'CANCEL' status
        INSERT INTO pickup_history (
            status_id, 
            pickup_id, 
            picked_at, 
            pickup_time_id, 
            pickup_at, 
            created_at
        )
        SELECT 
            ps.id, 
            NEW.id, 
            NULL, 
            COALESCE(
                (SELECT pickup_time_id 
                 FROM pickup_history 
                 WHERE pickup_id = NEW.id 
                 ORDER BY created_at DESC 
                 LIMIT 1),
                1  -- 기본값, 실제 상황에 맞게 조정 필요
            ),
            COALESCE(
                (SELECT pickup_at 
                 FROM pickup_history 
                 WHERE pickup_id = NEW.id 
                 ORDER BY created_at DESC 
                 LIMIT 1),
                CURRENT_TIMESTAMP  -- 기본값, 실제 상황에 맞게 조정 필요
            ),
            CURRENT_TIMESTAMP
        FROM pickup_status ps
        WHERE ps.type = 'CANCEL'
        LIMIT 1;

        -- 3. Update order status to 'CANCEL'
        UPDATE `order` o
        JOIN order_status os ON os.type = 'CANCEL'
        SET o.status_id = os.id
        WHERE o.booking_id = NEW.id;

        -- 4. Insert new row in payment_history with 'REFUND' status
        INSERT INTO payment_history (
            status_id, 
            transaction_at, 
            payment_id, 
            created_at, 
            updated_at
        )
        SELECT 
            ps.id, 
            CURRENT_TIMESTAMP, 
            p.id, 
            CURRENT_TIMESTAMP, 
            CURRENT_TIMESTAMP
        FROM payment p
        JOIN `order` o ON p.order_id = o.id
        JOIN payment_status ps ON ps.type = 'REFUND'
        WHERE o.booking_id = NEW.id
        AND NOT EXISTS (
            SELECT 1 
            FROM payment_history ph 
            WHERE ph.payment_id = p.id 
            AND ph.status_id = ps.id
        );
    END IF;
END//

DELIMITER ;

SELECT * from pickup;

SELECT * from pickup_history;
SELECT * from `order`;
SELECT * from payment;
SELECT * from payment_history;

UPDATE pickup SET pickup.is_deleted = 0, pickup.deleted_at = NULL where pickup.id = 16;
UPDATE pickup SET pickup.is_deleted = 0, pickup.deleted_at = NULL where pickup.id = 17;

