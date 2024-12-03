DELIMITER //

CREATE FUNCTION search_restaurants_by_category(category_name VARCHAR(20))
RETURNS JSON
READS SQL DATA
BEGIN
    DECLARE result JSON;

    SELECT JSON_ARRAYAGG(JSON_OBJECT(
        'id', r.id,
        'name', r.name,
        'category', rfc.name
    )) INTO result
    FROM restaurant r
    JOIN restaurant_food_category rfc ON r.id = rfc.restaurant_id
    WHERE rfc.name = category_name
      AND r.is_deleted = 0;

    RETURN result;
END //

DELIMITER ;