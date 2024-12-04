DROP PROCEDURE IF EXISTS get_pickup_info_list;

DELIMITER $$

CREATE PROCEDURE get_pickup_info_list(IN pickup_ids VARCHAR(1000))
BEGIN
    WITH pickup_detail AS (
        SELECT
            p.id AS id,
            p.restaurant_id,
            p.customer_id,
            p.created_at,
            ps.type AS pickup_status,
            ph.created_at AS updated_at,
            ph.pickup_at AS pickup_at,
            ph.picked_at AS picked_at,
            c.name AS customer_name,
            c.phone_number AS customer_phone,
            ua.email AS customer_email
        FROM pickup p
        LEFT JOIN pickup_history ph ON p.id = ph.pickup_id
        LEFT JOIN pickup_status ps ON ph.status_id = ps.id
        LEFT JOIN customer c ON p.customer_id = c.id
        LEFT JOIN user_auth ua ON c.id = ua.id
        WHERE FIND_IN_SET(p.id, pickup_ids) > 0
        AND (p.id, ph.created_at) IN (
            SELECT pickup_id, MAX(created_at)
            FROM pickup_history
            WHERE FIND_IN_SET(pickup_id, pickup_ids) > 0
            GROUP BY pickup_id
        )
    ),
    pickup_and_order AS (
        SELECT
            pd.*,
            o.id AS order_id,
            os.type AS order_status,
            o.total_price,
            o.reservation_fee
        FROM pickup_detail pd
        LEFT JOIN `order` o ON pd.id = o.booking_id
        LEFT JOIN order_status os ON o.status_id = os.id
    ),
    order_items AS (
        SELECT
            oi.order_id,
            JSON_ARRAYAGG(
                JSON_OBJECT(
                    'menu_name', rm.name,
                    'quantity', oi.quantity,
                    'price', oi.price,
                    'totalPrice', oi.quantity * oi.price
                )
            ) AS items
        FROM order_item oi
        JOIN restaurant_menu rm ON oi.menu_id = rm.id
        GROUP BY oi.order_id
    )
    SELECT 
        po.id,
        po.restaurant_id,
        JSON_OBJECT(
            'id', po.customer_id,
            'name', po.customer_name,
            'phoneNumber', po.customer_phone,
            'email', po.customer_email
        ) AS customer,
        po.created_at,
        po.pickup_status,
        po.updated_at,
        po.pickup_at,
        po.picked_at,
        po.order_id,
        po.order_status,
        po.order_created_at,
        po.total_price,
        po.reservation_fee,
        IFNULL(oi.items, JSON_ARRAY()) as order_items
    FROM pickup_and_order po
    LEFT JOIN order_items oi ON po.order_id = oi.order_id;
END $$

DELIMITER ;

CALL get_pickup_info_list('15,16');

SELECT * from pickup;
SELECT * from `order`;
SELECT * from `order_status`;
SELECT * from order_item;
SELECT * from pickup_history;
SELECT * from payment;
