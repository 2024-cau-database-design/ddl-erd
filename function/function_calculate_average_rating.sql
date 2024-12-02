DELIMITER //
CREATE FUNCTION calculate_average_rating (restaurant_id INT UNSIGNED)
RETURNS DECIMAL(3,1)
READS SQL DATA
BEGIN
    DECLARE avg_rating DECIMAL(3,1);

    SELECT AVG(rating) INTO avg_rating
    FROM restaurant_review
    WHERE restaurant_id = restaurant_id
    AND is_deleted = 0;

    RETURN avg_rating;
END //
DELIMITER ;