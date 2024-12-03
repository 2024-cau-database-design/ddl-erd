DELIMITER //

-- 현재 워크 스케줄과 커스텀 워크 스케줄, 커스텀 홀리데이를 전부 확인해서 
-- 충돌하는 경우는 커스텀 워크 스케줄과 커스텀 홀리데이를 우선시하여 실제 영업시간을 받아오는 함수
CREATE FUNCTION get_actual_work_schedule(restaurant_id INT, target_date DATE)
RETURNS VARCHAR(255)
BEGIN
    DECLARE work_start_time TIME;
    DECLARE work_end_time TIME;

    -- 1. 커스텀 홀리데이 확인
    IF EXISTS (SELECT 1 FROM custom_holiday_schedule WHERE restaurant_id = restaurant_id AND date = target_date) THEN
        -- 휴일인 경우 영업시간 없음
        RETURN 'CLOSED';
    END IF;

    -- 2. 커스텀 워크 스케줄 확인
    IF EXISTS (SELECT 1 FROM custom_work_schedule WHERE restaurant_id = restaurant_id AND date = target_date) THEN
        -- 커스텀 워크 스케줄이 있는 경우 해당 스케줄 반환
        SELECT start_time, end_time 
        FROM custom_work_schedule 
        WHERE restaurant_id = restaurant_id AND date = target_date
        INTO work_start_time, work_end_time;
    ELSE
        -- 3. 기본 워크 스케줄 확인
        SELECT ws.start_time, ws.end_time
        FROM work_schedule ws
        WHERE ws.restaurant_id = restaurant_id
          AND ws.day_of_week = DAYOFWEEK(target_date)
        INTO work_start_time, work_end_time;
    END IF;

    -- work_start_time 또는 work_end_time이 NULL인 경우 'CLOSED' 반환
    IF work_start_time IS NULL OR work_end_time IS NULL THEN
        RETURN 'CLOSED';
    END IF;

    -- 영업시간 반환
    RETURN CONCAT(work_start_time, ' - ', work_end_time);
END //

DELIMITER ;