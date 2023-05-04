CREATE EXTENSION IF NOT EXISTS pgcrypto;
-- CREATE HASHED ID
CREATE OR REPLACE FUNCTION hash_id(
	id BIGINT
)
RETURNS VARCHAR(255) AS $$
BEGIN
    RETURN encode(digest(id::text, 'sha256'), 'hex');
END;
$$ LANGUAGE plpgsql;

-- =======================
-- BEGIN: ADDRESS
-- =======================
-- Drops
--DROP TABLE address;
--DROP SEQUENCE address_sequence;

--DROP TABLE zip_code;
--DROP SEQUENCE zip_code_sequence;

--DROP TABLE county;
--DROP SEQUENCE county_sequence;

--DROP TABLE district;
--DROP SEQUENCE district_sequence;

--DROP TABLE country;
--DROP SEQUENCE country_sequence;

-- Country Sequence
CREATE SEQUENCE country_sequence
INCREMENT 1
START 1;

-- District Sequence
CREATE SEQUENCE district_sequence
INCREMENT 1
START 1;

-- County Sequence
CREATE SEQUENCE county_sequence
INCREMENT 1
START 1;

-- Zip Code Sequence
CREATE SEQUENCE zip_code_sequence
INCREMENT 1
START 1;

-- Address Sequence
CREATE SEQUENCE address_sequence
INCREMENT 1
START 1;


-- Country Table
CREATE TABLE country (
	id_country BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('country_sequence'::regclass),
	country_name VARCHAR(255) UNIQUE NOT NULL
);
INSERT INTO country (country_name) VALUES ('Afeganistão'), ('África do Sul'), ('Albânia'), ('Alemanha'), ('Andorra'), ('Angola'), ('Antígua e Barbuda'), ('Arábia Saudita'), ('Argélia'), ('Argentina'), ('Arménia'), ('Austrália'), ('Áustria'), ('Azerbaijão'), ('Bahamas'), ('Bangladesh'), ('Barbados'), ('Barém'), ('Bélgica'), ('Belize'), ('Benim'), ('Bielorrússia'), ('Bolívia'), ('Bósnia e Herzegovina'), ('Botsuana'), ('Brasil'), ('Brunei'), ('Bulgária'), ('Burquina Faso'), ('Burundi'), ('Butão'), ('Cabo Verde'), ('Camarões'), ('Camboja'), ('Canadá'), ('Catar'), ('Cazaquistão'), ('Chade'), ('Chile'), ('China'), ('Chipre'), ('Colômbia'), ('Comores'), ('Congo-Brazzaville'), ('Congo-Kinshasa'), ('Coreia do Norte'), ('Coreia do Sul'), ('Cosovo'), ('Costa do Marfim'), ('Costa Rica'), ('Croácia'), ('Cuaite'), ('Cuba'), ('Dinamarca'), ('Dominica'), ('Egito'), ('Emirados Árabes Unidos'), ('Equador'), ('Eritreia'), ('Eslováquia'), ('Eslovénia'), ('Espanha'), ('Estónia'), ('Etiópia'), ('Fiji'), ('Filipinas'), ('Finlândia'), ('França'), ('Gabão'), ('Gâmbia'), ('Gana'), ('Geórgia'), ('Granada'), ('Grécia'), ('Guatemala'), ('Guiana'), ('Guiné'), ('Guiné Equatorial'), ('Guiné-Bissau'), ('Haiti'), ('Honduras'), ('Hungria'), ('Iémen'), ('Ilhas Marechal'), ('Índia'), ('Indonésia'), ('Irão'), ('Iraque'), ('Irlanda'), ('Islândia'), ('Israel'), ('Itália'), ('Jamaica'), ('Japão'), ('Jibuti'), ('Jordânia'), ('Laus'), ('Lesoto'), ('Letónia'), ('Líbano'), ('Libéria'), ('Líbia'), ('Listenstaine'), ('Lituânia'), ('Luxemburgo'), ('Macedónia do Norte'), ('Madagáscar'), ('Malásia'), ('Malaui'), ('Maldivas'), ('Mali'), ('Malta'), ('Marrocos'), ('Maurícia'), ('Mauritânia'), ('México'), ('Micronésia'), ('Moçambique'), ('Moldávia'), ('Namíbia'), ('Nauru'), ('Nepal'), ('Nicarágua'), ('Níger'), ('Nigéria'), ('Noruega'), ('Nova Zelândia'), ('Omã'), ('Países Baixos'), ('Palau'), ('Panamá'), ('Papua Nova Guiné'), ('Paquistão'), ('Paraguai'), ('Peru'), ('Polónia'), ('Portugal'), ('Quénia'), ('Quirguistão'), ('Quiribáti'), ('Reino Unido'), ('República Centro-Africana'), ('República Checa'), ('República Democrática do Congo'), ('República do Congo'), ('República Dominicana'), ('Roménia'), ('Ruanda'), ('Rússia'), ('Salomão'), ('Salvador'), ('Samoa'), ('Santa Lúcia'), ('São Cristóvão e Neves'), ('São Marinho'), ('São Tomé e Príncipe'), ('São Vicente e Granadinas'), ('Seicheles'), ('Senegal'), ('Serra Leoa'), ('Sérvia'), ('Singapura'), ('Síria'), ('Somália'), ('Sri Lanka'), ('Suazilândia'), ('Sudão'), ('Sudão do Sul'), ('Suécia'), ('Suíça'), ('Suriname'), ('Tailândia'), ('Taiwan'), ('Tajiquistão'), ('Tanzânia'), ('Timor-Leste'), ('Togo'), ('Tonga'), ('Trindade e Tobago'), ('Tunísia'), ('Turcomenistão'), ('Turquia'), ('Tuvalu'), ('Ucrânia'), ('Uganda'), ('Uruguai'), ('Usbequistão'), ('Vanuatu'), ('Vaticano'), ('Venezuela'), ('Vietname'), ('Zâmbia'), ('Zimbábue');

-- District Table
CREATE TABLE district (
	id_district BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('district_sequence'::regclass),
	district_name VARCHAR(255) NOT NULL,
	id_country BIGINT NOT NULL,
	FOREIGN KEY (id_country) REFERENCES country(id_country)
);

-- County Table
CREATE TABLE county (
	id_county BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('county_sequence'::regclass),
	county_name VARCHAR(255) NOT NULL,
	id_district BIGINT NOT NULL,
	FOREIGN KEY (id_district) REFERENCES district(id_district)
);

-- County Table
CREATE TABLE zip_code (
	id_zip_code BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('zip_code_sequence'::regclass),
	address VARCHAR(255) NOT NULL,
	zip_code VARCHAR(255) NOT NULL,
	id_county BIGINT NOT NULL,
	FOREIGN KEY (id_county) REFERENCES county(id_county)
);

-- Address Table
CREATE TABLE address (
	id_address BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('address_sequence'::regclass),
	door_number VARChAR(255) NULL,
	floor VARCHAR(255) NULL,
	id_zip_code BIGINT NOT NULL,
	FOREIGN KEY (id_zip_code) REFERENCES zip_code(id_zip_code)
);

-- =======================
-- END: ADDRESS
-- =======================

-- =======================
-- BEGIN: USER
-- =======================

-- Drops
--DROP TABLE user_info;

--DROP TABLE users;
--DROP SEQUENCE user_sequence;

--DROP TABLE user_role;

--DROP TYPE gender;
--DROP TYPE role;

--DROP TABLE admin;
--DROP SEQUENCE admin_sequence;

--DROP TABLE doctor;
--DROP SEQUENCE doctor_sequence;

--DROP TABLE patient;
--DROP SEQUENCE patient_sequence;

-- User Sequence
CREATE SEQUENCE user_sequence
INCREMENT 1
START 1;

-- Admin Sequence 
CREATE SEQUENCE admin_sequence
INCREMENT 1
START 1;

-- Doctor Sequence 
CREATE SEQUENCE doctor_sequence
INCREMENT 1
START 1;

-- Patient Sequence 
CREATE SEQUENCE patient_sequence
INCREMENT 1
START 1;

-- User Gender Type
CREATE TYPE gender AS ENUM ('Masculino', 'Feminino', 'Outro');

-- User Role Type
CREATE TYPE role AS ENUM ('Admin', 'Doctor', 'Patient');

-- User Table
CREATE TABLE users (
	id_user BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('user_sequence'::regclass),
	hashed_id VARCHAR(255) NULL,
	username VARCHAR(64) UNIQUE NOT NULL,
	email VARCHAR(255) UNIQUE NOT NULL,
	password VARCHAR(255) NOT NULL,
	status INT NOT NULL DEFAULT 0,
	avatar_path VARCHAR(255) NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

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

-- Hash Password
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE OR REPLACE FUNCTION hash_password(
	password VARCHAR
)
RETURNS VARCHAR AS $$
    SELECT crypt(hash_password.password, gen_salt('bf', 10))
$$ LANGUAGE SQL;


-- Check Log In
CREATE OR REPLACE FUNCTION verify_user_login(
    email VARCHAR(255),
    password VARCHAR(255)
)
RETURNS BOOLEAN AS $$
    DECLARE
        hashed_password VARCHAR(255);
    BEGIN
        SELECT password INTO hashed_password FROM users WHERE email = verify_user_login.email;
        RETURN hashed_password = crypt(password, hashed_password);
    END;
$$ LANGUAGE plpgsql;

-- Create User
CREATE OR REPLACE FUNCTION create_user(
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

    -- Insert the new user
    INSERT INTO users (username, email, password, avatar_path)
    VALUES (username, email, hash_password(password), avatar_path)
    RETURNING id_user INTO new_user_id;

    -- Create Hashed ID
    UPDATE users SET hashed_id = hash_id(id_user) WHERE id_user = new_user_id;-- CHANGE TO ON INSERT

    RETURN new_user_id;
END;
$$ LANGUAGE plpgsql;
--SELECT create_user('ruizurc', 'ruizurc@gmail.com', '123ppppppppp!', NULL);

-- Update User
CREATE OR REPLACE FUNCTION update_user(
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
    ELSEIF user_id IS NULL AND hashed_id IS NOT NULL THEN
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

    IF avatar_path IS NOT NULL THEN
        UPDATE users SET avatar_path = update_user.avatar_path WHERE id_user = user_id;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Get Users OR User
CREATE OR REPLACE FUNCTION get_users(
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
    ELSEIF hashed_id_in IS NULL THEN
        RETURN QUERY SELECT * FROM users WHERE users.id_user = get_users.id_user_in; #GET USER BY ID
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Utilizador com o id_user "%" não existe', id_user_in; #USER NOT FOUND
        END IF;
    ELSEIF id_user_in IS NULL THEN
        RETURN QUERY SELECT * FROM users WHERE users.hashed_id = get_users.hashed_id_in; #GET USER BY HASHED ID
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Utilizador com o hased_id "%" não existe', hashed_id_in; #USER NOT FOUND
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;

--SELECT * FROM get_users(); --ALL USERS
--SELECT * FROM get_users('3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e278'); --USER FOUND 
--SELECT * FROM get_users('3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e279'); --USER NOT FOUND  

-- Create Admin
CREATE OR REPLACE FUNCTION create_admin(
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
    IF NOT EXISTS (SELECT get_users(NULL,hashed_id)) THEN
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
--SELECT create_admin(13, '3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e278', NULL, NULL, NULL, NULL); --Both id_user and hashed_id error
--SELECT create_admin(13, NULL, NULL, NULL, NULL, NULL); --id_user already admin
--SELECT create_admin(NULL, '3fdba35f04dc8c462986c992bcf875546257113072a909c162f7e470e581e278', NULL, NULL, NULL, NULL); --Hashed_id already admin

-- UserInfo Table
CREATE TABLE user_info (
	id_user BIGINT UNIQUE NOT NULL,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	birth_date DATE NOT NULL,
	gender gender NOT NULL,
	tax_number INT UNIQUE NOT NULL,
	phone_number VARCHAR(255) NULL,
	contact_email VARCHAR(255) NULL,
	nationality BIGINT NOT NULL,--Nationality
	id_address BIGINT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_user) REFERENCES users(id_user),
	FOREIGN KEY (nationality) REFERENCES country(id_country),
	FOREIGN KEY (id_address) REFERENCES address(id_address)
);

-- Update/Insert User Info
CREATE OR REPLACE FUNCTION update_user_info(
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
    IF NOT EXISTS (SELECT get_users(out_id_user)) THEN
        IF id_user IS NOT NULL THEN
            RAISE EXCEPTION 'Utilizador com o id_user "%" não existe', id_user; --USER NOT FOUND
        ELSE
            RAISE EXCEPTION 'Utilizador com o hashed_id "%" não existe', hashed_id; --USER NOT FOUND
        END IF;
    END IF;

    --Check if user has info
    IF EXISTS (SELECT * FROM user_info WHERE user_info.id_user = update_user_info.id_user) THEN 
        --RAISE EXCEPTION 'Utilizador com o id_user "%" já tem informação', update_user_info.id_user; --USER ALREADY HAS INFO
        --Check NULL fields
        IF first_name IS NOT NULL THEN
            UPDATE user_info SET first_name = first_name WHERE id_user = update_user_info.id_user;
        END IF;
        IF last_name IS NOT NULL THEN
            UPDATE user_info SET last_name = last_name WHERE id_user = update_user_info.id_user;
        END IF;
        IF birth_date IS NOT NULL THEN
            UPDATE user_info SET birth_date = birth_date WHERE id_user = update_user_info.id_user;
        END IF;
        IF gender IS NOT NULL THEN
            UPDATE user_info SET gender = gender WHERE id_user = update_user_info.id_user;
        END IF;
        IF tax_number IS NOT NULL THEN
            UPDATE user_info SET tax_number = tax_number WHERE id_user = update_user_info.id_user;
        END IF;
        IF phone_number IS NOT NULL THEN
            UPDATE user_info SET phone_number = phone_number WHERE id_user = update_user_info.id_user;
        END IF;
        IF contact_email IS NOT NULL THEN
            UPDATE user_info SET contact_email = contact_email WHERE id_user = update_user_info.id_user;
        END IF;
        IF nationality IS NOT NULL THEN
            UPDATE user_info SET nationality = nationality WHERE id_user = update_user_info.id_user;
        END IF;

    ELSE 
        --RAISE EXCEPTION 'Utilizador com o id_user "%" não tem informação', update_user_info.id_user; --USER DOESN'T HAVE INFO
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
        SELECT create_address(door_number, floor, address, zip_code, county, district, id_country) INTO out_id_address;

        IF out_id_address IS NULL THEN
            RAISE EXCEPTION 'O id da morada não pode ser nulo';
        END IF;

        INSERT INTO user_info (first_name, last_name, birth_date, gender, tax_number, phone_number, contact_email, nationality, id_address, id_user) VALUES (update_user_info.first_name, update_user_info.last_name, update_user_info.birth_date, update_user_info.gender, update_user_info.tax_number, update_user_info.contact_email, update_user_info.nationality, out_id_address, out_id_user); 

    END IF;

END;
$$ LANGUAGE plpgsql;

--User Address
CREATE OR REPLACE FUNCTION create_address(
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
    out_id_address BIGINT;
    out_id_district BIGINT;
    out_id_county BIGINT;
    out_id_zip_code BIGINT;
BEGIN

    IF id_country IS NULL THEN  
        RAISE EXCEPTION 'O id do país não pode ser nulo';
    END IF;

    --Check if district exists
    IF NOT EXISTS (SELECT id_district FROM district WHERE district.district_name = create_address.district AND district.id_country = create_address.id_country) THEN
        --DISTRICT NOT FOUND
        IF district IS NULL THEN
            RAISE EXCEPTION 'O distrito não pode ser nulo';
        ELSE
            INSERT INTO district (district_name, id_country) VALUES (create_address.district, create_address.id_country) RETURNING id_district INTO out_id_district;
        END IF;   
    ELSE
        SELECT id_district INTO out_id_district FROM district WHERE district.district_name = create_address.district AND district.id_country = create_address.id_country;
    END IF;

    --Check if county exists
    IF NOT EXISTS (SELECT id_county FROM county WHERE county.county_name = create_address.county AND county.id_district = out_id_district) THEN
       --COUNTY NOT FOUND
       IF county IS NULL THEN
            RAISE EXCEPTION 'O concelho não pode ser nulo';
        ELSE
            INSERT INTO county (county_name, id_district) VALUES (create_address.county, out_id_district) RETURNING id_county INTO out_id_county;
        END IF;
    ELSE
        SELECT id_county INTO out_id_county FROM county WHERE county.county_name = create_address.county AND county.id_district = out_id_district;
    END IF;

    --Check if Zip Code exists
    IF NOT EXISTS (SELECT id_zip_code FROM zip_code WHERE zip_code.zip_code = create_address.zip_code AND zip_code.id_county = out_id_county) THEN
        --ZIP CODE NOT FOUND
        IF zip_code IS NULL THEN
            RAISE EXCEPTION 'O código postal não pode ser nulo';
        ELSEIF address IS NULL THEN
            RAISE EXCEPTION 'O endereço não pode ser nulo';
        ELSE
            INSERT INTO zip_code (zip_code, address, id_county) VALUES (create_address.zip_code, create_address.address, out_id_county) RETURNING id_zip_code INTO out_id_zip_code;
        END IF;
    ELSE
        SELECT id_zip_code INTO out_id_zip_code FROM zip_code WHERE zip_code.zip_code = create_address.zip_code AND zip_code.id_county = out_id_county;
    END IF;
    
    --Check if address exists
    IF NOT EXISTS (SELECT id_address FROM address WHERE address.door_number = create_address.door_number AND address.floor = create_address.floor AND address.address = create_address.address AND address.id_zip_code = out_id_zip_code) THEN
        --ADDRESS NOT FOUND
        IF door_number IS NULL THEN
            RAISE EXCEPTION 'O número da porta não pode ser nulo';
        ELSE
            INSERT INTO address (door_number, floor, address, id_zip_code) VALUES (create_address.door_number, create_address.floor, create_address.address, out_id_zip_code) RETURNING id_address INTO out_id_address;
        END IF;
    ELSE
        SELECT id_address INTO out_id_address FROM address WHERE address.door_number = create_address.door_number AND address.floor = create_address.floor AND address.address = create_address.address AND address.id_zip_code = out_id_zip_code;
    END IF;

    RETURN out_id_address;
END;
$$ LANGUAGE plpgsql;

-- UserRole Table
CREATE TABLE user_role (
	id_user BIGINT NOT NULL,
	role role NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_user) REFERENCES users(id_user)
);
--ALTER TABLE user_role ALTER COLUMN role TYPE role USING role::role;

-- Admin Table
CREATE TABLE admin (
	id_admin BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('admin_sequence'::regclass),
	id_user BIGINT NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_user) REFERENCES users(id_user)
);

-- Doctor Table
CREATE TABLE doctor (
	id_doctor BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('doctor_sequence'::regclass),
	id_user BIGINT NOT NULL,
	doctor_number INT UNIQUE NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_user) REFERENCES users(id_user)
);

-- Patient Table
CREATE TABLE patient (
	id_patient BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('patient_sequence'::regclass),
	id_user BIGINT NOT NULL,
	patient_number INT UNIQUE NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_user) REFERENCES users(id_user)
);

-- =======================
-- END: USER
-- =======================

-- =======================
-- BEGIN: HEALTH UNIT
-- =======================

-- Drops
--DROP TABLE health_unit_doctor;
--DROP TABLE health_unit_patient;
--DROP TABLE health_unit;
--DROP SEQUENCE health_unit_sequence;

-- Health Unit Sequence
CREATE SEQUENCE health_unit_sequence
INCREMENT 1
START 1;

-- Health Unit Table
CREATE TABLE health_unit (
	id_health_unit BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('health_unit_sequence'::regclass),
	created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Health Unit Doctor Table
CREATE TABLE health_unit_doctor (
	id_health_unit BIGINT NOT NULL,
	id_user BIGINT NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_health_unit) REFERENCES health_unit(id_health_unit),
	FOREIGN KEY (id_user) REFERENCES users(id_user)
);

-- Health Unit Patient Table
CREATE TABLE health_unit_patient (
	id_health_unit BIGINT NOT NULL,
	id_user BIGINT NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_health_unit) REFERENCES health_unit(id_health_unit),
	FOREIGN KEY (id_user) REFERENCES users(id_user)
);

-- =======================
-- END: HEALTH UNIT
-- =======================

-- =======================
-- BEGIN: APPOINTMENT
-- =======================

-- Drops
--DROP TABLE appointment;
--DROP SEQUENCE appointment_sequence;

-- Appointment Sequence
CREATE SEQUENCE appointment_sequence
INCREMENT 1
START 1;

-- Appointment Table
CREATE TABLE appointment (
	id_appointment BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('appointment_sequence'::regclass),
	id_health_unit BIGINT NOT NULL,
	id_user_doctor BIGINT NOT NULL,
	id_user_patient BIGINT NOT NULL,
	status INT NOT NULL DEFAULT 0,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_health_unit) REFERENCES health_unit(id_health_unit),
	FOREIGN KEY (id_user_doctor) REFERENCES users(id_user),
	FOREIGN KEY (id_user_patient) REFERENCES users(id_user)
);

-- =======================
-- END: APPOINTMENT
-- =======================

-- =======================
-- BEGIN: MEDICATION
-- =======================

-- Drops
--DROP TABLE medication;
--DROP SEQUENCE medication_sequence;

-- Medication Sequence
CREATE SEQUENCE medication_sequence
INCREMENT 1
START 1;

-- Prescription Sequence
CREATE SEQUENCE prescription_sequence
INCREMENT 1
START 1;

-- Medication Prescription Sequence
CREATE SEQUENCE medication_prescription_sequence
INCREMENT 1
START 1;

-- Usual Medication Sequence
CREATE SEQUENCE usual_medication_sequence
INCREMENT 1
START 1;

-- Medication Table
CREATE TABLE medication (
	id_medication BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('medication_sequence'::regclass),
	medication_name VARCHAR(255) UNIQUE NOT NULL,
	status INT NOT NULL DEFAULT 0,
	created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Prescription Table
CREATE TABLE prescription (
	id_prescription BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('prescription_sequence'::regclass),
    id_doctor BIGINT NOT NULL,
    id_patient BIGINT NOT NULL,
    id_appointment BIGINT NOT NULL,
    prescription_date TIMESTAMP NOT NULL DEFAULT NOW(),
    status INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id_doctor) REFERENCES doctor(id_doctor),
    FOREIGN KEY (id_patient) REFERENCES patient(id_patient),
    FOREIGN KEY (id_appointment) REFERENCES appointment(id_appointment)
);

-- Medication Prescription Table
CREATE TABLE medication_prescription (
    id_medication_prescription BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('medication_prescription_sequence'::regclass),
    id_prescription BIGINT NOT NULL,
    id_medication BIGINT NOT NULL,
    access_pin INT NULL,
    option_pin INT NULL,
    prescription_number INT NULL,
    expiration_date TIMESTAMP NULL,
    prescribed_amount FLOAT NOT NULL,
    available_amount FLOAT NOT NULL,
    use_description VARCHAR(255) NULL,
    status INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id_prescription) REFERENCES prescription(id_prescription),
    FOREIGN KEY (id_medication) REFERENCES medication(id_medication)
);

-- Usual Medication Table
CREATE TABLE usual_medication (
    id_usual_medication BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('usual_medication_sequence'::regclass),
    id_patient BIGINT NOT NULL,
    id_medication BIGINT NOT NULL,
    id_medication_prescription BIGINT NULL,
    status INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id_patient) REFERENCES patient(id_patient),
    FOREIGN KEY (id_medication) REFERENCES medication(id_medication),
    FOREIGN KEY (id_medication_prescription) REFERENCES medication_prescription(id_medication_prescription)
);

-- =======================
-- END: MEDICATION
-- =======================

-- =======================
-- BEGIN: VACCINE
-- =======================

-- Drops
--DROP TABLE vaccine;
--DROP SEQUENCE vaccine_sequence;

-- Vaccine Sequence
CREATE SEQUENCE vaccine_sequence
INCREMENT 1
START 1;

-- Administered Vaccine Sequence
CREATE SEQUENCE administered_vaccine_sequence
INCREMENT 1
START 1;

-- Vaccine Table
CREATE TABLE vaccine (
	id_vaccine BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('vaccine_sequence'::regclass),
	vaccine_name VARCHAR(255) UNIQUE NOT NULL,
	status INT NOT NULL DEFAULT 0,
	created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Administered Vaccine Table
CREATE TABLE administered_vaccine (
    id_administered_vaccine BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('administered_vaccine_sequence'::regclass),
    id_vaccine BIGINT NOT NULL,
    id_doctor BIGINT NOT NULL,
    id_patient BIGINT NOT NULL,
    id_appointment BIGINT NOT NULL,
    administered_date TIMESTAMP NOT NULL DEFAULT NOW(),
    status INT NOT NULL DEFAULT 0,
    dosage FLOAT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id_vaccine) REFERENCES vaccine(id_vaccine),
    FOREIGN KEY (id_doctor) REFERENCES doctor(id_doctor),
    FOREIGN KEY (id_patient) REFERENCES patient(id_patient),
    FOREIGN KEY (id_appointment) REFERENCES appointment(id_appointment)
);

-- =======================
-- END: VACCINE
-- =======================

-- =======================
-- BEGIN: EXAM
-- =======================

-- Drops
--DROP TABLE exam;
--DROP SEQUENCE exam_sequence;

-- Exam Sequence
CREATE SEQUENCE exam_sequence
INCREMENT 1
START 1;

-- Prescribed Exam Sequence
CREATE SEQUENCE prescribed_exam_sequence
INCREMENT 1
START 1;

-- Exam Table
CREATE TABLE exam (
	id_exam BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('exam_sequence'::regclass),
	exam_name VARCHAR(255) UNIQUE NOT NULL,
	status INT NOT NULL DEFAULT 0,
	created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Prescribed Exam Table
CREATE TABLE prescribed_exam (
    id_prescribed_exam BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('prescribed_exam_sequence'::regclass),
    requisition_date TIMESTAMP NOT NULL DEFAULT NOW(),
    expiration_date TIMESTAMP NOT NULL DEFAULT NOW()+INTERVAL '60 day',
    id_appointment BIGINT NOT NULL,
    id_exam BIGINT NOT NULL,
    status INT NOT NULL DEFAULT 1,
    id_user_doctor BIGINT NOT NULL,
    id_user_patient BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id_appointment) REFERENCES appointment(id_appointment),
    FOREIGN KEY (id_exam) REFERENCES exam(id_exam),
    FOREIGN KEY (id_user_doctor) REFERENCES users(id_user),
	FOREIGN KEY (id_user_patient) REFERENCES users(id_user)
);

-- =======================
-- END: EXAM
-- =======================