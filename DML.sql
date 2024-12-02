-- user
INSERT INTO `catchtable`.`user_auth` (password_hash, login_id, email) 
VALUES ('hashed_password', 'owner_login', 'owner_email@example.com'), 
('hashed_password2', 'owner_login2', 'owner_email2@example.com',
('hashed_password3', 'owner_login3', 'owner_email3@example.com'));

INSERT INTO owner (id) 
VALUES (LAST_INSERT_ID());

-- customer
INSERT INTO `catchtable`.`customer` (`id`, `name`, `phone_number`)
VALUES
(2, 'John Doe', '01012345678'),
(3, 'Jane Smith', '01098765432');

-- restaurant
INSERT INTO restaurant (name, owner_id) 
VALUES ('Sample Restaurant', LAST_INSERT_ID());

INSERT INTO `catchtable`.`restaurant_menu` 
    (`restaurant_id`, `name`, `description`, `price`, `is_hidden`) 
VALUES
    (1, 'Pasta', 'Creamy Alfredo Pasta', 1200, 0),
    (1, 'Pizza', 'Cheese-loaded Margherita Pizza', 1500, 0),
    (1, 'Salad', 'Fresh Garden Salad', 800, 0);

INSERT INTO pickup_time (time, restaurant_id) 
VALUES ('12:00:00', LAST_INSERT_ID());

-- order
INSERT INTO `catchtable`.`order_status` (`type`)
VALUES ('PENDING'), ('COMPLETE');

INSERT INTO `catchtable`.`pickup_status` (`type`)
VALUES ('BEFORE_PICKUP'), ('AFTER_PICKUP');

INSERT INTO `catchtable`.`reservation_status` (`type`)
VALUES ('BEFORE_VISIT'),('AFTER_VISIT'),('NO_SHOW');

INSERT INTO `catchtable`.`payment_status` (`type`)
VALUES ('COMPLETE'),('REFUNDED')

