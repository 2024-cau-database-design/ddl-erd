-- work_schedule 테이블에 대한 트리거
DELIMITER //
CREATE TRIGGER update_booking_info_on_work_schedule_change
AFTER UPDATE ON work_schedule
FOR EACH ROW
BEGIN
    -- 변경된 운영 시간과 충돌하는 예약, 픽업, 대기 정보를 조회하는 쿼리
    SELECT reservation.id, pickup.id, wating.id
    FROM reservation
    INNER JOIN reservation_time ON reservation.reservation_time_id = reservation_time.id
    INNER JOIN restaurant_table ON reservation.restaurant_table_id = restaurant_table.id
    INNER JOIN work_schedule ON restaurant_table.restaurant_id = work_schedule.restaurant_id
    LEFT JOIN pickup ON reservation.id = pickup.id
    LEFT JOIN wating ON reservation.id = wating.id
    WHERE reservation.restaurant_id = NEW.restaurant_id
    AND reservation.booking_date = DATE_FORMAT(NOW(), '%Y-%m-%d')
    AND reservation_time.time NOT BETWEEN NEW.start_time AND NEW.end_time;

    -- 충돌하는 예약, 픽업, 대기 정보를 업데이트 또는 삭제하는 로직 (필요에 따라 구현)
    -- ...
END //
DELIMITER ;

-- custom_work_schedule 테이블에 대한 트리거
DELIMITER //
CREATE TRIGGER update_booking_info_on_custom_work_schedule_change
AFTER UPDATE ON custom_work_schedule
FOR EACH ROW
BEGIN
    -- 변경된 운영 시간과 충돌하는 예약, 픽업, 대기 정보를 조회하는 쿼리
    SELECT reservation.id, pickup.id, wating.id
    FROM reservation
    INNER JOIN reservation_time ON reservation.reservation_time_id = reservation_time.id
    INNER JOIN restaurant_table ON reservation.restaurant_table_id = restaurant_table.id
    INNER JOIN custom_work_schedule ON restaurant_table.restaurant_id = custom_work_schedule.restaurant_id
    LEFT JOIN pickup ON reservation.id = pickup.id
    LEFT JOIN wating ON reservation.id = wating.id
    WHERE reservation.restaurant_id = NEW.restaurant_id
    AND reservation.booking_date = NEW.date
    AND reservation_time.time NOT BETWEEN NEW.start_time AND NEW.end_time;

    -- 충돌하는 예약, 픽업, 대기 정보를 업데이트 또는 삭제하는 로직 (필요에 따라 구현)
    -- ...
END //
DELIMITER ;

-- custom_holiday_schedule 테이블에 대한 트리거
DELIMITER //
CREATE TRIGGER update_booking_info_on_custom_holiday_schedule_change
AFTER UPDATE ON custom_holiday_schedule
FOR EACH ROW
BEGIN
    -- 변경된 휴일과 충돌하는 예약, 픽업, 대기 정보를 조회하는 쿼리
    SELECT reservation.id, pickup.id, wating.id
    FROM reservation
    INNER JOIN custom_holiday_schedule ON reservation.restaurant_id = custom_holiday_schedule.restaurant_id
    LEFT JOIN pickup ON reservation.id = pickup.id
    LEFT JOIN wating ON reservation.id = wating.id
    WHERE reservation.restaurant_id = NEW.restaurant_id
    AND reservation.booking_date = NEW.date;

    -- 충돌하는 예약, 픽업, 대기 정보를 업데이트 또는 삭제하는 로직 (필요에 따라 구현)
    -- ...
END //
DELIMITER ;