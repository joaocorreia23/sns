-- Verify Email Function 
CREATE OR REPLACE FUNCTION email_verify(
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
CREATE OR REPLACE FUNCTION password_verify(
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
CREATE OR REPLACE FUNCTION verify_user_login(
    email VARCHAR(255),
    password VARCHAR(255)
)
RETURNS TABLE (status BOOLEAN, hashed_id VARCHAR(255)) AS $$
DECLARE
    hashed_password VARCHAR(255);
    user_status INTEGER;
BEGIN
    IF email IS NULL THEN
        RAISE EXCEPTION 'O Email não pode ser nulo';
    ELSIF email = '' THEN
        RAISE EXCEPTION 'O Email não pode ser vazio';
    ELSIF email_verify(email) = FALSE THEN
        RAISE EXCEPTION 'O formato do Email é inválido';
    END IF;

    IF password IS NULL THEN
        RAISE EXCEPTION 'A Password não pode ser nula';
    ELSIF password = '' THEN
        RAISE EXCEPTION 'A Password não pode ser vazia';
    END IF;

    SELECT u.password, u.status, u.hashed_id
    INTO hashed_password, user_status, hashed_id
    FROM users u
    WHERE u.email = verify_user_login.email;

    IF hashed_password IS NULL THEN
        RAISE EXCEPTION 'O Email inserido não se encontra registado';
    ELSIF user_status = 0 THEN
        RAISE EXCEPTION 'O utilizador não tem permissões para aceder';
    END IF;

    -- Check if the password is the same as the user's password
    IF hashed_password = crypt(password, hashed_password) THEN
        RETURN QUERY SELECT TRUE, hashed_id;
    ELSE
        RETURN QUERY SELECT FALSE, CAST(NULL AS VARCHAR(255));
    END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Check login new
CREATE OR REPLACE FUNCTION verify_user_login_new(
    email VARCHAR(255),
    password VARCHAR(255)
)
RETURNS TABLE (status BOOLEAN, hashed_id VARCHAR(255), user_role JSON) AS $$
DECLARE
    hashed_password VARCHAR(255);
    user_status INTEGER;
BEGIN
    IF email IS NULL THEN
        RAISE EXCEPTION 'O Email não pode ser nulo';
    ELSIF email = '' THEN
        RAISE EXCEPTION 'O Email não pode ser vazio';
    ELSIF email_verify(email) = FALSE THEN
        RAISE EXCEPTION 'O formato do Email é inválido';
    END IF;

    IF password IS NULL THEN
        RAISE EXCEPTION 'A Password não pode ser nula';
    ELSIF password = '' THEN
        RAISE EXCEPTION 'A Password não pode ser vazia';
    END IF;

    SELECT u.password, u.status, u.hashed_id
    INTO hashed_password, user_status, hashed_id
    FROM users u
    WHERE u.email = verify_user_login_new.email;

    IF hashed_password IS NULL THEN
        RAISE EXCEPTION 'O Email inserido não se encontra registado';
    ELSIF user_status = 0 THEN
        RAISE EXCEPTION 'O utilizador não tem permissões para aceder';
    END IF;

    -- Check if the password is the same as the user's password
    IF hashed_password = crypt(password, hashed_password) THEN
        RETURN QUERY
        SELECT TRUE, u.hashed_id, array_to_json(array_agg(ur.role))
        FROM users u
        JOIN user_role ur ON u.id_user = ur.id_user
        WHERE u.email = verify_user_login_new.email
        GROUP BY u.hashed_id;
    ELSE
        RETURN QUERY SELECT FALSE, CAST(NULL AS VARCHAR(255)), '[]'::JSON;
    END IF;
END;
$$ LANGUAGE plpgsql;

--
--
--
-- Create User Role
CREATE OR REPLACE FUNCTION create_user_role(
    IN id_user_in BIGINT,
    IN hashed_id_in VARCHAR(255),
    IN role role
) RETURNS BOOLEAN AS $$
DECLARE
    user_id BIGINT;
BEGIN

    IF id_user_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o "hashed_id" ou o "id_user". Ambos foram passados.';
    END IF;

    IF hashed_id_in IS NOT NULL THEN
        SELECT users.id_user INTO user_id FROM users WHERE hashed_id = hashed_id_in;
    ELSEIF id_user_in IS NOT NULL THEN
        SELECT users.id_user INTO user_id FROM users WHERE id_user = id_user_in;
    ELSE
        RAISE EXCEPTION 'É necessário passar o "hashed_id" ou o "id_user".';
    END IF;

    IF user_id IS NULL AND id_user_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o id_user passado';
    ELSEIF user_id IS NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o hashed_id passado';
    END IF;

    IF create_user_role.role IS NULL THEN
        RAISE EXCEPTION 'É necessário passar o role';
    --CONVERT ROLE TO VARCHAR
    ELSEIF check_valid_role(create_user_role.role::VARCHAR) = FALSE THEN
        RAISE EXCEPTION 'O role passado não é válido';
    END IF;

    IF EXISTS (SELECT 1 FROM user_role WHERE user_role.id_user = user_id AND user_role.role = create_user_role.role) THEN
        RAISE EXCEPTION 'O utilizador já tem o role passado';
    END IF;

    INSERT INTO user_role (id_user, role) VALUES (user_id, create_user_role.role);
    
    RETURN TRUE;

    
END;
$$ LANGUAGE plpgsql;

SELECT create_user_role(1, NULL, 'Admin');
--
--
--
-- Get User Roles
CREATE OR REPLACE FUNCTION get_user_roles(
    IN id_user_in BIGINT,
    IN hashed_id_in VARCHAR(255)
) RETURNS TABLE (role role) AS $$
DECLARE
    user_id BIGINT;
BEGIN
    IF id_user_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o "hashed_id" ou o "id_user". Ambos foram passados.';
    END IF;

    IF hashed_id_in IS NOT NULL THEN
        SELECT users.id_user INTO user_id FROM users WHERE hashed_id = hashed_id_in;
    ELSEIF id_user_in IS NOT NULL THEN
        SELECT users.id_user INTO user_id FROM users WHERE id_user = id_user_in;
    ELSE
        RAISE EXCEPTION 'É necessário passar o "hashed_id" ou o "id_user".';
    END IF;

    IF user_id IS NULL AND id_user_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o id_user passado';
    ELSEIF user_id IS NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o hashed_id passado';
    END IF;

    RETURN QUERY SELECT user_role.role FROM user_role WHERE user_role.id_user = user_id;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Manage User Roles
CREATE OR REPLACE FUNCTION manage_user_roles(
    IN id_user_in BIGINT,
    IN hashed_id_in VARCHAR(255),
    IN roles VARCHAR[]
) RETURNS BOOLEAN AS $$
DECLARE
    user_id BIGINT;
BEGIN
    IF id_user_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o "hashed_id" ou o "id_user". Ambos foram passados.';
    END IF;

    IF hashed_id_in IS NOT NULL AND hashed_id_in != '' THEN
        SELECT users.id_user INTO user_id FROM users WHERE hashed_id = hashed_id_in;
    ELSIF id_user_in IS NOT NULL THEN
        SELECT users.id_user INTO user_id FROM users WHERE id_user = id_user_in;
    ELSE
        RAISE EXCEPTION 'É necessário passar o "hashed_id" ou o "id_user".';
    END IF;

    IF user_id IS NULL AND id_user_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o id_user passado';
    ELSIF user_id IS NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o hashed_id passado';
    END IF;

    IF roles IS NULL THEN
        RAISE EXCEPTION 'É necessário passar o role';
    END IF;

    --CONVERT ROLE TO VARCHAR
    -- IF ARRAY NOT EMPTY
    IF array_length(roles, 1) > 0 THEN
        FOR i IN 1..array_length(roles, 1) LOOP
            IF check_valid_role(roles[i]) = FALSE THEN
                RAISE EXCEPTION 'O role passado não é válido';
            ELSEIF EXISTS (SELECT 1 FROM user_role WHERE user_role.id_user = user_id AND user_role.role = roles[i]::role) THEN
                --RAISE EXCEPTION 'O utilizador já tem o role passado';
            ELSE 
                INSERT INTO user_role (id_user, role) VALUES (user_id, roles[i]::role);
            END IF;
        END LOOP;
    ELSE
        RAISE EXCEPTION 'Erro! O Utilizador precisa de pelo menos uma Permissão de Acesso.';
    END IF;

    --DELETE FROM user_role WHERE user_role.id_user = user_id AND user_role.role::text = ANY(roles);
	DELETE FROM user_role WHERE user_role.id_user = user_id AND user_role.role NOT IN (SELECT UNNEST(roles)::role);

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM manage_user_roles(1, NULL, ARRAY['Admin', 'User']);
--
--
--
-- Check Valid Role(ENUM)
CREATE OR REPLACE FUNCTION check_valid_role(
    role_name VARCHAR(255)
) RETURNS BOOLEAN AS $$
DECLARE
  valid_roles text[];
BEGIN
  valid_roles := enum_range(NULL::role);
  RETURN role_name = ANY(valid_roles);
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Create User
CREATE OR REPLACE FUNCTION create_user(
    IN username VARCHAR(64),
    IN email VARCHAR(255),
    IN password VARCHAR(255),
    role role
) RETURNS BIGINT AS $$
DECLARE
    new_user_id BIGINT;
BEGIN
    IF username IS NULL OR email IS NULL OR password IS NULL THEN
        RAISE EXCEPTION 'Campos obrigatórios não podem ser nulos';
    END IF;

    -- Check if email is valid
    IF NOT email_verify(email) THEN
        RAISE EXCEPTION 'Formato de Email inválido';
    END IF;

    -- Check if email is unique
    IF EXISTS (SELECT 1 FROM users WHERE users.email = create_user.email) THEN
        RAISE EXCEPTION 'O Email inserido já se encontra registado';
    END IF;

    -- Check if the username is unique
    IF EXISTS (SELECT 1 FROM users WHERE users.username = create_user.username) THEN
        RAISE EXCEPTION 'O username inserido já se encontra registado';
    END IF;

    -- Validate the password
    IF NOT password_verify(password) THEN
        RAISE EXCEPTION 'Formato de Password inválido. A password deve conter: 1 letra maiuscula, 1 letra minuscula, 1 número, 1 símbolo e conter pelo menos 8 caracteres';
    END IF;

    -- Check if the role is valid
    IF role IS NOT NULL THEN
        IF check_valid_role(role::VARCHAR) = FALSE THEN
            RAISE EXCEPTION 'O role passado não é válido';
        END IF;
    ELSE 
        RAISE EXCEPTION 'É necessário passar o role';
    END IF;

    -- Insert the new user
    INSERT INTO users (username, email, password)
    VALUES (username, email, hash_password(password))
    RETURNING id_user INTO new_user_id;

    -- Create Hashed ID
    UPDATE users SET hashed_id = hash_id(id_user) WHERE id_user = new_user_id;-- CHANGE TO ON INSERT

    IF role IS NOT NULL THEN
        PERFORM create_user_role(new_user_id, NULL, role);
    END IF;

    RETURN new_user_id;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Check if user is already in role
CREATE OR REPLACE FUNCTION check_user_role(
    IN id_user_in BIGINT,
    IN hashed_id_in VARCHAR(255),
    IN role VARCHAR(255)
) RETURNS BOOLEAN AS $$
DECLARE
    user_id BIGINT;
BEGIN
    
        IF id_user_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
            RAISE EXCEPTION 'Apenas pode ser passado o "hashed_id" ou o "id_user". Ambos foram passados.';
        END IF;
    
        IF hashed_id_in IS NOT NULL THEN
            SELECT users.id_user INTO user_id FROM users WHERE hashed_id = hashed_id_in;
        ELSEIF id_user_in IS NOT NULL THEN
            SELECT users.id_user INTO user_id FROM users WHERE id_user = id_user_in;
        ELSE
            RAISE EXCEPTION 'É necessário passar o "hashed_id" ou o "id_user".';
        END IF;
    
        IF user_id IS NULL AND id_user_in IS NOT NULL THEN
            RAISE EXCEPTION 'Não existe nenhum utilizador com o id_user passado';
        ELSEIF user_id IS NULL AND hashed_id_in IS NOT NULL THEN
            RAISE EXCEPTION 'Não existe nenhum utilizador com o hashed_id passado';
        END IF;
    
        IF role IS NULL THEN
            RAISE EXCEPTION 'É necessário passar o role';
        --CONVERT ROLE TO VARCHAR
        ELSEIF check_valid_role(role) = FALSE THEN
            RAISE EXCEPTION 'O role passado não é válido';
        END IF;
    
        IF EXISTS (SELECT 1 FROM user_role WHERE user_role.id_user = user_id AND user_role.role = check_user_role.role::role) THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        END IF;
    END;
$$ LANGUAGE plpgsql;
--
--
--
-- Update User
CREATE OR REPLACE FUNCTION update_user(
    IN id_user_in BIGINT,
    IN hashed_id_in VARCHAR(255),
    IN username VARCHAR(64),
    IN email VARCHAR(255),
    IN password VARCHAR(255)
) RETURNS BOOLEAN AS $$
DECLARE
    user_id BIGINT;
BEGIN

    IF id_user_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o "hashed_id" ou o "id_user". Ambos foram passados.';
    END IF;

    IF hashed_id_in IS NOT NULL THEN
        SELECT users.id_user INTO user_id FROM users WHERE hashed_id = hashed_id_in;
    ELSEIF id_user_in IS NOT NULL THEN
        SELECT users.id_user INTO user_id FROM users WHERE id_user = id_user_in;
    ELSE
        RAISE EXCEPTION 'É necessário passar o "hashed_id" ou o "id_user".';
    END IF;

    IF user_id IS NULL AND id_user_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o id_user passado';
    ELSEIF user_id IS NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o hashed_id passado';
    END IF;

    IF username IS NOT NULL AND EXISTS (SELECT 1 FROM users WHERE users.username = update_user.username AND users.id_user <> user_id) THEN
        RAISE EXCEPTION 'O username inserido já se encontra registado';
    ELSEIF username IS NOT NULL THEN
        UPDATE users SET username = update_user.username WHERE id_user = user_id;
    END IF;

    IF email IS NOT NULL AND EXISTS (SELECT 1 FROM users WHERE users.email = update_user.email AND users.id_user <> user_id) THEN
        RAISE EXCEPTION 'O Email inserido já se encontra registado';
    ELSEIF email IS NOT NULL THEN
        UPDATE users SET email = update_user.email WHERE id_user = user_id;
    END IF;

    IF password IS NOT NULL AND NOT password_verify(password) THEN
        RAISE EXCEPTION 'Formato de Password inválido. A password deve conter: 1 letra maiuscula, 1 letra minuscula, 1 número, 1 símbolo e conter pelo menos 8 caracteres';
    ELSEIF password IS NOT NULL THEN
        UPDATE users SET password = hash_password(update_user.password) WHERE id_user = user_id;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Get Users OR User
CREATE OR REPLACE FUNCTION get_users(
    IN id_user_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL,
    role_in VARCHAR(255) DEFAULT NULL,
    status_in INT DEFAULT 1
)
RETURNS TABLE (
    hashed_id VARCHAR(255),
    username VARCHAR(64),
    email VARCHAR(255),
    status INT,
    created_at TIMESTAMP,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
	bith_date DATE,
    gender gender,
    tax_number INT,
    phone_number VARCHAR(255),
    contact_email VARCHAR(255),
    nationality BIGINT,
    nationality_country_name VARCHAR(255),
    id_address BIGINT,
    avatar_path VARCHAR(255),
    door_number VARCHAR(255),
    floor VARCHAR(255),
    address VARCHAR(255),
    zipcode VARCHAR(255),
    county_name VARCHAR(255),
    district_name VARCHAR(255),
    country_name VARCHAR(255),
    id_country BIGINT,
    patient_number VARCHAR(255),
    doctor_number VARCHAR(255)
) AS $$
BEGIN
    IF hashed_id_in IS NOT NULL AND id_user_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não é possível procurar por hashed_id e id_user ao mesmo tempo';
    END IF;

    IF hashed_id_in IS NULL AND id_user_in IS NULL AND role_in IS NULL THEN
        RETURN QUERY SELECT 
            u.hashed_id, u.username, u.email, u.status, u.created_at, 
            uf.first_name, uf.last_name, uf.birth_date, uf.gender, uf.tax_number, uf.phone_number, uf.contact_email, uf.nationality ,cty_n.country_name as nationality_country_name, uf.id_address, uf.avatar_path,
            ad.door_number, ad.floor,
            zc.address, zc.zip_code,
            c.county_name,
            d.district_name,
            cty.country_name, cty.id_country,
            p.patient_number, doc.doctor_number
        FROM users u 
        LEFT JOIN user_info uf ON u.id_user=uf.id_user
        LEFT JOIN address ad ON uf.id_address=ad.id_address
        LEFT JOIN zip_code zc ON ad.id_zip_code=zc.id_zip_code
        LEFT JOIN county c ON zc.id_county=c.id_county
        LEFT JOIN district d ON c.id_district=d.id_district
        LEFT JOIN country cty ON d.id_country=cty.id_country
        LEFT JOIN country cty_n ON uf.nationality=cty_n.id_country
        LEFT JOIN patient p ON u.id_user=p.id_user
        LEFT JOIN doctor doc ON u.id_user=doc.id_user
        WHERE u.status = status_in;

    ELSEIF hashed_id_in IS NULL AND id_user_in IS NULL AND role_in IS NOT NULL THEN

        --Check Valid Role
        IF check_valid_role(role_in) = FALSE THEN
            RAISE EXCEPTION 'O Role "%" não é válido', role_in;
        END IF;

        RETURN QUERY SELECT 
            u.hashed_id, u.username, u.email, u.status, u.created_at, 
            uf.first_name, uf.last_name, uf.birth_date, uf.gender, uf.tax_number, uf.phone_number, uf.contact_email, uf.nationality ,cty_n.country_name as nationality_country_name, uf.id_address, uf.avatar_path,
            ad.door_number, ad.floor,
            zc.address, zc.zip_code,
            c.county_name,
            d.district_name,
            cty.country_name, cty.id_country
        FROM users u 
        LEFT JOIN user_info uf ON u.id_user=uf.id_user
        LEFT JOIN address ad ON uf.id_address=ad.id_address
        LEFT JOIN zip_code zc ON ad.id_zip_code=zc.id_zip_code
        LEFT JOIN county c ON zc.id_county=c.id_county
        LEFT JOIN district d ON c.id_district=d.id_district
        LEFT JOIN country cty ON d.id_country=cty.id_country
        LEFT JOIN country cty_n ON uf.nationality=cty_n.id_country
        JOIN user_role ur ON u.id_user=ur.id_user AND ur.role=role_in::role
        WHERE u.status = status_in;

    ELSEIF hashed_id_in IS NULL THEN
        RETURN QUERY SELECT 
            u.hashed_id, u.username, u.email, u.status, u.created_at, 
            uf.first_name, uf.last_name, uf.birth_date, uf.gender, uf.tax_number, uf.phone_number, uf.contact_email, uf.nationality ,cty_n.country_name as nationality_country_name, uf.id_address, uf.avatar_path,
            ad.door_number, ad.floor,
            zc.address, zc.zip_code,
            c.county_name,
            d.district_name,
            cty.country_name, cty.id_country,
            p.patient_number, doc.doctor_number
        FROM users u 
        LEFT JOIN user_info uf ON u.id_user=uf.id_user
        LEFT JOIN address ad ON uf.id_address=ad.id_address
        LEFT JOIN zip_code zc ON ad.id_zip_code=zc.id_zip_code
        LEFT JOIN county c ON zc.id_county=c.id_county
        LEFT JOIN district d ON c.id_district=d.id_district
        LEFT JOIN country cty ON d.id_country=cty.id_country
        LEFT JOIN country cty_n ON uf.nationality=cty_n.id_country
        LEFT JOIN patient p ON u.id_user=p.id_user
        LEFT JOIN doctor doc ON u.id_user=doc.id_user
        WHERE u.id_user = get_users.id_user_in AND u.status = status_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Utilizador com o id_user "%" não existe', id_user_in; --USER NOT FOUND
        END IF;
    ELSEIF id_user_in IS NULL THEN
       RETURN QUERY SELECT 
            u.hashed_id, u.username, u.email, u.status, u.created_at, 
            uf.first_name, uf.last_name, uf.birth_date, uf.gender, uf.tax_number, uf.phone_number, uf.contact_email, uf.nationality ,cty_n.country_name as nationality_country_name, uf.id_address, uf.avatar_path,
            ad.door_number, ad.floor,
            zc.address, zc.zip_code,
            c.county_name,
            d.district_name,
            cty.country_name, cty.id_country,
            p.patient_number, doc.doctor_number
        FROM users u 
        LEFT JOIN user_info uf ON u.id_user=uf.id_user
        LEFT JOIN address ad ON uf.id_address=ad.id_address
        LEFT JOIN zip_code zc ON ad.id_zip_code=zc.id_zip_code
        LEFT JOIN county c ON zc.id_county=c.id_county
        LEFT JOIN district d ON c.id_district=d.id_district
        LEFT JOIN country cty ON d.id_country=cty.id_country
        LEFT JOIN country cty_n ON uf.nationality=cty_n.id_country
        LEFT JOIN patient p ON u.id_user=p.id_user
        LEFT JOIN doctor doc ON u.id_user=doc.id_user
        WHERE u.hashed_id = get_users.hashed_id_in AND u.status = status_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Utilizador com o hased_id "%" não existe', hashed_id_in; --USER NOT FOUND
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;
--SELECT * FROM get_users(); --ALL USERS
--SELECT * FROM get_users(NULL,'3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e278'); --USER FOUND 
--SELECT * FROM get_users(NULL,'3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e279'); --USER NOT FOUND  
--
--
--
-- Delete User
CREATE OR REPLACE FUNCTION delete_user(
    IN id_user_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    user_id BIGINT;
BEGIN
    IF id_user_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_user. Ambos foram passados.';
    END IF;

    IF hashed_id_in IS NOT NULL THEN
        SELECT users.id_user INTO user_id FROM users WHERE hashed_id = hashed_id_in;
    ELSE
        user_id := id_user_in;
    END IF;

    IF user_id IS NULL AND id_user_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o id_user passado';
    ELSEIF user_id IS NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o hashed_id passado';
    END IF;

    IF (SELECT users.id_user FROM users WHERE users.id_user = user_id AND users.status = 0) IS NOT NULL THEN
        RAISE EXCEPTION 'O utilizador já se encontra desativado';
    END IF;

    UPDATE users SET status = 0 WHERE id_user = user_id;--NOT DELETING USER, JUST DEACTIVATING
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
CREATE OR REPLACE FUNCTION activate_user(
    IN id_user_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    user_id BIGINT;
BEGIN
    IF id_user_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_user. Ambos foram passados.';
    END IF;

    IF hashed_id_in IS NOT NULL THEN
        SELECT users.id_user INTO user_id FROM users WHERE hashed_id = hashed_id_in;
    ELSE
        user_id := id_user_in;
    END IF;

    IF user_id IS NULL AND id_user_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o id_user passado';
    ELSEIF user_id IS NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum utilizador com o hashed_id passado';
    END IF;

    IF (SELECT users.id_user FROM users WHERE users.id_user = user_id AND users.status = 1) IS NOT NULL THEN
        RAISE EXCEPTION 'O utilizador já se encontra ativado';
    END IF;

    UPDATE users SET status = 1 WHERE id_user = user_id;--NOT DELETING USER, JUST DEACTIVATING
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Create Admin
/* CREATE OR REPLACE FUNCTION create_or_update_admin(
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
        out_id_user := create_user(username, email, password, avatar_path);
        --GET HASHED ID
        SELECT users.hashed_id INTO create_admin.hashed_id FROM users WHERE users.id_user = out_id_user;
    ELSE
        SELECT users.hashed_id INTO create_admin.hashed_id FROM users WHERE users.id_user = out_id_user;
    END IF;

    --Check if user exists
    IF NOT EXISTS (SELECT get_users(out_id_user)) THEN
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
$$ LANGUAGE plpgsql; */
--SELECT create_admin(13, '3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e278', NULL, NULL, NULL, NULL); --Both id_user and hashed_id error
--SELECT create_admin(13, NULL, NULL, NULL, NULL, NULL); --id_user already admin
--SELECT create_admin(NULL, '3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e278', NULL, NULL, NULL, NULL); --Hashed_id already admin
--
--
--
-- Check Doctor Number Usage
CREATE OR REPLACE FUNCTION check_doctor_number_usage(
    IN doctor_number VARCHAR(255),
    IN id_user BIGINT DEFAULT NULL,
    IN hashed_id VARCHAR(255) DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    out_id_user BIGINT DEFAULT NULL;
    out_id_doctor BIGINT;
BEGIN
    IF id_user IS NOT NULL AND (hashed_id IS NOT NULL AND hashed_id != '') THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_user. Ambos foram passados.';
    END IF;

    IF hashed_id IS NOT NULL AND hashed_id != '' THEN
        SELECT users.id_user INTO out_id_user FROM users WHERE hashed_id = hashed_id;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Não existe nenhum utilizador com o hashed_id passado';
        END IF;
    ELSE
        SELECT users.id_user INTO out_id_user FROM users WHERE users.id_user = check_doctor_number_usage.id_user;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Não existe nenhum utilizador com o id_user passado';
        END IF;
    END IF;

    IF out_id_user IS NOT NULL THEN
        IF EXISTS (SELECT doctor.id_user FROM doctor WHERE doctor.id_user != out_id_user AND doctor.doctor_number = check_doctor_number_usage.doctor_number) THEN
            RETURN FALSE;
        ELSE
            RETURN TRUE;
        END IF;
    ELSE
        IF EXISTS (SELECT doctor.id_user FROM doctor WHERE doctor.doctor_number = check_doctor_number_usage.doctor_number) THEN
            RETURN FALSE;
        ELSE
            RETURN TRUE;
        END IF;
    END IF;

END;
$$ LANGUAGE plpgsql;
--
--
--
-- Create Doctor
CREATE OR REPLACE FUNCTION create_or_update_doctor(
    IN id_user_in BIGINT DEFAULT NULL,
    IN hashed_id_user_in VARCHAR(255) DEFAULT NULL,
    IN doctor_number VARCHAR(255) DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
    out_id_user BIGINT;
    out_id_doctor BIGINT;
BEGIN
    IF id_user_in IS NOT NULL AND (hashed_id_user_in IS NOT NULL AND hashed_id_user_in != '') THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_user. Ambos foram passados.';
    END IF;

    IF hashed_id_user_in IS NOT NULL AND hashed_id_user_in != '' THEN
        SELECT id_user INTO out_id_user FROM users WHERE hashed_id = hashed_id_user_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Não existe nenhum utilizador com o hashed_id passado';
        END IF;
    ELSE
        SELECT id_user INTO out_id_user FROM users WHERE id_user = id_user_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Não existe nenhum utilizador com o id_user passado';
        END IF;
    END IF;

    IF doctor_number IS NULL OR doctor_number = '' THEN
        RAISE EXCEPTION 'O número de médico não pode ser nulo';
    END IF;

    IF check_doctor_number_usage(doctor_number, out_id_user, NULL) = FALSE THEN
        RAISE EXCEPTION 'O número de médico já está a ser utilizado';
    END IF;

    IF check_user_role(out_id_user, NULL, 'Doctor') = FALSE THEN
        RAISE EXCEPTION 'O utilizador não é um médico';
    ELSE
        SELECT id_doctor INTO out_id_doctor FROM doctor WHERE id_user = out_id_user;
        IF NOT FOUND THEN
            INSERT INTO doctor (id_user, doctor_number) VALUES (out_id_user, create_or_update_doctor.doctor_number) RETURNING id_doctor INTO out_id_doctor;
        ELSE
            UPDATE doctor SET doctor_number = create_or_update_doctor.doctor_number WHERE id_user = out_id_user RETURNING id_doctor INTO out_id_doctor;
        END IF;
    END IF;

    IF out_id_doctor IS NULL THEN
        RAISE EXCEPTION 'Não foi possível adicionar o Numero da Cédula Profissional ao médico';
    ELSE
        RETURN out_id_doctor;
    END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Check Patient Number Usage
CREATE OR REPLACE FUNCTION check_patient_number_usage(
    IN patient_number_in VARCHAR(255),
    IN id_user_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    out_id_user BIGINT DEFAULT NULL;
    out_id_doctor BIGINT;
BEGIN
    IF id_user_in IS NOT NULL AND (hashed_id_in IS NOT NULL AND hashed_id_in != '') THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_user. Ambos foram passados.';
    END IF;

    IF hashed_id_in IS NOT NULL AND hashed_id_in != '' THEN
        SELECT id_user INTO out_id_user FROM users WHERE hashed_id = hashed_id_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Não existe nenhum utilizador com o hashed_id passado';
        END IF;
    ELSE
        SELECT id_user INTO out_id_user FROM users WHERE id_user = id_user_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Não existe nenhum utilizador com o id_user passado';
        END IF;
    END IF;

    IF out_id_user IS NOT NULL THEN
        IF EXISTS (SELECT id_user FROM patient WHERE id_user != out_id_user AND patient_number = patient_number_in) THEN
            RETURN FALSE;
        ELSE
            RETURN TRUE;
        END IF;
    ELSE
        IF EXISTS (SELECT id_user FROM patient WHERE patient_number = patient_number_in) THEN
            RETURN FALSE;
        ELSE
            RETURN TRUE;
        END IF;
    END IF;

END;
$$ LANGUAGE plpgsql;
--
--
--
-- Create or update Patient
CREATE OR REPLACE FUNCTION create_or_update_patient(
    IN id_user_in BIGINT DEFAULT NULL,
    IN hashed_id_user_in VARCHAR(255) DEFAULT NULL,
    IN patient_number_in VARCHAR(255) DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
    out_id_user BIGINT;
    out_id_patient BIGINT;
BEGIN
    IF id_user_in IS NOT NULL AND (hashed_id_user_in IS NOT NULL AND hashed_id_user_in != '') THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_user. Ambos foram passados.';
    END IF;

    IF hashed_id_user_in IS NOT NULL AND hashed_id_user_in != '' THEN
        SELECT id_user INTO out_id_user FROM users WHERE hashed_id = hashed_id_user_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Não existe nenhum utilizador com o hashed_id passado';
        END IF;
    ELSE
        SELECT id_user INTO out_id_user FROM users WHERE id_user = id_user_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Não existe nenhum utilizador com o id_user passado';
        END IF;
    END IF;

    IF patient_number_in IS NULL OR patient_number_in = '' THEN
        RAISE EXCEPTION 'O número de Utente não pode ser nulo';
    END IF;

    IF check_patient_number_usage(patient_number_in, out_id_user, NULL) = FALSE THEN
        RAISE EXCEPTION 'O número de Utente já está a ser utilizado';
    END IF;

    IF check_user_role(out_id_user, NULL, 'Patient') = FALSE THEN
        RAISE EXCEPTION 'O utilizador não é um Utente';
    ELSE
        SELECT id_patient INTO out_id_patient FROM patient WHERE id_user = out_id_user;
        IF NOT FOUND THEN
            INSERT INTO patient (id_user, patient_number) VALUES (out_id_user, patient_number_in) RETURNING id_patient INTO out_id_patient;
        ELSE
            UPDATE patient SET patient_number = patient_number_in WHERE id_user = out_id_user RETURNING id_patient INTO out_id_patient;
        END IF;
    END IF;

    IF out_id_patient IS NULL THEN
        RAISE EXCEPTION 'Não foi possível adicionar o Numero da Utente ao Utente';
    ELSE
        RETURN out_id_patient;
    END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Create Patient
/* CREATE OR REPLACE FUNCTION create_patient(
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
        out_id_user := create_patient(username, email, password, avatar_path);
        --GET HASHED ID
        SELECT users.hashed_id INTO create_patient.hashed_id FROM users WHERE users.id_user = out_id_user;
    ELSE
        SELECT users.hashed_id INTO create_patient.hashed_id FROM users WHERE users.id_user = out_id_user;
    END IF;

    --Check if user exists
    IF NOT EXISTS (SELECT get_users(out_id_user)) THEN
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
$$ LANGUAGE plpgsql; */
--
--
--
-- Update/Insert User Info
CREATE OR REPLACE FUNCTION update_user_info(
    id_user_in BIGINT DEFAULT NULL,
    hashed_id_in VARCHAR(255) DEFAULT NULL,
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
    id_country BIGINT DEFAULT NULL,
    avatar_path VARCHAR(255) DEFAULT NULL,
    doctor_number VARCHAR(255) DEFAULT NULL,
    patient_number VARCHAR(255) DEFAULT NULL
)
RETURNS BIGINT AS $$
DECLARE
    out_id_user BIGINT;
    out_id_address BIGINT;
BEGIN
    IF id_user_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_user. Ambos foram passados.';
    ELSEIF id_user_in IS NULL AND hashed_id_in IS NULL THEN
        RAISE EXCEPTION 'Tem de ser passado o hashed_id ou o id_user.';
    END IF;

    IF hashed_id_in IS NOT NULL THEN
        SELECT id_user INTO out_id_user FROM users WHERE hashed_id = hashed_id_in;
        IF out_id_user IS NULL THEN
            RAISE EXCEPTION 'Utilizador com o hashed_id "%" não existe', hashed_id_in; --USER NOT FOUND
        END IF;
    ELSE
        IF id_user_in IS NULL THEN
            RAISE EXCEPTION 'Tem de ser passado o hashed_id ou o id_user.';
        END IF;
        out_id_user := id_user_in;
    END IF;

    --Check if user exists
    IF NOT EXISTS (SELECT get_users(out_id_user)) THEN
        IF id_user_in IS NOT NULL THEN
            RAISE EXCEPTION 'Utilizador com o id_user "%" não existe', id_user_in; --USER NOT FOUND
        ELSE
            RAISE EXCEPTION 'Utilizador com o hashed_id "%" não existe', hashed_id_in; --USER NOT FOUND
        END IF;
    END IF;

    --Check if user has info
    IF EXISTS (SELECT * FROM user_info WHERE user_info.id_user = out_id_user) THEN 
        IF EXISTS (SELECT * FROM user_info WHERE user_info.id_user != out_id_user AND user_info.tax_number = update_user_info.tax_number) THEN
            RAISE EXCEPTION 'Já existe um utilizador com o NIF "%" ', update_user_info.tax_number; --USER ALREADY HAS INFO
        END IF;
        --RAISE EXCEPTION 'Utilizador com o id_user "%" já tem informação', update_user_info.id_user_in; --USER ALREADY HAS INFO
        --Check NULL fields
        IF update_user_info.first_name IS NOT NULL THEN
            UPDATE user_info SET first_name = update_user_info.first_name WHERE id_user = out_id_user;
        END IF;
        IF update_user_info.last_name IS NOT NULL THEN
            UPDATE user_info SET last_name = update_user_info.last_name WHERE id_user = out_id_user;
        END IF;
        IF update_user_info.birth_date IS NOT NULL THEN
            UPDATE user_info SET birth_date = update_user_info.birth_date WHERE id_user = out_id_user;
        END IF;
        IF update_user_info.gender IS NOT NULL THEN
            UPDATE user_info SET gender = update_user_info.gender WHERE id_user = out_id_user;
        END IF;
        
        IF update_user_info.tax_number IS NOT NULL THEN
            UPDATE user_info SET tax_number = update_user_info.tax_number WHERE id_user = out_id_user;
        END IF;

        IF update_user_info.phone_number IS NOT NULL THEN
            UPDATE user_info SET phone_number = update_user_info.phone_number WHERE id_user = out_id_user;
        END IF;
        IF update_user_info.contact_email IS NOT NULL THEN
            UPDATE user_info SET contact_email = update_user_info.contact_email WHERE id_user = out_id_user;
        END IF;
        IF update_user_info.nationality IS NOT NULL THEN
            UPDATE user_info SET nationality = update_user_info.nationality WHERE id_user = out_id_user;
        END IF;
        IF update_user_info.avatar_path IS NOT NULL THEN
            UPDATE user_info SET avatar_path = update_user_info.avatar_path WHERE id_user = out_id_user;
        END IF;
		
		--Check if address exists
        SELECT create_address(door_number, floor, address, zip_code, county, district, id_country) INTO out_id_address;

        IF out_id_address IS NULL THEN
            RAISE EXCEPTION 'Não foi possível criar o endereço';
        ELSE 
            UPDATE user_info SET id_address = out_id_address WHERE id_user = out_id_user;
        END IF;

        IF doctor_number IS NOT NULL THEN
            IF create_or_update_doctor(out_id_user, NULL, doctor_number) IS NULL THEN
                RAISE EXCEPTION 'Não foi possível criar ou atualizar o médico';
            END IF;
        END IF;

        IF patient_number IS NOT NULL THEN
            IF create_or_update_patient(out_id_user, NULL, patient_number) IS NULL THEN
                RAISE EXCEPTION 'Não foi possível criar ou atualizar o paciente';
            END IF;
        END IF;
    
        RETURN out_id_user;
    ELSE 
        --RAISE EXCEPTION 'Utilizador com o id_user "%" não tem informação', update_user_info.id_user_in; --USER DOESN'T HAVE INFO
        --Check NULL fields
        IF update_user_info.first_name IS NULL THEN
            RAISE EXCEPTION 'O primeiro nome não pode ser nulo';
        END IF;
        IF update_user_info.last_name IS NULL THEN
            RAISE EXCEPTION 'O último nome não pode ser nulo';
        END IF;
        IF update_user_info.birth_date IS NULL THEN
            RAISE EXCEPTION 'A data de nascimento não pode ser nula';
        END IF;
        IF update_user_info.gender IS NULL THEN
            RAISE EXCEPTION 'O género não pode ser nulo';
        END IF;
        IF update_user_info.tax_number IS NULL THEN
            RAISE EXCEPTION 'O número de contribuinte não pode ser nulo';
        END IF;
        IF EXISTS (SELECT * FROM user_info WHERE user_info.tax_number = update_user_info.tax_number) THEN
            RAISE EXCEPTION 'Já existe um utilizador com o NIF "%" ', update_user_info.tax_number; --USER ALREADY HAS INFO
        END IF;
        IF update_user_info.nationality IS NULL THEN
            RAISE EXCEPTION 'A nacionalidade não pode ser nula';
        END IF;

        --Check if address exists
        SELECT create_address(door_number, floor, address, zip_code, county, district, id_country) INTO out_id_address;

        IF out_id_address IS NULL THEN
            RAISE EXCEPTION 'Não foi possível criar o endereço';
        END IF;

        INSERT INTO user_info (first_name, last_name, avatar_path, birth_date, gender, tax_number, phone_number, contact_email, nationality, id_address, id_user) VALUES (update_user_info.first_name, update_user_info.last_name, update_user_info.avatar_path, update_user_info.birth_date, update_user_info.gender, update_user_info.tax_number, update_user_info.phone_number, update_user_info.contact_email, update_user_info.nationality, out_id_address, out_id_user); 
        UPDATE users SET status=1 WHERE id_user = out_id_user;

        IF doctor_number IS NOT NULL THEN
            IF create_or_update_doctor(out_id_user, NULL, doctor_number) IS NULL THEN
                RAISE EXCEPTION 'Não foi possível criar ou atualizar o médico';
            END IF;
        END IF;

        IF patient_number IS NOT NULL THEN
            IF create_or_update_patient(out_id_user, NULL, patient_number) IS NULL THEN
                RAISE EXCEPTION 'Não foi possível criar ou atualizar o paciente';
            END IF;
        END IF;
        RETURN out_id_user;
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
--
--
--






