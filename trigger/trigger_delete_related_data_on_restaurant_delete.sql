DELIMITER //

CREATE TRIGGER delete_related_data_on_restaurant_delete
BEFORE DELETE ON restaurant
FOR EACH ROW
BEGIN
    -- 레스토랑 정보 삭제 (소프트 딜리트)
    UPDATE restaurant_info 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = OLD.id;

    -- 레스토랑 테이블 삭제 (소프트 딜리트)
    UPDATE restaurant_table 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = OLD.id;

    -- 레스토랑 리뷰 삭제 (소프트 딜리트)
    UPDATE restaurant_review 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = OLD.id;

    -- 레스토랑 북마크 삭제 (소프트 딜리트)
    UPDATE reataurant_bookmark 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = OLD.id;

    -- 레스토랑 메뉴 삭제 (소프트 딜리트)
    UPDATE restaurant_menu 
    SET is_hidden = 1, updated_at = NOW() 
    WHERE restaurant_id = OLD.id;

    -- 레스토랑 이미지 삭제 (하드 딜리트)
    DELETE FROM restaurant_image 
    WHERE restaurant_id = OLD.id;

    -- 예약 테이블 삭제 (소프트 딜리트)
    UPDATE reservation 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = OLD.id;

    -- 픽업 테이블 삭제 (소프트 딜리트)
    UPDATE pickup 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = OLD.id;

    -- 대기 테이블 조회
    SELECT id INTO @waiting_id FROM waiting WHERE restaurant_id = OLD.id;

    -- 대기 내역 테이블 상태 변경
    UPDATE waiting_history 
    SET waiting_status_id = (SELECT id FROM waiting_status WHERE type = '취소') 
    WHERE waiting_id = @waiting_id;

    -- 예약 시간 테이블 삭제 (하드 딜리트)
    DELETE FROM reservation_time
    WHERE restaurant_id = OLD.id;

    -- 픽업 시간 테이블 삭제 (하드 딜리트)
    DELETE FROM pickup_time
    WHERE restaurant_id = OLD.id;

    -- 레스토랑 음식 카테고리 테이블 삭제 (하드 딜리트)
    DELETE FROM restaurant_food_category
    WHERE restaurant_id = OLD.id;

    -- 맞춤 근무 일정 테이블 삭제 (하드 딜리트)
    DELETE FROM custom_work_schedule
    WHERE restaurant_id = OLD.id;

    -- 근무 일정 테이블 삭제 (하드 딜리트)
    DELETE FROM work_schedule
    WHERE restaurant_id = OLD.id;

    -- 맞춤 휴일 일정 테이블 삭제 (하드 딜리트)
    DELETE FROM custom_holiday_schedule
    WHERE restaurant_id = OLD.id;
END //
DELIMITER ;