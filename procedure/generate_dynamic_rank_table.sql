DELIMITER $$

CREATE PROCEDURE `GenerateDynamicRankTable`(
    IN `restaurantId` INT
)
BEGIN
    -- 기존 테이블 삭제 (이미 존재할 경우)
    DROP TEMPORARY TABLE IF EXISTS dynamic_rank_table;

    -- 새로운 테이블 생성
    CREATE TEMPORARY TABLE dynamic_rank_table AS
    SELECT 
        c.name,
        c.phone_number,
        RANK() OVER (ORDER BY wh.created_at ASC) AS `rank`
    FROM waiting w
    INNER JOIN waiting_history wh ON w.id = wh.waiting_id
    INNER JOIN customer c ON w.customer_id = c.id
    WHERE w.restaurant_id = restaurantId
      AND wh.waiting_status_id = 1; -- "대기중" 상태만 포함
END$$

DELIMITER ;