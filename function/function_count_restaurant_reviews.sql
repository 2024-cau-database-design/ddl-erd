DELIMITER //
CREATE FUNCTION count_restaurant_reviews (restaurant_id INT UNSIGNED)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE review_count INT;

    SELECT COUNT(*) INTO review_count
    FROM restaurant_review
    WHERE restaurant_id = restaurant_id
    AND is_deleted = 0;

    RETURN review_count;
END //
DELIMITER ;