
DELIMITER $$

CREATE TRIGGER `validate_waiting_insert`
BEFORE INSERT ON `waiting`
FOR EACH ROW
BEGIN
    DECLARE duplicate_count INT;

    -- 같은 customer_id, restaurant_id, created_at(날짜) 기준으로 중복 검사
    SELECT COUNT(*)
    INTO duplicate_count
    FROM `waiting`
    WHERE `customer_id` = NEW.`customer_id`
      AND `restaurant_id` = NEW.`restaurant_id`
      AND DATE(FROM_UNIXTIME(`created_at`)) = DATE(FROM_UNIXTIME(NEW.`created_at`));

    -- 중복이 존재하면 에러 반환
    IF duplicate_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A customer cannot create multiple waiting entries for the same restaurant on the same day.';
    END IF;
END$$

DELIMITER ;

