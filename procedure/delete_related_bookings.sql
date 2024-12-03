DELIMITER //
CREATE PROCEDURE delete_related_bookings(IN restaurant_id INT, IN booking_date DATE)
BEGIN
    -- 예약 정보 업데이트 (소프트 딜리트)
    UPDATE reservation 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = restaurant_id AND booking_date = booking_date;

    -- 예약 히스토리 정보를 '삭제' 상태로 업데이트
    UPDATE reservation_history 
    SET status_id = (SELECT id FROM reservation_status WHERE type = '삭제') 
    WHERE reservation_id IN (SELECT id FROM reservation WHERE restaurant_id = restaurant_id AND booking_date = booking_date);

    -- 픽업 정보 업데이트 (소프트 딜리트)
    UPDATE pickup 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = restaurant_id AND id IN (SELECT id FROM reservation WHERE restaurant_id = restaurant_id AND booking_date = booking_date);

    -- 픽업 히스토리 정보를 '삭제' 상태로 업데이트
    UPDATE pickup_history 
    SET status_id = (SELECT id FROM pickup_status WHERE type = '삭제') 
    WHERE pickup_id IN (SELECT id FROM reservation WHERE restaurant_id = restaurant_id AND booking_date = booking_date);

    -- 대기 히스토리 정보를 '삭제' 상태로 업데이트
    UPDATE waiting_history 
    SET waiting_status_id = (SELECT id FROM waiting_status WHERE type = '삭제') 
    WHERE waiting_id IN (SELECT id FROM waiting WHERE restaurant_id = restaurant_id);
END //
DELIMITER ;