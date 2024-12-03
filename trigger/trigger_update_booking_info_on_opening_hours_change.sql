-- work_schedule 테이블에 대한 트리거
DELIMITER //
CREATE TRIGGER update_booking_info_on_work_schedule_change
AFTER UPDATE ON work_schedule
FOR EACH ROW
BEGIN
    -- 변경된 운영 시간과 충돌하는 예약, 픽업, 대기 정보를 조회하는 쿼리
    SELECT r.id AS reservation_id, p.id AS pickup_id, w.id AS waiting_id
    FROM reservation r
    JOIN reservation_time rt ON r.reservation_time_id = rt.id
    JOIN restaurant_table tbl ON r.restaurant_table_id = tbl.id
    JOIN work_schedule ws ON tbl.restaurant_id = ws.restaurant_id
    LEFT JOIN pickup p ON r.id = p.id
    LEFT JOIN waiting w ON r.restaurant_id = w.restaurant_id  
    WHERE r.restaurant_id = NEW.restaurant_id
      AND r.booking_date = CURDATE()
      AND rt.time NOT BETWEEN NEW.start_time AND NEW.end_time
      AND ws.day_of_week = DAYOFWEEK(CURDATE());

    -- delete_related_bookings 프로시저 호출
    CALL delete_related_bookings(NEW.restaurant_id, CURDATE());
END //
DELIMITER ;

-- custom_work_schedule 테이블에 대한 트리거
DELIMITER //
CREATE TRIGGER update_booking_info_on_custom_work_schedule_change
AFTER UPDATE ON custom_work_schedule
FOR EACH ROW
BEGIN
    -- 변경된 운영 시간과 충돌하는 예약, 픽업, 대기 정보를 조회하는 쿼리
    SELECT r.id AS reservation_id, p.id AS pickup_id, w.id AS waiting_id
    FROM reservation r
    JOIN reservation_time rt ON r.reservation_time_id = rt.id
    JOIN restaurant_table tbl ON r.restaurant_table_id = tbl.id
    JOIN custom_work_schedule cws ON tbl.restaurant_id = cws.restaurant_id
    LEFT JOIN pickup p ON r.id = p.id
    LEFT JOIN waiting w ON r.restaurant_id = w.restaurant_id
    WHERE r.restaurant_id = NEW.restaurant_id
      AND r.booking_date = NEW.date
      AND rt.time NOT BETWEEN NEW.start_time AND NEW.end_time;

    -- delete_related_bookings 프로시저 호출
    CALL delete_related_bookings(NEW.restaurant_id, NEW.date);
END //
DELIMITER ;

-- custom_holiday_schedule 테이블에 대한 트리거
DELIMITER //
CREATE TRIGGER update_booking_info_on_custom_holiday_schedule_change
AFTER UPDATE ON custom_holiday_schedule
FOR EACH ROW
BEGIN
    -- 변경된 휴일과 충돌하는 예약, 픽업, 대기 정보를 조회하는 쿼리
    SELECT r.id AS reservation_id, p.id AS pickup_id, w.id AS waiting_id
    FROM reservation r
    JOIN custom_holiday_schedule chs ON r.restaurant_id = chs.restaurant_id
    LEFT JOIN pickup p ON r.id = p.id
    LEFT JOIN waiting w ON r.restaurant_id = w.restaurant_id
    WHERE r.restaurant_id = NEW.restaurant_id
      AND r.booking_date = NEW.date;

    -- delete_related_bookings 프로시저 호출
    CALL delete_related_bookings(NEW.restaurant_id, NEW.date);
END //
DELIMITER ;