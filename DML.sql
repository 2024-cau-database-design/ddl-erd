-- user
INSERT INTO `catchtable`.`user_auth` (`id`, `password_hash`, `login_id`, `email`, `created_at`, `updated_at`, `is_deleted`) VALUES ('1', '1234', 'user1', 'user1@cau.ac.kr', '24.12.01.18.00', '24.12.01.18.00', '0');
INSERT INTO `catchtable`.`user_auth` (`id`, `password_hash`, `login_id`, `email`, `created_at`, `updated_at`, `is_deleted`) VALUES ('2', '1234', 'user2', 'user2@cau.ac.kr', '24.12.01.18.00', '24.12.01.18.00', '0');
INSERT INTO `catchtable`.`user_auth` (`id`, `password_hash`, `login_id`, `email`, `created_at`, `updated_at`, `is_deleted`) VALUES ('3', '1234', 'user3', 'user3@cau.ac.kr', '24.12.01.18.00', '24.12.01.18.00', '0');
INSERT INTO `catchtable`.`user_auth` (`id`, `password_hash`, `login_id`, `email`, `created_at`, `updated_at`, `is_deleted`) VALUES ('4', '1234', 'user4', 'user4@cau.ac.kr', '24.12.01.18.00', '24.12.01.18.00', '0');

INSERT INTO owner (id) 
VALUES (LAST_INSERT_ID());

-- owner
INSERT INTO `catchtable`.`owner` (`id`, `created_at`, `is_deleted`) VALUES ('1', '2024.12.01.20.44', '0');

-- customer
INSERT INTO `catchtable`.`customer` (`id`, `name`, `phone_number`) VALUES ('2', 'Kim', '01026592963');
INSERT INTO `catchtable`.`customer` (`id`, `name`, `phone_number`) VALUES ('3', 'Lee', '01034757832');
INSERT INTO `catchtable`.`customer` (`id`, `name`, `phone_number`) VALUES ('4', 'Jo', '01038583922');
INSERT INTO `catchtable`.`customer` (`id`, `name`, `phone_number`) VALUES ('5', 'Kimm', '01048583839');

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
INSERT INTO `catchtable`.`order_status` (`type`)
VALUES ('CANCEL');

INSERT INTO `catchtable`.`pickup_status` (`type`)
VALUES ('BEFORE_PICKUP'), ('AFTER_PICKUP');
INSERT INTO `catchtable`.`pickup_status` (`type`)
VALUES ('CANCEL');

INSERT INTO `catchtable`.`reservation_status` (`type`)
VALUES ('BEFORE_VISIT'),('AFTER_VISIT'),('NO_SHOW'), ('CANCEL');

INSERT INTO `catchtable`.`payment_status` (`type`)
VALUES ('COMPLETE'),('REFUNDED');

-- waiting_status
INSERT INTO `catchtable`.`waiting_status` (`id`, `type`) VALUES ('1', '\"waiting\"');
INSERT INTO `catchtable`.`waiting_status` (`id`, `type`) VALUES ('2', '\"completed\"');
INSERT INTO `catchtable`.`waiting_status` (`id`, `type`) VALUES ('3', '\"cancelled\"');



