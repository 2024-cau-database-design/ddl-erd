-- MySQL Script generated by MySQL Workbench
-- Fri Nov 29 09:06:28 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema catchtable
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `catchtable` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;

-- -----------------------------------------------------
-- Schema catchtable
-- -----------------------------------------------------
USE `catchtable` ;

-- -----------------------------------------------------
-- Table `catchtable`.`user_auth`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`user_auth` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `password_hash` VARCHAR(45) NOT NULL,
  `login_id` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` TINYINT(1) NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`owner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`owner` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` TINYINT(1) NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_owner_user_auth1`
    FOREIGN KEY (`id`)
    REFERENCES `catchtable`.`user_auth` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `restaurant`.`restaurant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`restaurant` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` TINYINT(1) NOT NULL DEFAULT '0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `owner_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_restaurant_owner1_idx` (`owner_id` ASC) VISIBLE,
  CONSTRAINT `fk_restaurant_owner1`
    FOREIGN KEY (`owner_id`)
    REFERENCES `catchtable`.`owner` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = 
utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `restaurant`.`restaurant_info`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`restaurant_info` (
  `restaurant_id` INT UNSIGNED NOT NULL,
  `phone_number` VARCHAR(11) NOT NULL,
  `website_url` VARCHAR(255) NULL DEFAULT NULL,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` TINYINT(1) NOT NULL DEFAULT '0',
  `deleted_at` DATETIME NULL DEFAULT NULL,
  UNIQUE INDEX `phone_number` (`phone_number` ASC),
  CONSTRAINT `restaurant_info_ibfk_1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT 
CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `restaurant`.`restaurant_location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`restaurant_location` (
  `restaurant_id` INT UNSIGNED NOT NULL,
  `latitude` DECIMAL(10,8) NOT NULL,
  `longitude` DECIMAL(11,8) NOT NULL,
  CONSTRAINT `restaurant_location_ibfk_1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`customer` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `phone_number` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_customer_user_auth1`
    FOREIGN KEY (`id`)
    REFERENCES `catchtable`.`user_auth` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`order_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`order_status` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`reservation_time`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`reservation_time` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `time` TIME NOT NULL,
  `restaurant_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_reservation_time_restaurant1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`table_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`table_type` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`restaurant_table`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`restaurant_table` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `restaurant_id` INT UNSIGNED NOT NULL,
  `type_id` INT UNSIGNED NOT NULL, -- Changed to INT to match table_type.id
  `seat_capcity` TINYINT(10) UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` TINYINT(1) NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_restaurant_table_restaurant1_idx` (`restaurant_id` ASC) VISIBLE,
  INDEX `fk_restaurant_table_table_type1_idx` (`type_id` ASC) VISIBLE,
  CONSTRAINT `fk_restaurant_table_restaurant1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION    
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_restaurant_table_table_type1`
    FOREIGN KEY (`type_id`)
    REFERENCES `catchtable`.`table_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`reservation`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`reservation` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reservation_time_id` INT UNSIGNED NOT NULL,
  `booking_date` DATE NOT NULL,
  `guests_count` TINYINT(6) NOT NULL,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` TINYINT(1) NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  `restaurant_table_id` INT UNSIGNED NOT NULL, -- Changed to INT UNSIGNED
  `is_hidden` TINYINT(1) NULL DEFAULT 1,
  `restaurant_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `reservation_ibfk_2` (`reservation_time_id` ASC) VISIBLE,
  INDEX `fk_reservation_restaurant_table1_idx` (`restaurant_table_id` ASC) VISIBLE,
  INDEX `fk_reservation_restaurant1_idx` (`restaurant_id` ASC) VISIBLE,
  CONSTRAINT `fk_reservation_booking`
    FOREIGN KEY (`id`)
    REFERENCES `catchtable`.`booking` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `reservation_ibfk_2`
    FOREIGN KEY (`reservation_time_id`)
    REFERENCES `catchtable`.`reservation_time` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reservation_restaurant_table1`
    FOREIGN KEY (`restaurant_table_id`)
    REFERENCES `catchtable`.`restaurant_table` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reservation_restaurant1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`pickup_time`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`pickup_time` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `time` TIME NOT NULL,
  `restaurant_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_pickup_time_restaurant1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`pickup`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`pickup` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` TINYINT(1) NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL,
  `restaurant_id` INT UNSIGNED NOT NULL,
  `customer_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_pickup_restaurant1_idx` (`restaurant_id` ASC) VISIBLE,
  INDEX `fk_pickup_customer1_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `fk_pickup_booking`
    FOREIGN KEY (`id`)
    REFERENCES `catchtable`.`booking` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_pickup_restaurant1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pickup_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `catchtable`.`customer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`booking` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` ENUM('pickup', 'reservation') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`order` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `status_id` INT UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total_price` INT UNSIGNED NOT NULL,
  `restaurant_id` INT UNSIGNED NOT NULL,
  `customer_id` INT UNSIGNED NOT NULL,
  `reservation_fee` INT UNSIGNED NOT NULL,
  `booking_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `order_ibfk_1` (`status_id` ASC) VISIBLE,
  INDEX `fk_order_customer1` (`customer_id` ASC) VISIBLE,
  INDEX `fk_order_booking1_idx` (`booking_id` ASC) VISIBLE,
  CONSTRAINT `fk_order_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `catchtable`.`customer` (`id`)
    ON DELETE 
NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `order_ibfk_1`
    FOREIGN KEY (`status_id`)
    REFERENCES `catchtable`.`order_status` (`id`),
  CONSTRAINT `fk_order_restaurant1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_booking1`
    FOREIGN KEY (`booking_id`)
    REFERENCES `catchtable`.`booking` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- 'order_item' 테이블 정의
CREATE TABLE IF NOT EXISTS `catchtable`.`order_item` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `quantity` INT UNSIGNED NOT NULL,
  `price` INT UNSIGNED NOT NULL,
  `order_id` INT UNSIGNED NOT NULL,
  `menu_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `order_item_ibfk_1` (`order_id` ASC) VISIBLE,
  INDEX `menu_id_idx` (`menu_id` ASC) VISIBLE, -- Updated index for menu_id
  CONSTRAINT `order_item_ibfk_1`
    FOREIGN KEY (`order_id`)
    REFERENCES `catchtable`.`order` (`id`)
    ON DELETE NO ACTION
	ON UPDATE NO ACTION,
  CONSTRAINT `order_item_ibfk_2`
    FOREIGN KEY (`menu_id`)
    REFERENCES `catchtable`.`restaurant_menu` (`id`) -- Correct FK relationship
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- 'restaurant_menu' 테이블 정의
CREATE TABLE IF NOT EXISTS `catchtable`.`restaurant_menu` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `restaurant_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(20) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `price` INT UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_hidden` TINYINT(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `restaurant_id_idx` (`restaurant_id` ASC) VISIBLE,
  CONSTRAINT `restaurant_menu_ibfk_1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `restaurant`.`restaurant_image`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`restaurant_image` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `restaurant_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  `url` VARCHAR(255) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `restaurant_id` (`restaurant_id` ASC) VISIBLE,
  CONSTRAINT `restaurant_photo_ibfk_1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `restaurant`.`restaurant_review`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`restaurant_review` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `restaurant_id` INT UNSIGNED NOT NULL,
  `customer_id` INT UNSIGNED NOT NULL,
  `rating` DECIMAL(3,1) NOT NULL DEFAULT 5,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` TINYINT(1) NOT NULL DEFAULT 0,
  `deleted_at` DATETIME NULL DEFAULT NULL,
  `text` TEXT NULL,
  PRIMARY KEY (`id`),
  INDEX `restaurant_id` (`restaurant_id` ASC) VISIBLE,
  CONSTRAINT `restaurant_review_ibfk_1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
 
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_restaurant_review_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `catchtable`.`customer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `restaurant`.`review_image`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`review_image` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `review_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(5) NOT NULL,
  `url` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `review_id` (`review_id` ASC) VISIBLE,
  CONSTRAINT `review_photo_ibfk_1`
    FOREIGN KEY (`review_id`)
    REFERENCES `catchtable`.`restaurant_review` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `restaurant`.`menu_image`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`menu_image` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(5) NOT NULL,
  `url` VARCHAR(255) NOT NULL,
  `review_id` INT UNSIGNED NOT NULL,
  CONSTRAINT `fk_menu-photo_restaurant_menu1`
    FOREIGN KEY (`id`)
    REFERENCES `catchtable`.`restaurant_menu` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`payment` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `amount` INT UNSIGNED NOT NULL,
  `order_id` INT UNSIGNED NOT NULL,
  `method` VARCHAR(30) NOT NULL COMMENT 'CARD, COUPON\n',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `payment_ibfk_1` (`order_id` ASC) VISIBLE,
  CONSTRAINT `payment_ibfk_1`
    FOREIGN KEY (`order_id`)
    REFERENCES `catchtable`.`order` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS `catchtable`.`payment_status` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`payment_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`payment_history` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `status_id` INT UNSIGNED NULL,
  `transaction_at` DATETIME NOT NULL,
  `payment_id` INT UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `payment_history_ibfk_1` (`payment_id` ASC) VISIBLE,
  CONSTRAINT `payment_history_ibfk_1`
    FOREIGN KEY (`payment_id`)
    REFERENCES `catchtable`.`payment` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_payment_history_payment_status1`
    FOREIGN KEY (`status_id`)
    REFERENCES `catchtable`.`payment_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`pickup_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`pickup_status` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`pickup_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`pickup_history` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `status_id` INT UNSIGNED NOT NULL,
  `pickup_id` INT UNSIGNED NOT NULL,
  `picked_at` DATETIME NULL,
  `pickup_time_id` INT UNSIGNED NOT NULL,
  `pickup_at` DATETIME NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `pickup_history_ibfk_1` (`status_id` ASC) VISIBLE,
  INDEX `pickup_history_ibfk_2` (`pickup_id` ASC) VISIBLE,
  CONSTRAINT `pickup_history_ibfk_1`
    FOREIGN KEY (`status_id`)
    REFERENCES `catchtable`.`pickup_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `pickup_history_ibfk_2`
    FOREIGN KEY (`pickup_id`)
    REFERENCES `catchtable`.`pickup` (`id`),
  CONSTRAINT `pickup_history_ibfk_3`
    FOREIGN KEY (`pickup_time_id`)
    REFERENCES `catchtable`.`pickup_time` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`reservation_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`reservation_status` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`reservation_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`reservation_history` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `status_id` INT UNSIGNED NOT NULL,
  `visited_at` DATETIME NULL DEFAULT NULL,
  `reservation_id` INT UNSIGNED NOT NULL,
  `booking_time` DATE NOT NULL,
  `guests_count` TINYINT(6) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `status_id`),
  INDEX `reservation_history_ibfk_1` (`status_id` ASC) VISIBLE,
  INDEX `reservation_history_ibfk_2` (`reservation_id` ASC) VISIBLE,
  CONSTRAINT `reservation_history_ibfk_1`
    FOREIGN KEY (`status_id`)
    REFERENCES `catchtable`.`reservation_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `reservation_history_ibfk_2`
    FOREIGN 
KEY (`reservation_id`)
    REFERENCES `catchtable`.`reservation` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`waiting`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`waiting` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `customer_id` INT UNSIGNED NOT NULL,
  `guest_count` INT NOT NULL,
  `restaurant_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_waitng_customer1` (`customer_id` ASC) VISIBLE,
  INDEX `fk_waiting_restaurant1_idx` (`restaurant_id` ASC) VISIBLE,
  CONSTRAINT `fk_waiting_customer1`
    FOREIGN KEY (`customer_id`)
    REFERENCES `catchtable`.`customer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT 
`fk_waiting_restaurant1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`waiting_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`waiting_status` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`waiting_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`waiting_history` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `waiting_id` INT UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `waiting_status_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_waiting_history_waiting_status1_idx` (`waiting_status_id` ASC) VISIBLE,
  CONSTRAINT `fk_waiting_history_waiting1`
    FOREIGN KEY (`waiting_id`)
    REFERENCES `catchtable`.`waiting` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO 
ACTION,
  CONSTRAINT `fk_waiting_history_waiting_status1`
    FOREIGN KEY (`waiting_status_id`)
    REFERENCES `catchtable`.`waiting_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `catchtable`.`reataurant_bookmark`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`reataurant_bookmark` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `restaurant_id` INT UNSIGNED NOT NULL,
  `customer_id` INT UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_deleted` TINYINT(1) NOT NULL,
  `deleted_at` DATETIME NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_reataurant_bookmark_customer2`
    FOREIGN KEY (`customer_id`)
    REFERENCES `catchtable`.`customer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reataurant_bookmark_restaurant1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON 
DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `catchtable`.`restaurant_food_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`restaurant_food_category` (
  `restaurant_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`name`),
  CONSTRAINT `fk_restaurant_food_category_restaurant1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `catchtable`.`custom_work_schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`custom_work_schedule` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `start_time` TIME NOT NULL,
  `end_time` TIME NOT NULL,
  `restaurant_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_work_schedule_restaurant1_idx` (`restaurant_id` ASC) VISIBLE,
  CONSTRAINT `fk_work_schedule_restaurant1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `catchtable`.`work_schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`work_schedule` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `day_of_week` VARCHAR(1) NOT NULL,
  `start_time` TIME NOT NULL,
  `end_time` TIME NOT NULL,
  `restaurant_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`, `restaurant_id`),
  INDEX `fk_work_schedule_restaurant1_idx` (`restaurant_id` ASC) VISIBLE,
  CONSTRAINT `fk_work_schedule_restaurant10`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `catchtable`.`custom_holiday_schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `catchtable`.`custom_holiday_schedule` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `date` DATE NOT NULL,
  `restaurant_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_work_schedule_restaurant1_idx` (`restaurant_id` ASC) VISIBLE,
  CONSTRAINT `fk_work_schedule_restaurant11`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `catchtable`.`restaurant` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;






SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
