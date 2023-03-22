CREATE SEQUENCE sequence_user START 1 INCREMENT 1;

CREATE TABLE users(
	id_user BIGINT PRIMARY KEY DEFAULT nextval('sequence_user'::regclass),
	user_name VARCHAR(60) NOT NULL,
	email VARCHAR(255) NOT NULL,
	password VARCHAR(255) NOT NULL,
	role role NOT NULL,
	status INT NOT NULL DEFAULT 1,
	avatar_path VARCHAR(255),	
	hashed_id VARCHAR(255)
)

SELECT * FROM users

-- Status = 0 (Inativo)
-- Status = 1 (Ativo)

-- Role = 0 (Administração)
-- Role = 1 (Médico)
-- Role = 2 (Doente)

CREATE TYPE role AS ENUM (
   'Administração', 'Médico', 'Doente'
)

CREATE OR REPLACE FUNCTION check_real_id(
	hashed_id VARCHAR,
) AS id_user
BEGIN
	IF hashed_id IS NOT NULL THEN
		SELECT id_user FROM users WHERE hashed_id = hashed_id;
	END IF;
END

CREATE OR REPLACE PROCEDURE insert_user(
	user_name VARCHAR,
	email VARCHAR,
	password VARCHAR,
	role role,
	avatar_path VARCHAR,
) AS $$
BEGIN
	IF user_name IS NOT NULL AND email IS NOT NULL AND password IS NOT NULL AND role IS NOT NULL THEN
        INSERT INTO users (user_name, email, password, role, avatar_path)
        VALUES (user_name, email, password, role, avatar_path);
    END IF;
END;
$$ LANGUAGE PLPGSQL


CREATE OR REPLACE A PROCEDURE update_user(
	id_user BIGINT,
	user_name VARCHAR,
	email VARCHAR,
	password VARCHAR,
	role role,
	status INT,
	avatar_path VARCHAR,
) AS $$
	IF id_user IS NOT NULL AND user_name IS NOT NULL AND email IS NOT NULL AND password IS NOT NULL AND role IS NOT NULL AND status IS NOT NULL THEN
		UPDATE users SET user_name = user_name, email = email, password = password, role = role, status = status, avatar_path = avatar_path WHERE id_user = id_user;
	END IF;
END;
$$ LANGUAGE PLPGSQL


CREATE OR REPLACE PROCEDURE delete_user(
	id_user BIGINT, 
) AS $$
BEGIN 
	IF id_user IS NOT NULL THEN
		DELETE FROM users WHERE id_user = id_user
	END IF;
END;
$$ LANGUAGE PLPGSQL
