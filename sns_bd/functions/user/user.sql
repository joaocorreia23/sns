-- Verify Email Function 
CREATE OR REPLACE FUNCTION Email_Verify(
	email VARCHAR(255)
)
RETURNS BOOLEAN AS $$
	DECLARE
		email_verification_pattern VARCHAR(255) := '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$';
	BEGIN
		RETURN email ~ email_verification_pattern;
	END;
$$ LANGUAGE plpgsql;
--
--
--
-- Verify Password Function 
CREATE OR REPLACE FUNCTION Password_Verify(
	password VARCHAR(255)
)
RETURNS BOOLEAN AS $$
    BEGIN
        -- Minimum 1 Lowercase Letter
        -- Minimum 1 Uppercase Letter
        -- Minimum 1 Symbol
        -- Minimum length set to 8
        RETURN password ~ '^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+]).{8,}$';
    END;
$$ LANGUAGE plpgsql;
--
--
--
-- Hash Password
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE OR REPLACE FUNCTION hash_password(
	password VARCHAR
)
RETURNS VARCHAR AS $$
    SELECT crypt(hash_password.password, gen_salt('bf', 10))
$$ LANGUAGE SQL;
--
--
--
-- Check Log In
CREATE OR REPLACE FUNCTION Verify_User_Login(
    email VARCHAR(255),
    password VARCHAR(255)
)
RETURNS BOOLEAN AS $$
    DECLARE
        hashed_password VARCHAR(255);
    BEGIN
        SELECT password INTO hashed_password FROM users WHERE email = Verify_User_Login.email;
        RETURN hashed_password = crypt(password, hashed_password);
    END;
$$ LANGUAGE plpgsql;
--
--
--
-- Create User
CREATE OR REPLACE FUNCTION Create_User(
    IN username VARCHAR(64),
    IN email VARCHAR(255),
    IN password VARCHAR(255),
    IN avatar_path VARCHAR(255) DEFAULT NULL
) RETURNS BIGINT AS $$
DECLARE
    new_user_id BIGINT;
BEGIN
    IF username IS NULL OR email IS NULL OR password IS NULL THEN
        RAISE EXCEPTION 'Campos obrigatórios não podem ser nulos';
    END IF;

    -- Check if email is valid
    IF NOT Email_Verify(email) THEN
        RAISE EXCEPTION 'Formato de Email inválido';
    END IF;

    -- Check if email is unique
    IF EXISTS (SELECT 1 FROM users WHERE users.email = Create_User.email) THEN
        RAISE EXCEPTION 'O Email inserido já se encontra registado';
    END IF;

    -- Check if the username is unique
    IF EXISTS (SELECT 1 FROM users WHERE users.username = Create_User.username) THEN
        RAISE EXCEPTION 'O username inserido já se encontra registado';
    END IF;

    -- Validate the password
    IF NOT Password_Verify(password) THEN
        RAISE EXCEPTION 'Formato de Password inválido. A password deve conter: 1 letra maiuscula, 1 letra minuscula, 1 número, 1 símbolo e conter pelo menos 8 caracteres';
    END IF;

    -- Insert the new user
    INSERT INTO users (username, email, password, avatar_path)
    VALUES (username, email, hash_password(password), avatar_path)
    RETURNING id_user INTO new_user_id;

    -- Create Hashed ID
    UPDATE users SET hashed_id = hash_id(id_user) WHERE id_user = new_user_id;-- CHANGE TO ON INSERT

    RETURN new_user_id;
END;
$$ LANGUAGE plpgsql;
--SELECT Create_User('ruizurc', 'ruizurc@gmail.com', '123ppppppppp!', NULL);
--
--
--
-- Update User
CREATE OR REPLACE FUNCTION Update_User(
    IN id_user BIGINT,
    IN hashed_id VARCHAR(255),
    IN username VARCHAR(64),
    IN email VARCHAR(255),
    IN password VARCHAR(255),
    IN avatar_path VARCHAR(255) DEFAULT NULL
) RETURNS BOOLEAN AS $$
DECLARE
    user_id BIGINT;
BEGIN

    IF id_user IS NOT NULL AND hashed_id IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o "hashed_id" ou o "id_user". Ambos foram passados.';
    END IF;

    IF hashed_id IS NOT NULL THEN
        SELECT users.id_user INTO user_id FROM users WHERE hashed_id = hashed_id;
    ELSEIF id_user IS NOT NULL THEN
        SELECT users.id_user INTO user_id FROM users WHERE id_user = id_user;
    ELSE
        RAISE EXCEPTION 'É necessário passar o "hashed_id" ou o "id_user".';
    END IF;

    IF user_id IS NULL AND id_user IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o id_user passado';
    ELSIF user_id IS NULL AND hashed_id IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o hashed_id passado';
    END IF;

    IF username IS NOT NULL AND EXISTS (SELECT 1 FROM users WHERE users.username = Update_User.username AND users.id_user <> user_id) THEN
        RAISE EXCEPTION 'O username inserido já se encontra registado';
    ELSEIF username IS NOT NULL THEN
        UPDATE users SET username = Update_User.username WHERE id_user = user_id;
    END IF;

    IF email IS NOT NULL AND EXISTS (SELECT 1 FROM users WHERE users.email = Update_User.email AND users.id_user <> user_id) THEN
        RAISE EXCEPTION 'O Email inserido já se encontra registado';
    ELSEIF email IS NOT NULL THEN
        UPDATE users SET email = Update_User.email WHERE id_user = user_id;
    END IF;

    IF password IS NOT NULL AND NOT Password_Verify(password) THEN
        RAISE EXCEPTION 'Formato de Password inválido. A password deve conter: 1 letra maiuscula, 1 letra minuscula, 1 número, 1 símbolo e conter pelo menos 8 caracteres';
    ELSEIF password IS NOT NULL THEN
        UPDATE users SET password = hash_password(Update_User.password) WHERE id_user = user_id;
    END IF;

    IF avatar_path IS NOT NULL THEN
        UPDATE users SET avatar_path = Update_User.avatar_path WHERE id_user = user_id;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Get Users OR User
CREATE OR REPLACE FUNCTION Get_Users(
    IN id_user_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL
)
RETURNS TABLE (
    id_user BIGINT,
    hashed_id VARCHAR(255),
    username VARCHAR(64),
    email VARCHAR(255),
    password VARCHAR(255),
    status INT,
    avatar_path VARCHAR(255),
    created_at TIMESTAMP
) AS $$
BEGIN
    IF hashed_id_in IS NULL AND id_user_in IS NULL THEN
        RETURN QUERY SELECT * FROM users; #GET ALL USERS
    ELSIF hashed_id_in IS NULL THEN
        RETURN QUERY SELECT * FROM users WHERE users.id_user = Get_Users.id_user_in; #GET USER BY ID
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Utilizador com o id_user "%" não existe', id_user_in; #USER NOT FOUND
        END IF;
    ELSIF id_user_in IS NULL THEN
        RETURN QUERY SELECT * FROM users WHERE users.hashed_id = Get_Users.hashed_id_in; #GET USER BY HASHED ID
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Utilizador com o hased_id "%" não existe', hashed_id_in; #USER NOT FOUND
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM Get_Users(); --ALL USERS
--SELECT * FROM Get_Users(NULL,'3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e278'); --USER FOUND 
--SELECT * FROM Get_Users(NULL,'3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e279'); --USER NOT FOUND  
--
--
--
-- Create Admin
CREATE OR REPLACE FUNCTION Create_Admin(
    IN id_user BIGINT DEFAULT NULL,
    IN hashed_id VARCHAR(255) DEFAULT NULL,
    IN username VARCHAR(64) DEFAULT NULL,
    IN email VARCHAR(255) DEFAULT NULL,
    IN password VARCHAR(255) DEFAULT NULL,
    IN avatar_path VARCHAR(255) DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
    out_id_user BIGINT;
    out_id_admin BIGINT;
BEGIN
    IF id_user IS NOT NULL AND hashed_id IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_user. Ambos foram passados.';
    END IF;

    IF hashed_id IS NOT NULL THEN
        SELECT id_user INTO out_id_user FROM users WHERE hashed_id = hashed_id;
    ELSE
        out_id_user := id_user;
    END IF;

    IF out_id_user IS NULL THEN
        out_id_user := Create_User(username, email, password, avatar_path);
        --GET HASHED ID
        SELECT users.hashed_id INTO Create_Admin.hashed_id FROM users WHERE users.id_user = out_id_user;
    ELSE
        SELECT users.hashed_id INTO Create_Admin.hashed_id FROM users WHERE users.id_user = out_id_user;
    END IF;

    --Check if user exists
    IF NOT EXISTS (SELECT Get_Users(out_id_user)) THEN
        IF id_user IS NOT NULL THEN
            RAISE EXCEPTION 'Utilizador com o id_user "%" não existe', id_user; --USER NOT FOUND
        ELSE
            RAISE EXCEPTION 'Utilizador com o hashed_id "%" não existe', hashed_id; --USER NOT FOUND
        END IF;
    END IF;

    --Check if user is already an admin
    IF EXISTS (SELECT 1 FROM admin WHERE admin.id_user = out_id_user) THEN
        IF id_user IS NOT NULL THEN
           RAISE EXCEPTION 'Utilizador com o id_user "%" já é um administrador', id_user; --USER ALREADY ADMIN
        ELSE
            RAISE EXCEPTION 'Utilizador com o hashed_id "%" já é um administrador', hashed_id; --USER ALREADY ADMIN
        END IF;
    ELSE
        INSERT INTO admin (id_user) VALUES (out_id_user) RETURNING id_admin INTO out_id_admin;
        INSERT INTO user_role (id_user, role) VALUES (out_id_user, 'Admin');
    END IF;

    RETURN out_id_admin;

END;
$$ LANGUAGE plpgsql;
--SELECT Create_Admin(13, '3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e278', NULL, NULL, NULL, NULL); --Both id_user and hashed_id error
--SELECT Create_Admin(13, NULL, NULL, NULL, NULL, NULL); --id_user already admin
--SELECT Create_Admin(NULL, '3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e278', NULL, NULL, NULL, NULL); --Hashed_id already admin
--
--
--
-- Create Doctor
CREATE OR REPLACE FUNCTION Create_Doctor(
    IN id_user BIGINT DEFAULT NULL,
    IN hashed_id VARCHAR(255) DEFAULT NULL,
    IN username VARCHAR(64) DEFAULT NULL,
    IN email VARCHAR(255) DEFAULT NULL,
    IN password VARCHAR(255) DEFAULT NULL,
    IN avatar_path VARCHAR(255) DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
    out_id_user BIGINT;
    out_id_doctor BIGINT;
BEGIN
    IF id_user IS NOT NULL AND hashed_id IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_user. Ambos foram passados.';
    END IF;

    IF hashed_id IS NOT NULL THEN
        SELECT id_user INTO out_id_user FROM users WHERE hashed_id = hashed_id;
    ELSE
        out_id_user := id_user;
    END IF;

    IF out_id_user IS NULL THEN
        out_id_user := Create_User(username, email, password, avatar_path);
        --GET HASHED ID
        SELECT users.hashed_id INTO Create_Doctor.hashed_id FROM users WHERE users.id_user = out_id_user;
    ELSE
        SELECT users.hashed_id INTO Create_Doctor.hashed_id FROM users WHERE users.id_user = out_id_user;
    END IF;

    --Check if user exists
    IF NOT EXISTS (SELECT Get_Users(out_id_user)) THEN
        IF id_user IS NOT NULL THEN
            RAISE EXCEPTION 'Utilizador com o id_user "%" não existe', id_user; --USER NOT FOUND
        ELSE
            RAISE EXCEPTION 'Utilizador com o hashed_id "%" não existe', hashed_id; --USER NOT FOUND
        END IF;
    END IF;

    --Check if user is already a doctor
    IF EXISTS (SELECT 1 FROM doctor WHERE doctor.id_user = out_id_user) THEN
        IF id_user IS NOT NULL THEN
           RAISE EXCEPTION 'Utilizador com o id_user "%" já é um Médico', id_user; --USER ALREADY DOCTOR
        ELSE
            RAISE EXCEPTION 'Utilizador com o hashed_id "%" já é um Médico', hashed_id; --USER ALREADY DOCTOR
        END IF;
    ELSE
        INSERT INTO doctor (id_user) VALUES (out_id_user) RETURNING id_doctor INTO out_id_doctor;
        INSERT INTO user_role (id_user, role) VALUES (out_id_user, 'Doctor');
    END IF;

    RETURN out_id_doctor;

END;
$$ LANGUAGE plpgsql;
--SELECT Create_Doctor(13, '3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e278', NULL, NULL, NULL, NULL); --Both id_user and hashed_id error
--SELECT Create_Doctor(13, NULL, NULL, NULL, NULL, NULL); --id_user already doctor
--SELECT Create_Doctor(NULL, '3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e278', NULL, NULL, NULL, NULL); --Hashed_id already doctor
--
--
--
-- Create Patient
CREATE OR REPLACE FUNCTION Create_Patient(
    IN id_user BIGINT DEFAULT NULL,
    IN hashed_id VARCHAR(255) DEFAULT NULL,
    IN username VARCHAR(64) DEFAULT NULL,
    IN email VARCHAR(255) DEFAULT NULL,
    IN password VARCHAR(255) DEFAULT NULL,
    IN avatar_path VARCHAR(255) DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
    out_id_user BIGINT;
    out_id_patient BIGINT;
BEGIN
    IF id_user IS NOT NULL AND hashed_id IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_user. Ambos foram passados.';
    END IF;

    IF hashed_id IS NOT NULL THEN
        SELECT id_user INTO out_id_user FROM users WHERE hashed_id = hashed_id;
    ELSE
        out_id_user := id_user;
    END IF;

    IF out_id_user IS NULL THEN
        out_id_user := Create_Patient(username, email, password, avatar_path);
        --GET HASHED ID
        SELECT users.hashed_id INTO Create_Patient.hashed_id FROM users WHERE users.id_user = out_id_user;
    ELSE
        SELECT users.hashed_id INTO Create_Patient.hashed_id FROM users WHERE users.id_user = out_id_user;
    END IF;

    --Check if user exists
    IF NOT EXISTS (SELECT Get_Users(out_id_user)) THEN
        IF id_user IS NOT NULL THEN
            RAISE EXCEPTION 'Utilizador com o id_user "%" não existe', id_user; --USER NOT FOUND
        ELSE
            RAISE EXCEPTION 'Utilizador com o hashed_id "%" não existe', hashed_id; --USER NOT FOUND
        END IF;
    END IF;

    --Check if user is already a patient
    IF EXISTS (SELECT 1 FROM patient WHERE patient.id_user = out_id_user) THEN
        IF id_user IS NOT NULL THEN
           RAISE EXCEPTION 'Utilizador com o id_user "%" já é um Doente', id_user; --USER ALREADY PATIENT
        ELSE
            RAISE EXCEPTION 'Utilizador com o hashed_id "%" já é um Doente', hashed_id; --USER ALREADY PATIENT
        END IF;
    ELSE
        INSERT INTO patient (id_user) VALUES (out_id_user) RETURNING id_patient INTO out_id_patient;
        INSERT INTO user_role (id_user, role) VALUES (out_id_user, 'Patient');
    END IF;

    RETURN out_id_patient;

END;
$$ LANGUAGE plpgsql;
--
--
--
-- Update/Insert User Info
CREATE OR REPLACE FUNCTION Update_User_Info(
    id_user BIGINT DEFAULT NULL,
    hashed_id VARCHAR(255) DEFAULT NULL,
    first_name VARCHAR(255) DEFAULT NULL,
    last_name VARCHAR(255) DEFAULT NULL,
    birth_date DATE DEFAULT NULL,   
    gender gender DEFAULT NULL,
    tax_number INT DEFAULT NULL,
    phone_number VARCHAR(255) DEFAULT NULL,
    contact_email VARCHAR(255) DEFAULT NULL,
    nationality BIGINT DEFAULT NULL,
    door_number VARCHAR(255) DEFAULT NULL,
    floor VARCHAR(255) DEFAULT NULL,
    address VARCHAR(255) DEFAULT NULL,
    zip_code VARCHAR(255) DEFAULT NULL,
    county VARCHAR(255) DEFAULT NULL,
    district VARCHAR(255) DEFAULT NULL,
    id_country BIGINT DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
    out_id_user BIGINT;
    out_id_address BIGINT;
BEGIN
    IF id_user IS NOT NULL AND hashed_id IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_user. Ambos foram passados.';
    ELSEIF id_user IS NULL AND hashed_id IS NULL THEN
        RAISE EXCEPTION 'Tem de ser passado o hashed_id ou o id_user.';
    END IF;

    IF hashed_id IS NOT NULL THEN
        SELECT id_user INTO out_id_user FROM users WHERE hashed_id = hashed_id;
    ELSE
        out_id_user := id_user;
    END IF;

    --Check if user exists
    IF NOT EXISTS (SELECT Get_Users(out_id_user)) THEN
        IF id_user IS NOT NULL THEN
            RAISE EXCEPTION 'Utilizador com o id_user "%" não existe', id_user; --USER NOT FOUND
        ELSE
            RAISE EXCEPTION 'Utilizador com o hashed_id "%" não existe', hashed_id; --USER NOT FOUND
        END IF;
    END IF;

    --Check if user has info
    IF EXISTS (SELECT * FROM user_info WHERE user_info.id_user = Update_User_Info.id_user) THEN 
        --RAISE EXCEPTION 'Utilizador com o id_user "%" já tem informação', Update_User_Info.id_user; --USER ALREADY HAS INFO
        --Check NULL fields
        IF first_name IS NOT NULL THEN
            UPDATE user_info SET first_name = first_name WHERE id_user = Update_User_Info.id_user;
        END IF;
        IF last_name IS NOT NULL THEN
            UPDATE user_info SET last_name = last_name WHERE id_user = Update_User_Info.id_user;
        END IF;
        IF birth_date IS NOT NULL THEN
            UPDATE user_info SET birth_date = birth_date WHERE id_user = Update_User_Info.id_user;
        END IF;
        IF gender IS NOT NULL THEN
            UPDATE user_info SET gender = gender WHERE id_user = Update_User_Info.id_user;
        END IF;
        IF tax_number IS NOT NULL THEN
            UPDATE user_info SET tax_number = tax_number WHERE id_user = Update_User_Info.id_user;
        END IF;
        IF phone_number IS NOT NULL THEN
            UPDATE user_info SET phone_number = phone_number WHERE id_user = Update_User_Info.id_user;
        END IF;
        IF contact_email IS NOT NULL THEN
            UPDATE user_info SET contact_email = contact_email WHERE id_user = Update_User_Info.id_user;
        END IF;
        IF nationality IS NOT NULL THEN
            UPDATE user_info SET nationality = nationality WHERE id_user = Update_User_Info.id_user;
        END IF;

    ELSE 
        --RAISE EXCEPTION 'Utilizador com o id_user "%" não tem informação', Update_User_Info.id_user; --USER DOESN'T HAVE INFO
        --Check NULL fields
        IF first_name IS NULL THEN
            RAISE EXCEPTION 'O primeiro nome não pode ser nulo';
        END IF;
        IF last_name IS NULL THEN
            RAISE EXCEPTION 'O último nome não pode ser nulo';
        END IF;
        IF birth_date IS NULL THEN
            RAISE EXCEPTION 'A data de nascimento não pode ser nula';
        END IF;
        IF gender IS NULL THEN
            RAISE EXCEPTION 'O género não pode ser nulo';
        END IF;
        IF tax_number IS NULL THEN
            RAISE EXCEPTION 'O número de contribuinte não pode ser nulo';
        END IF;
        IF nationality IS NULL THEN
            RAISE EXCEPTION 'A nacionalidade não pode ser nula';
        END IF;

        --Check if address exists
        SELECT Create_Address(door_number, floor, address, zip_code, county, district, id_country) INTO out_id_address;

        IF out_id_address IS NULL THEN
            RAISE EXCEPTION 'O id da morada não pode ser nulo';
        END IF;

        INSERT INTO user_info (first_name, last_name, birth_date, gender, tax_number, phone_number, contact_email, nationality, id_address, id_user) VALUES (Update_User_Info.first_name, Update_User_Info.last_name, Update_User_Info.birth_date, Update_User_Info.gender, Update_User_Info.tax_number, Update_User_Info.contact_email, Update_User_Info.nationality, out_id_address, out_id_user); 

    END IF;

END;
$$ LANGUAGE plpgsql;
--
--
--
--
--
--
--
--
--
--
--