DELIMITER //
CREATE FUNCTION search_restaurants_by_category (category_name VARCHAR(20))
RETURNS JSON
READS SQL DATA
BEGIN
    DECLARE result JSON;

    SELECT JSON_ARRAYAGG(JSON_OBJECT(
        'id', restaurant.id,
        'name', restaurant.name,
        'category', restaurant_food_category.name
    )) INTO result
    FROM restaurant
    INNER JOIN restaurant_food_category ON restaurant.id = restaurant_food_category.restaurant_id
    WHERE restaurant_food_category.name = category_name
    AND restaurant.is_deleted = 0;

    RETURN result;
END //
DELIMITER ;