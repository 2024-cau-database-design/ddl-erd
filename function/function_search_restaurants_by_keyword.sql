DELIMITER //

CREATE FUNCTION search_restaurants_by_keyword(keyword VARCHAR(255))
RETURNS JSON
READS SQL DATA
BEGIN
    DECLARE result JSON;

    SELECT JSON_ARRAYAGG(JSON_OBJECT(
        'id', r.id,
        'name', r.name,
        'description', ri.description
    )) INTO result
    FROM restaurant r
    JOIN restaurant_info ri ON r.id = ri.restaurant_id
    WHERE (r.name LIKE CONCAT('%', keyword, '%') OR ri.description LIKE CONCAT('%', keyword, '%'))
      AND r.is_deleted = 0;

    RETURN result;
END //

DELIMITER ;