INSERT INTO user_auth (password_hash, login_id, email) 
VALUES ('hashed_password', 'owner_login', 'owner_email@example.com');

INSERT INTO owner (id) 
VALUES (LAST_INSERT_ID());

INSERT INTO restaurant (name, owner_id) 
VALUES ('Sample Restaurant', LAST_INSERT_ID());

INSERT INTO pickup_time (time, restaurant_id) 
VALUES ('12:00:00', LAST_INSERT_ID());
