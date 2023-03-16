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
