DELIMITER //
CREATE FUNCTION search_restaurants_by_keyword (keyword VARCHAR(255))
RETURNS JSON
READS SQL DATA
BEGIN
    DECLARE result JSON;

    SELECT JSON_ARRAYAGG(JSON_OBJECT(
        'id', restaurant.id,
        'name', restaurant.name,
        'description', restaurant_info.description
    )) INTO result
    FROM restaurant
    INNER JOIN restaurant_info ON restaurant.id = restaurant_info.restaurant_id
    WHERE restaurant.name LIKE CONCAT('%', keyword, '%')
    OR restaurant_info.description LIKE CONCAT('%', keyword, '%')
    AND restaurant.is_deleted = 0;

    RETURN result;
END //
DELIMITER ;