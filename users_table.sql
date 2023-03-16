CREATE SEQUENCE sequence_user START 1 INCREMENT 1;

CREATE TABLE users(
	id_user BIGINT PRIMARY KEY DEFAULT nextval('sequence_user'::regaclass),
	user_name VARCHAR(60) NOT NULL,
	email VARCHAR(255) NOT NULL
	password VARCHAR(255) NOT NULL,
	role VARCHAR(30) NOT NULL,
	status INT NOTNULL DEFAULT 1,
	avatar_path VARCHAR(255),	
	hashed_id VARCHAR(255)
)

