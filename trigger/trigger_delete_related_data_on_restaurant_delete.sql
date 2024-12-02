DELIMITER //
CREATE TRIGGER delete_related_data_on_restaurant_delete
BEFORE DELETE ON restaurant
FOR EACH ROW
BEGIN
    -- 레스토랑 메뉴 삭제 (소프트 딜리트)
    UPDATE restaurant_menu 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = OLD.id;

    -- 레스토랑 이미지 삭제 (소프트 딜리트)
    UPDATE restaurant_image 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = OLD.id;

    -- 레스토랑 리뷰 삭제 (소프트 딜리트)
    UPDATE restaurant_review 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = OLD.id;

    -- 예약 테이블 삭제 (소프트 딜리트)
    UPDATE reservation 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = OLD.id;

    -- 픽업 테이블 삭제 (소프트 딜리트)
    UPDATE pickup 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = OLD.id;

    -- 대기 테이블 삭제 (소프트 딜리트)
    UPDATE wating 
    SET is_deleted = 1, deleted_at = NOW() 
    WHERE restaurant_id = OLD.id;

    -- 기타 관련 테이블 삭제 (소프트 딜리트) (필요에 따라 추가)
    -- ...
END //
DELIMITER ;