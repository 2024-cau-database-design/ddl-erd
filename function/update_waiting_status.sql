DELIMITER $$

CREATE FUNCTION UpdateWaitingStatus(
    waitingId INT,       -- 변경할 waiting의 ID
    newStatusId INT      -- 새로 설정할 상태 ID (2 또는 3)
)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE resultMessage VARCHAR(50);

    -- 유효성 검사: 새로운 상태 ID가 유효한지 확인
    IF newStatusId NOT IN (2, 3) THEN
        RETURN 'Invalid status transition'; -- 잘못된 상태 변경 시 메시지 반환
    END IF;

    -- waiting_history 테이블의 가장 최근 기록의 상태와 시간 업데이트
    UPDATE waiting_history
    SET 
        waiting_status_id = newStatusId,  -- 상태 변경
        created_at = NOW()               -- 변경된 시간 기록
    WHERE waiting_id = waitingId
    ORDER BY created_at DESC             -- 가장 최근 기록 선택
    LIMIT 1;

    -- 결과 메시지 반환
    SET resultMessage = CONCAT('Status updated to ', newStatusId);
    RETURN resultMessage;
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS `GenerateDynamicRankTable`;