DROP PROCEDURE IF EXISTS get_pickup_info;

DELIMITER $$

CREATE PROCEDURE get_pickup_info(IN pickup_id INT)
BEGIN
    WITH
    pickup AS (
        SELECT * FROM pickup WHERE id = pickup_id
    ),
    pickup_detail AS (
        SELECT
            p.id AS id,
            p.restaurant_id,
            p.created_at,
            ps.type AS pickup_status,
            ph.created_at AS updated_at
            ph.pickup_at AS pickup_at
            ph.picked_at AS picked_at
        FROM pickup p
        LEFT JOIN pickup_history ph ON p.id = ph.pickup_id
        LEFT JOIN pickup_status ps ON ph.status_id = ps.id
        ORDER BY ph.created_at DESC
        LIMIT 1
    ),
    pickup_and_order as
     (SELECT
         pd.*,
         o.id AS order_id,
         os.type AS order_status,
         o.created_at AS order_created_at,
         o.total_price,
         o.reservation_fee
     FROM pickup_detail pd
     LEFT JOIN `order` o ON pd.id = o.booking_id
     LEFT JOIN order_status os ON o.status_id = os.id),
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
        po.*,
        oi.items AS order_items
    FROM pickup_and_order po
    LEFT JOIN order_items oi ON po.order_id = oi.order_id;

END$$

DELIMITER ;

CALL get_pickup_info(12);

SELECT * from pickup;
SELECT * from `order`;
SELECT * from `order_status`;
SELECT * from order_item;
SELECT * from pickup_history;
SELECT * from payment;
