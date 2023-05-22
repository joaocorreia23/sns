--Check Health Unit Type
CREATE OR REPLACE FUNCTION check_valid_health_unit_type(
    IN health_unit_type_name VARCHAR(255)
) RETURNS BOOLEAN AS $$
DECLARE
  valid_health_unit_types text[];
BEGIN
  valid_health_unit_types := enum_range(NULL::health_unit_type);
  RETURN health_unit_type_name = ANY(valid_health_unit_types);
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Check Health Unit Tax Number
CREATE OR REPLACE FUNCTION check_health_unit_tax_number(
    tax_number INT
)
RETURNS BOOLEAN AS $$
BEGIN
    IF tax_number IS NULL THEN
        RAISE EXCEPTION 'O número de contribuinte da unidade de saúde não pode ser nulo';
    END IF;

    IF EXISTS(SELECT * FROM health_unit hu WHERE hu.tax_number = check_health_unit_tax_number.tax_number) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Check Health Unit Name
CREATE OR REPLACE FUNCTION check_health_unit_name(
    name VARCHAR(255)
)
RETURNS BOOLEAN AS $$
BEGIN
    IF name IS NULL THEN
        RAISE EXCEPTION 'O nome da unidade de saúde não pode ser nulo';
    ELSIF name = '' THEN
        RAISE EXCEPTION 'O nome da unidade de saúde não pode ser vazio';
    END IF;

    IF EXISTS (SELECT * FROM health_unit hu WHERE hu.name = check_health_unit_name.name) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
--Create Health Unit
CREATE OR REPLACE FUNCTION create_health_unit(
    name VARCHAR(255),
    phone_number VARCHAR(255) DEFAULT NULL,
    email VARCHAR(255) DEFAULT NULL,
    type health_unit_type DEFAULT NULL,
    tax_number INT DEFAULT NULL,
    door_number VARCHAR(255) DEFAULT NULL,
    floor VARCHAR(255) DEFAULT NULL,
    address VARCHAR(255) DEFAULT NULL,
    zip_code VARCHAR(255) DEFAULT NULL,
    county VARCHAR(255) DEFAULT NULL,
    district VARCHAR(255) DEFAULT NULL,
    id_country BIGINT DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
    id_health_unit_out BIGINT;
    out_id_address BIGINT;
BEGIN
    IF name IS NULL THEN
        RAISE EXCEPTION 'O nome da unidade de saúde não pode ser nulo';
    ELSIF name = '' THEN
        RAISE EXCEPTION 'O nome da unidade de saúde não pode ser vazio';
    END IF;

    IF type IS NULL THEN
        RAISE EXCEPTION 'O tipo da unidade de saúde não pode ser nulo';
    ELSIF NOT check_valid_health_unit_type(type::VARCHAR(255)) THEN
        RAISE EXCEPTION 'O tipo da unidade de saúde não é válido';
    END IF;

    IF tax_number IS NULL THEN
        RAISE EXCEPTION 'O número de contribuinte da unidade de saúde não pode ser nulo';
    ELSIF check_health_unit_tax_number(tax_number) THEN
        RAISE EXCEPTION 'O número de contribuinte da unidade de saúde já existe';
    END IF;

    IF address IS NULL THEN
        RAISE EXCEPTION 'A morada da unidade de saúde não pode ser nula';
    ELSIF address = '' THEN
        RAISE EXCEPTION 'A morada da unidade de saúde não pode ser vazia';
    END IF;

    IF zip_code IS NULL THEN
        RAISE EXCEPTION 'O código postal da unidade de saúde não pode ser nulo';
    ELSIF zip_code = '' THEN
        RAISE EXCEPTION 'O código postal da unidade de saúde não pode ser vazio';
    END IF;

    IF county IS NULL THEN
        RAISE EXCEPTION 'O concelho da unidade de saúde não pode ser nulo';
    ELSIF county = '' THEN
        RAISE EXCEPTION 'O concelho da unidade de saúde não pode ser vazio';
    END IF;

    IF district IS NULL THEN
        RAISE EXCEPTION 'O distrito da unidade de saúde não pode ser nulo';
    ELSIF district = '' THEN
        RAISE EXCEPTION 'O distrito da unidade de saúde não pode ser vazio';
    END IF;

    IF id_country IS NULL THEN
        RAISE EXCEPTION 'O país da unidade de saúde não pode ser nulo';
    END IF;

    IF check_health_unit_name(name) THEN
        RAISE EXCEPTION 'O nome da unidade de saúde já está em uso';
    END IF;

    -- Add your logic here for creating the health unit and assigning id_health_unit_out
    SELECT create_address(door_number, floor, address, zip_code, county, district, id_country) INTO out_id_address;
    INSERT INTO health_unit(name, phone_number, email, type, tax_number, id_address) VALUES (name, phone_number, email, type, tax_number, out_id_address) RETURNING id_health_unit INTO id_health_unit_out;
    
    RETURN id_health_unit_out;
END;
$$ LANGUAGE plpgsql;
--
--
--
--
--
--
-- Set Hashed ID on New Rows
CREATE OR REPLACE FUNCTION set_health_unit_hashed_id()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE health_unit SET hashed_id = hash_id(NEW.id_health_unit) WHERE id_health_unit = NEW.id_health_unit;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Trigger to Set Hashed ID on New Rows
CREATE OR REPLACE TRIGGER set_hashed_id
AFTER INSERT ON health_unit
FOR EACH ROW
EXECUTE PROCEDURE set_health_unit_hashed_id();
--
--
--
-- Get Health Unit
CREATE OR REPLACE FUNCTION get_health_unit(
    IN id_health_unit_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL,
    IN status_in INTEGER DEFAULT NULL
)
RETURNS TABLE (
    hashed_id VARCHAR(255),
    name VARCHAR(255),
    phone_number VARCHAR(255),
    email VARCHAR(255),
    type health_unit_type,
    tax_number INT,
    id_address BIGINT,
    door_number VARCHAR(255),
    floor VARCHAR(255),
    address VARCHAR(255),
    zip_code VARCHAR(255),
    county_name VARCHAR(255),
    district_name VARCHAR(255),
    id_country BIGINT,
    country_name VARCHAR(255),
    status INTEGER,
    created_at TIMESTAMP
) AS $$
BEGIN
    IF status_in IS NULL THEN
        status_in = 1;
    ELSEIF status_in NOT IN (0, 1) THEN
        RAISE EXCEPTION 'O estado da unidade de saúde tem de ser 0 ou 1';
    END IF;


    IF hashed_id_in IS NULL AND id_health_unit_in IS NULL THEN
        RETURN QUERY SELECT 
            hu.hashed_id, hu.name, hu.phone_number, hu.email, hu.type, hu.tax_number, hu.id_address,
            ad.door_number, ad.floor,
            zc.address, zc.zip_code,
            c.county_name,
            d.district_name,
            cty.id_country, cty.country_name,
            hu.status, hu.created_at
        FROM health_unit hu
        LEFT JOIN address ad ON hu.id_address=ad.id_address
        LEFT JOIN zip_code zc ON ad.id_zip_code=zc.id_zip_code
        LEFT JOIN county c ON zc.id_county=c.id_county
        LEFT JOIN district d ON c.id_district=d.id_district
        LEFT JOIN country cty ON d.id_country=cty.id_country
        WHERE hu.status=status_in;
    ELSEIF hashed_id_in IS NULL THEN
        RETURN QUERY SELECT 
            hu.hashed_id, hu.name, hu.phone_number, hu.email, hu.type, hu.tax_number, hu.id_address,
            ad.door_number, ad.floor,
            zc.address, zc.zip_code,
            c.county_name,
            d.district_name,
            cty.id_country, cty.country_name,
            hu.status, hu.created_at
        FROM health_unit hu
        LEFT JOIN address ad ON hu.id_address=ad.id_address
        LEFT JOIN zip_code zc ON ad.id_zip_code=zc.id_zip_code
        LEFT JOIN county c ON zc.id_county=c.id_county
        LEFT JOIN district d ON c.id_district=d.id_district
        LEFT JOIN country cty ON d.id_country=cty.id_country
        WHERE hu.id_health_unit = id_health_unit_in
        AND hu.status=status_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Unidade de Saúde com o id "%" não existe', id_health_unit_in; --USER NOT FOUND
        END IF;
    ELSEIF id_health_unit_in IS NULL THEN
       RETURN QUERY SELECT 
            hu.hashed_id, hu.name, hu.phone_number, hu.email, hu.type, hu.tax_number, hu.id_address,
            ad.door_number, ad.floor,
            zc.address, zc.zip_code,
            c.county_name,
            d.district_name,
            cty.id_country, cty.country_name,
            hu.status, hu.created_at
        FROM health_unit hu
        LEFT JOIN address ad ON hu.id_address=ad.id_address
        LEFT JOIN zip_code zc ON ad.id_zip_code=zc.id_zip_code
        LEFT JOIN county c ON zc.id_county=c.id_county
        LEFT JOIN district d ON c.id_district=d.id_district
        LEFT JOIN country cty ON d.id_country=cty.id_country
        WHERE hu.hashed_id = hashed_id_in
        AND hu.status=status_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Unidade de Saúde com o hashed_id "%" não existe', hashed_id_in; --USER NOT FOUND
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
CREATE OR REPLACE FUNCTION get_health_unit_types()
RETURNS TABLE (unit_type health_unit_type)
AS $$
BEGIN
    RETURN QUERY SELECT unnest(enum_range(NULL::health_unit_type));
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Change Health Unit Status
CREATE OR REPLACE FUNCTION change_health_unit_status(
    IN id_health_unit_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL,
    IN status_in INTEGER DEFAULT NULL
)
RETURNS BOOLEAN AS $$
BEGIN
    IF status_in IS NULL THEN
        RAISE EXCEPTION 'O estado da unidade de saúde tem de ser 0 ou 1';
    ELSEIF status_in NOT IN (0, 1) THEN
        RAISE EXCEPTION 'O estado da unidade de saúde tem de ser 0 ou 1';
    END IF;

    IF hashed_id_in IS NULL AND id_health_unit_in IS NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde ou o hashed_id devem ser informados';
    ELSEIF hashed_id_in IS NOT NULL AND id_health_unit_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas o id da unidade de saúde ou o hashed_id devem ser informados';
    ELSEIF hashed_id_in IS NULL AND (SELECT status FROM health_unit WHERE id_health_unit=id_health_unit_in) = status_in THEN
        IF status_in = 0 THEN
            RAISE EXCEPTION 'A unidade de saúde já se encontra desativada';
        ELSE
            RAISE EXCEPTION 'A unidade de saúde já se encontra ativada';
        END IF;
    ELSEIF id_health_unit_in IS NULL AND (SELECT status FROM health_unit WHERE hashed_id=hashed_id_in) = status_in THEN
        IF status_in = 0 THEN
            RAISE EXCEPTION 'A unidade de saúde já se encontra desativada';
        ELSE
            RAISE EXCEPTION 'A unidade de saúde já se encontra ativada';
        END IF;
    END IF;

    IF hashed_id_in IS NULL THEN
        UPDATE health_unit SET status=status_in WHERE id_health_unit=id_health_unit_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Unidade de Saúde com o id "%" não existe', id_health_unit_in; --USER NOT FOUND
        END IF;
    ELSE
        UPDATE health_unit SET status=status_in WHERE hashed_id=hashed_id_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Unidade de Saúde com o hashed_id "%" não existe', hashed_id_in; --USER NOT FOUND
        END IF;
    END IF;
        
    RETURN TRUE;
END;
--
--
--
CREATE OR REPLACE FUNCTION get_health_unit_types()
RETURNS TABLE (unit_type health_unit_type)
AS $$
BEGIN
    RETURN QUERY SELECT unnest(enum_range(NULL::health_unit_type));
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Change Health Unit Status
CREATE OR REPLACE FUNCTION change_health_unit_status(
    IN id_health_unit_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL,
    IN status_in INTEGER DEFAULT NULL
)
RETURNS BOOLEAN AS $$
BEGIN
    IF status_in IS NULL THEN
        RAISE EXCEPTION 'O estado da unidade de saúde tem de ser 0 ou 1';
    ELSEIF status_in NOT IN (0, 1) THEN
        RAISE EXCEPTION 'O estado da unidade de saúde tem de ser 0 ou 1';
    END IF;

    IF hashed_id_in IS NULL AND id_health_unit_in IS NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde ou o hashed_id devem ser informados';
    ELSEIF hashed_id_in IS NOT NULL AND id_health_unit_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas o id da unidade de saúde ou o hashed_id devem ser informados';
    ELSEIF hashed_id_in IS NULL AND (SELECT status FROM health_unit WHERE id_health_unit=id_health_unit_in) = status_in THEN
        IF status_in = 0 THEN
            RAISE EXCEPTION 'A unidade de saúde já se encontra desativada';
        ELSE
            RAISE EXCEPTION 'A unidade de saúde já se encontra ativada';
        END IF;
    ELSEIF id_health_unit_in IS NULL AND (SELECT status FROM health_unit WHERE hashed_id=hashed_id_in) = status_in THEN
        IF status_in = 0 THEN
            RAISE EXCEPTION 'A unidade de saúde já se encontra desativada';
        ELSE
            RAISE EXCEPTION 'A unidade de saúde já se encontra ativada';
        END IF;
    END IF;

    IF hashed_id_in IS NULL THEN
        UPDATE health_unit SET status=status_in WHERE id_health_unit=id_health_unit_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Unidade de Saúde com o id "%" não existe', id_health_unit_in; --USER NOT FOUND
        END IF;
    ELSE
        UPDATE health_unit SET status=status_in WHERE hashed_id=hashed_id_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Unidade de Saúde com o hashed_id "%" não existe', hashed_id_in; --USER NOT FOUND
        END IF;
    END IF;
        
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Add Health Unit Doctor
CREATE OR REPLACE FUNCTION add_health_unit_doctor(
    id_health_unit INTEGER,
    hashed_id_health_unit VARCHAR(255),
    id_doctor INTEGER,
    hashed_id_doctor VARCHAR(255)
)
RETURNS BOOLEAN AS $$
DECLARE
    id_health_unit_out INTEGER;
    id_doctor_out INTEGER;
BEGIN
    IF id_health_unit IS NOT NULL AND hashed_id_health_unit IS NOT NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde e o hash_id não podem ser informados ao mesmo tempo';
    END IF;
    
    IF id_doctor IS NOT NULL AND hashed_id_doctor IS NOT NULL THEN
        RAISE EXCEPTION 'O id do médico e o hash_id não podem ser informados ao mesmo tempo';
    END IF;

    IF id_health_unit IS NULL AND hashed_id_health_unit IS NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde ou o hash_id devem ser informados';
    END IF;

    IF id_doctor IS NULL AND hashed_id_doctor IS NULL THEN
        RAISE EXCEPTION 'O id do médico ou o hash_id devem ser informados';
    END IF;

    IF id_health_unit IS NOT NULL THEN
        id_health_unit_out = id_health_unit;
    ELSE
        id_health_unit_out = (SELECT health_unit.id_health_unit FROM health_unit WHERE hashed_id = hashed_id_health_unit);
    END IF;

    -- Check if health unit exists
    IF NOT EXISTS(SELECT * FROM health_unit WHERE health_unit.id_health_unit = id_health_unit_out) THEN
        RAISE EXCEPTION 'A unidade de saúde não existe';
    END IF;

    IF id_doctor IS NOT NULL THEN
        id_doctor_out = id_doctor;
    ELSE
        id_doctor_out = (SELECT u.id_user FROM users u WHERE u.hashed_id = hashed_id_doctor);
    END IF;

	--Check if users is a Doctor
    IF check_user_role(id_doctor_out, NULL, 'Doctor') = FALSE THEN
        RAISE EXCEPTION 'O utilizador não é um médico';
    END IF;

    -- Check if doctor exists
    IF NOT EXISTS(SELECT * FROM users WHERE users.id_user = id_doctor_out) THEN
        RAISE EXCEPTION 'O médico não existe';
    END IF;

    -- Check if doctor is already in health unit
    IF EXISTS(SELECT * FROM health_unit_doctor WHERE health_unit_doctor.id_health_unit = id_health_unit_out AND health_unit_doctor.id_doctor = id_doctor_out) THEN
        RAISE EXCEPTION 'O médico já está associado à unidade de saúde';
    END IF;

    INSERT INTO health_unit_doctor (id_health_unit, id_doctor) VALUES (id_health_unit_out, id_doctor_out);
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Remove Health Unit Doctor
CREATE OR REPLACE FUNCTION remove_health_unit_doctor(
    id_health_unit INTEGER,
    hashed_id_health_unit VARCHAR(255),
    id_doctor INTEGER,
    hashed_id_doctor VARCHAR(255)
)
RETURNS BOOLEAN AS $$
DECLARE
    id_health_unit_out INTEGER;
    id_doctor_out INTEGER;
BEGIN
    IF id_health_unit IS NOT NULL AND hashed_id_health_unit IS NOT NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde e o hash_id não podem ser informados ao mesmo tempo';
    END IF;
    
    IF id_doctor IS NOT NULL AND hashed_id_doctor IS NOT NULL THEN
        RAISE EXCEPTION 'O id do médico e o hash_id não podem ser informados ao mesmo tempo';
    END IF;

    IF id_health_unit IS NULL AND hashed_id_health_unit IS NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde ou o hash_id devem ser informados';
    END IF;

    IF id_doctor IS NULL AND hashed_id_doctor IS NULL THEN
        RAISE EXCEPTION 'O id do médico ou o hash_id devem ser informados';
    END IF;

    IF id_health_unit IS NOT NULL THEN
        id_health_unit_out = id_health_unit;
    ELSE
        id_health_unit_out = (SELECT health_unit.id_health_unit FROM health_unit WHERE hashed_id = hashed_id_health_unit);
    END IF;

    -- Check if health unit exists
    IF NOT EXISTS(SELECT * FROM health_unit WHERE health_unit.id_health_unit = id_health_unit_out) THEN
        RAISE EXCEPTION 'A unidade de saúde não existe';
    END IF;

    IF id_doctor IS NOT NULL THEN
        id_doctor_out = id_doctor;
    ELSE
        id_doctor_out = (SELECT u.id_user FROM users u WHERE u.hashed_id = hashed_id_doctor);
    END IF;

    -- Check if doctor exists
    IF NOT EXISTS(SELECT * FROM users WHERE users.id_user = id_doctor_out) THEN
        RAISE EXCEPTION 'O médico não existe';
    END IF;

    -- Check if doctor is already in health unit
    IF EXISTS(SELECT * FROM health_unit_doctor WHERE health_unit_doctor.id_health_unit = id_health_unit_out AND health_unit_doctor.id_doctor = id_doctor_out) THEN
        DELETE FROM health_unit_doctor WHERE health_unit_doctor.id_health_unit = id_health_unit_out AND health_unit_doctor.id_doctor = id_doctor_out;
		RETURN TRUE;
    ELSE
        RAISE EXCEPTION 'O médico não está associado à unidade de saúde';
    END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Get Health Unit Doctors
CREATE OR REPLACE FUNCTION get_health_unit_doctors(
    id_health_unit INTEGER,
    hashed_id_health_unit VARCHAR(255)
)
RETURNS TABLE(
    hashed_id_doctor VARCHAR(255), 
    doctor_name VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(255),
    link_date TIMESTAMP
) AS $$
DECLARE
    id_health_unit_out INTEGER;
BEGIN
    IF id_health_unit IS NOT NULL AND hashed_id_health_unit IS NOT NULL THEN
        RAISE EXCEPTION 'O id_health_unit e o hashed_id não podem ser informados ao mesmo tempo';
    END IF;

    IF id_health_unit IS NULL AND hashed_id_health_unit IS NULL THEN
        RAISE EXCEPTION 'O id_health_unit ou o hashed_id devem ser informados';
    END IF;

    IF id_health_unit IS NOT NULL THEN
        id_health_unit_out = id_health_unit;
    ELSE
        id_health_unit_out = (SELECT health_unit.id_health_unit FROM health_unit WHERE health_unit.hashed_id = hashed_id_health_unit);
    END IF;

    -- Check if health unit exists
    IF NOT EXISTS(SELECT * FROM health_unit WHERE health_unit.id_health_unit = id_health_unit_out) THEN
        RAISE EXCEPTION 'A unidade de saúde não existe';
    END IF;

    RETURN QUERY
    SELECT
        u.hashed_id AS hashed_id_doctor,
        (ui.first_name || ' ' || ui.last_name)::VARCHAR(255) AS doctor_name,
        u.email AS email,
        ui.phone_number AS phone_number,
        hud.created_at AS link_date
    FROM
        health_unit_doctor hud
        INNER JOIN users u ON hud.id_doctor = u.id_user
        LEFT JOIN user_info ui ON u.id_user = ui.id_user
    WHERE hud.id_health_unit = id_health_unit_out;

END;
$$ LANGUAGE plpgsql;
--
--
--
-- Add Health Unit Patient
CREATE OR REPLACE FUNCTION add_health_unit_patient(
    id_health_unit INTEGER,
    hashed_id_health_unit VARCHAR(255),
    id_patient INTEGER,
    hashed_id_patient VARCHAR(255)
)
RETURNS BOOLEAN AS $$
DECLARE
    id_health_unit_out INTEGER;
    id_patient_out INTEGER;
BEGIN
    IF id_health_unit IS NOT NULL AND hashed_id_health_unit IS NOT NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde e o hash_id não podem ser informados ao mesmo tempo';
    END IF;
    
    IF id_patient IS NOT NULL AND hashed_id_patient IS NOT NULL THEN
        RAISE EXCEPTION 'O id do paciente e o hash_id não podem ser informados ao mesmo tempo';
    END IF;

    IF id_health_unit IS NULL AND hashed_id_health_unit IS NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde ou o hash_id devem ser informados';
    END IF;

    IF id_patient IS NULL AND hashed_id_patient IS NULL THEN
        RAISE EXCEPTION 'O id do paciente ou o hash_id devem ser informados';
    END IF;

    IF id_health_unit IS NOT NULL THEN
        id_health_unit_out = id_health_unit;
    ELSE
        id_health_unit_out = (SELECT health_unit.id_health_unit FROM health_unit WHERE hashed_id = hashed_id_health_unit);
    END IF;

    -- Check if health unit exists
    IF NOT EXISTS(SELECT * FROM health_unit WHERE health_unit.id_health_unit = id_health_unit_out) THEN
        RAISE EXCEPTION 'A unidade de saúde não existe';
    END IF;

    IF id_patient IS NOT NULL THEN
        id_patient_out = id_patient;
    ELSE
        id_patient_out = (SELECT u.id_user FROM users u WHERE u.hashed_id = hashed_id_patient);
    END IF;

	--Check if users is a Patient
    IF check_user_role(id_patient_out, NULL, 'Patient') = FALSE THEN
        RAISE EXCEPTION 'O utilizador não é um Utente';
    END IF;

    -- Check if patient exists
    IF NOT EXISTS(SELECT * FROM users WHERE users.id_user = id_patient_out) THEN
        RAISE EXCEPTION 'O utente não existe';
    END IF;

    -- Check if patient is already in health unit
    IF EXISTS(SELECT * FROM health_unit_patient WHERE health_unit_patient.id_health_unit = id_health_unit_out AND health_unit_patient.id_patient = id_patient_out) THEN
        RAISE EXCEPTION 'O utente já está associado à unidade de saúde';
    END IF;

    IF EXISTS(SELECT * FROM health_unit_patient WHERE health_unit_patient.id_patient = id_patient_out) THEN
        RAISE EXCEPTION 'O utente já está associado ao Centro de Saude: %', (SELECT health_unit.name FROM health_unit WHERE health_unit.id_health_unit = (SELECT health_unit_patient.id_health_unit FROM health_unit_patient WHERE health_unit_patient.id_patient = id_patient_out));
    END IF;

    -- Check if health unit is a "Centro de Saúde"
    IF (SELECT type FROM health_unit WHERE health_unit.id_health_unit = id_health_unit_out) != 'Centro de Saúde' THEN
        RAISE EXCEPTION 'A unidade de saúde não é um Centro de Saúde, logo não pode ter utentes associados';
    END IF;

    INSERT INTO health_unit_patient (id_health_unit, id_patient) VALUES (id_health_unit_out, id_patient_out);
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Remove Health Unit Patient
CREATE OR REPLACE FUNCTION remove_health_unit_patient(
    id_health_unit INTEGER,
    hashed_id_health_unit VARCHAR(255),
    id_patient INTEGER,
    hashed_id_patient VARCHAR(255)
)
RETURNS BOOLEAN AS $$
DECLARE
    id_health_unit_out INTEGER;
    id_patient_out INTEGER;
BEGIN
    IF id_health_unit IS NOT NULL AND hashed_id_health_unit IS NOT NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde e o hash_id não podem ser informados ao mesmo tempo';
    END IF;
    
    IF id_patient IS NOT NULL AND hashed_id_patient IS NOT NULL THEN
        RAISE EXCEPTION 'O id do paciente e o hash_id não podem ser informados ao mesmo tempo';
    END IF;

    IF id_health_unit IS NULL AND hashed_id_health_unit IS NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde ou o hash_id devem ser informados';
    END IF;

    IF id_patient IS NULL AND hashed_id_patient IS NULL THEN
        RAISE EXCEPTION 'O id do paciente ou o hash_id devem ser informados';
    END IF;

    IF id_health_unit IS NOT NULL THEN
        id_health_unit_out = id_health_unit;
    ELSE
        id_health_unit_out = (SELECT health_unit.id_health_unit FROM health_unit WHERE hashed_id = hashed_id_health_unit);
    END IF;

    -- Check if health unit exists
    IF NOT EXISTS(SELECT * FROM health_unit WHERE health_unit.id_health_unit = id_health_unit_out) THEN
        RAISE EXCEPTION 'A unidade de saúde não existe';
    END IF;

    IF id_patient IS NOT NULL THEN
        id_patient_out = id_patient;
    ELSE
        id_patient_out = (SELECT u.id_user FROM users u WHERE u.hashed_id = hashed_id_patient);
    END IF;

    -- Check if patient exists
    IF NOT EXISTS(SELECT * FROM users WHERE users.id_user = id_patient_out) THEN
        RAISE EXCEPTION 'O paciente não existe';
    END IF;

    -- Check if patient is already in health unit
    IF EXISTS(SELECT * FROM health_unit_patient WHERE health_unit_patient.id_health_unit = id_health_unit_out AND health_unit_patient.id_patient = id_patient_out) THEN
        DELETE FROM health_unit_patient WHERE health_unit_patient.id_health_unit = id_health_unit_out AND health_unit_patient.id_patient = id_patient_out;
		RETURN TRUE;
    ELSE
        RAISE EXCEPTION 'O paciente não está associado à unidade de saúde';
    END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Get Health Unit Patients
CREATE OR REPLACE FUNCTION get_health_unit_patients(
    id_health_unit INTEGER,
    hashed_id_health_unit VARCHAR(255)
)
RETURNS TABLE(
    hashed_id_patient VARCHAR(255), 
    patient_name VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(255),
    link_date TIMESTAMP
) AS $$
DECLARE
    id_health_unit_out INTEGER;
BEGIN
    IF id_health_unit IS NOT NULL AND hashed_id_health_unit IS NOT NULL THEN
        RAISE EXCEPTION 'O id_health_unit e o hashed_id não podem ser informados ao mesmo tempo';
    END IF;

    IF id_health_unit IS NULL AND hashed_id_health_unit IS NULL THEN
        RAISE EXCEPTION 'O id_health_unit ou o hashed_id devem ser informados';
    END IF;

    IF id_health_unit IS NOT NULL THEN
        id_health_unit_out = id_health_unit;
    ELSE
        id_health_unit_out = (SELECT health_unit.id_health_unit FROM health_unit WHERE health_unit.hashed_id = hashed_id_health_unit);
    END IF;

    -- Check if health unit exists
    IF NOT EXISTS(SELECT * FROM health_unit WHERE health_unit.id_health_unit = id_health_unit_out) THEN
        RAISE EXCEPTION 'A unidade de saúde não existe';
    END IF;

    RETURN QUERY
    SELECT
        u.hashed_id AS hashed_id_patient,
        (ui.first_name || ' ' || ui.last_name)::VARCHAR(255) AS patient_name,
        u.email AS email,
        ui.phone_number AS phone_number,
        hup.created_at AS link_date
    FROM
        health_unit_patient hup
        INNER JOIN users u ON hup.id_patient = u.id_user
        LEFT JOIN user_info ui ON u.id_user = ui.id_user
    WHERE hup.id_health_unit = id_health_unit_out;

END;
$$ LANGUAGE plpgsql;
--
--
--
-- Add Patient Doctor
CREATE OR REPLACE FUNCTION add_patient_doctor(
    id_health_unit INTEGER,
    hashed_id_health_unit VARCHAR(255),
    id_doctor INTEGER,
    hashed_id_doctor VARCHAR(255),
    id_patient INTEGER,
    hashed_id_patient VARCHAR(255)
)
RETURNS BOOLEAN AS $$
DECLARE
    id_health_unit_out BIGINT;
    id_doctor_out BIGINT;
    id_patient_out BIGINT;

    id_health_unit_doctor_out BIGINT;
    id_health_unit_patient_out BIGINT;
BEGIN
    IF id_health_unit IS NOT NULL AND hashed_id_health_unit IS NOT NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde e o hash_id não podem ser informados ao mesmo tempo';
    END IF;

    IF id_doctor IS NOT NULL AND hashed_id_doctor IS NOT NULL THEN
        RAISE EXCEPTION 'O id do médico e o hash_id não podem ser informados ao mesmo tempo';
    END IF;
    
    IF id_patient IS NOT NULL AND hashed_id_patient IS NOT NULL THEN
        RAISE EXCEPTION 'O id do paciente e o hash_id não podem ser informados ao mesmo tempo';
    END IF;

    IF id_health_unit IS NULL AND hashed_id_health_unit IS NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde ou o hash_id devem ser informados';
    END IF;

    IF id_doctor IS NULL AND hashed_id_doctor IS NULL THEN
        RAISE EXCEPTION 'O id do médico ou o hash_id devem ser informados';
    END IF;

    IF id_patient IS NULL AND hashed_id_patient IS NULL THEN
        RAISE EXCEPTION 'O id do paciente ou o hash_id devem ser informados';
    END IF;


    IF id_health_unit IS NOT NULL THEN
        id_health_unit_out = id_health_unit;
    ELSE
        id_health_unit_out = (SELECT health_unit.id_health_unit FROM health_unit WHERE hashed_id = hashed_id_health_unit);
    END IF;

    -- Check if health unit exists
    IF NOT EXISTS(SELECT * FROM health_unit WHERE health_unit.id_health_unit = id_health_unit_out) THEN
        RAISE EXCEPTION 'A unidade de saúde não existe';
    END IF;

    IF id_doctor IS NOT NULL THEN
        id_doctor_out = id_doctor;
    ELSE
        id_doctor_out = (SELECT u.id_user FROM users u WHERE u.hashed_id = hashed_id_doctor);
    END IF;

    -- Check if patient exists
    IF NOT EXISTS(SELECT * FROM users WHERE users.id_user = id_doctor_out) THEN
        RAISE EXCEPTION 'O médico não existe';
    END IF;

	--Check if users is a Patient
    IF check_user_role(id_doctor_out, NULL, 'Doctor') = FALSE THEN
        RAISE EXCEPTION 'O utilizador não é um Médico';
    END IF;


    IF id_patient IS NOT NULL THEN
        id_patient_out = id_patient;
    ELSE
        id_patient_out = (SELECT u.id_user FROM users u WHERE u.hashed_id = hashed_id_patient);
    END IF;

    -- Check if patient exists
    IF NOT EXISTS(SELECT * FROM users WHERE users.id_user = id_patient_out) THEN
        RAISE EXCEPTION 'O utente não existe';
    END IF;

	--Check if users is a Patient
    IF check_user_role(id_patient_out, NULL, 'Patient') = FALSE THEN
        RAISE EXCEPTION 'O utilizador não é um Utente';
    END IF;

    -- Get id_health_unit_doctor
    id_health_unit_doctor_out = (SELECT health_unit_doctor.id_health_unit_doctor FROM health_unit_doctor WHERE health_unit_doctor.id_health_unit = id_health_unit_out AND health_unit_doctor.id_doctor = id_doctor_out);
    IF id_health_unit_doctor_out IS NULL THEN
        RAISE EXCEPTION 'O médico não está associado à unidade de saúde';
    END IF;

    -- Get id_health_unit_patient
    id_health_unit_patient_out = (SELECT health_unit_patient.id_health_unit_patient FROM health_unit_patient WHERE health_unit_patient.id_health_unit = id_health_unit_out AND health_unit_patient.id_patient = id_patient_out);
    IF id_health_unit_patient_out IS NULL THEN
        RAISE EXCEPTION 'O utente não está associado à unidade de saúde';
    END IF;

    -- Check if patient is already associated to doctor
    IF EXISTS(SELECT * FROM patient_doctor WHERE patient_doctor.id_health_unit_doctor = id_health_unit_doctor_out AND patient_doctor.id_health_unit_patient = id_health_unit_patient_out AND status=1) THEN
        RAISE EXCEPTION 'O utente já está associado ao médico';
    END IF;

    -- Check if patient is already associated to another doctor
    IF EXISTS(SELECT * FROM patient_doctor WHERE patient_doctor.id_health_unit_patient = id_health_unit_patient_out AND status=1) THEN
        RAISE EXCEPTION 'O utente já está associado a outro médico';
    END IF;

    INSERT INTO patient_doctor (id_health_unit_doctor, id_health_unit_patient, status, start_date) VALUES (id_health_unit_doctor_out, id_health_unit_patient_out, 1, NOW());
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Remove Patient Doctor
CREATE OR REPLACE FUNCTION remove_patient_doctor(
    id_health_unit INTEGER,
    hashed_id_health_unit VARCHAR(255),
    id_doctor INTEGER,
    hashed_id_doctor VARCHAR(255),
    id_patient INTEGER,
    hashed_id_patient VARCHAR(255)
)
RETURNS BOOLEAN AS $$
DECLARE
    id_health_unit_out BIGINT;
    id_doctor_out BIGINT;
    id_patient_out BIGINT;

    id_health_unit_doctor_out BIGINT;
    id_health_unit_patient_out BIGINT;
BEGIN
    IF id_health_unit IS NOT NULL AND hashed_id_health_unit IS NOT NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde e o hash_id não podem ser informados ao mesmo tempo';
    END IF;

    IF id_doctor IS NOT NULL AND hashed_id_doctor IS NOT NULL THEN
        RAISE EXCEPTION 'O id do médico e o hash_id não podem ser informados ao mesmo tempo';
    END IF;
    
    IF id_patient IS NOT NULL AND hashed_id_patient IS NOT NULL THEN
        RAISE EXCEPTION 'O id do paciente e o hash_id não podem ser informados ao mesmo tempo';
    END IF;

    IF id_health_unit IS NULL AND hashed_id_health_unit IS NULL THEN
        RAISE EXCEPTION 'O id da unidade de saúde ou o hash_id devem ser informados';
    END IF;

    IF id_doctor IS NULL AND hashed_id_doctor IS NULL THEN
        RAISE EXCEPTION 'O id do médico ou o hash_id devem ser informados';
    END IF;

    IF id_patient IS NULL AND hashed_id_patient IS NULL THEN
        RAISE EXCEPTION 'O id do paciente ou o hash_id devem ser informados';
    END IF;

    IF id_health_unit IS NOT NULL THEN
        id_health_unit_out = id_health_unit;
    ELSE
        id_health_unit_out = (SELECT health_unit.id_health_unit FROM health_unit WHERE hashed_id = hashed_id_health_unit);
    END IF;

    -- Check if health unit exists
    IF NOT EXISTS(SELECT * FROM health_unit WHERE health_unit.id_health_unit = id_health_unit_out) THEN
        RAISE EXCEPTION 'A unidade de saúde não existe';
    END IF;

    IF id_doctor IS NOT NULL THEN
        id_doctor_out = id_doctor;
    ELSE
        id_doctor_out = (SELECT u.id_user FROM users u WHERE u.hashed_id = hashed_id_doctor);
    END IF;

    -- Check if patient exists
    IF NOT EXISTS(SELECT * FROM users WHERE users.id_user = id_doctor_out) THEN
        RAISE EXCEPTION 'O médico não existe';
    END IF;

	--Check if users is a Patient
    IF check_user_role(id_doctor_out, NULL, 'Doctor') = FALSE THEN
        RAISE EXCEPTION 'O utilizador não é um Médico';
    END IF;


    IF id_patient IS NOT NULL THEN
        id_patient_out = id_patient;
    ELSE
        id_patient_out = (SELECT u.id_user FROM users u WHERE u.hashed_id = hashed_id_patient);
    END IF;

    -- Check if patient exists
    IF NOT EXISTS(SELECT * FROM users WHERE users.id_user = id_patient_out) THEN
        RAISE EXCEPTION 'O utente não existe';
    END IF;

	--Check if users is a Patient
    IF check_user_role(id_patient_out, NULL, 'Patient') = FALSE THEN
        RAISE EXCEPTION 'O utilizador não é um Utente';
    END IF;

    -- Get id_health_unit_doctor_out
    id_health_unit_doctor_out = (SELECT health_unit_doctor.id_health_unit_doctor FROM health_unit_doctor WHERE health_unit_doctor.id_health_unit = id_health_unit_out AND health_unit_doctor.id_doctor = id_doctor_out);
    IF id_health_unit_doctor_out IS NULL THEN
        RAISE EXCEPTION 'O médico não está associado à unidade de saúde';
    END IF;

    -- Get id_health_unit_patient_out
    id_health_unit_patient_out = (SELECT health_unit_patient.id_health_unit_patient FROM health_unit_patient WHERE health_unit_patient.id_health_unit = id_health_unit_out AND health_unit_patient.id_patient = id_patient_out);
    IF id_health_unit_patient_out IS NULL THEN
        RAISE EXCEPTION 'O utente não está associado à unidade de saúde';
    END IF;

    UPDATE patient_doctor SET status = 0, end_date=now() WHERE id_health_unit_doctor = id_health_unit_doctor_out AND id_health_unit_patient = id_health_unit_patient_out AND status=1;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Get Patient Current Health Unit Doctor
CREATE OR REPLACE FUNCTION get_patient_current_health_unit_doctor(
    id_patient BIGINT,
    hashed_id_patient_in VARCHAR(255)
)
RETURNS TABLE(
    hashed_id_doctor VARCHAR(255),
    hashed_id_patient VARCHAR(255),
    hashed_id_health_unit VARCHAR(255),
    status INTEGER,
    start_date TIMESTAMP,
    health_unit_name VARCHAR(255),
    doctor_name VARCHAR(255),
    patient_name VARCHAR(255)
) AS $$
DECLARE
    id_patient_out BIGINT;
BEGIN
    IF id_patient IS NOT NULL AND hashed_id_patient_in IS NOT NULL THEN
        RAISE EXCEPTION 'O id do paciente e o hash_id não podem ser informados ao mesmo tempo';
    END IF;

    IF id_patient IS NULL AND hashed_id_patient_in IS NULL THEN
        RAISE EXCEPTION 'O id do paciente ou o hash_id devem ser informados';
    END IF;

    IF id_patient IS NOT NULL THEN
        id_patient_out = id_patient;
    ELSE
        id_patient_out = (SELECT u.id_user FROM users u WHERE u.hashed_id = hashed_id_patient_in);
    END IF;

    -- Check if patient exists
    IF NOT EXISTS(SELECT * FROM users WHERE users.id_user = id_patient_out) THEN
        RAISE EXCEPTION 'O utente não existe';
    END IF;

    --Check if users is a Patient
    IF check_user_role(id_patient_out, NULL, 'Patient') = FALSE THEN
        RAISE EXCEPTION 'O utilizador não é um Utente';
    END IF;

    RETURN QUERY
    SELECT
        u_doc.hashed_id as hashed_id_doctor,
        u_pat.hashed_id as hashed_id_patient,
        hu.hashed_id,
        pd.status,
        pd.start_date,
        hu.name,
        (ui_doc.first_name || ' ' || ui_doc.last_name) as doctor_name,
		(ui_pat.first_name || ' ' || ui_pat.last_name) as patient_name
    FROM patient_doctor pd
    INNER JOIN health_unit_doctor hud ON hud.id_health_unit_doctor = pd.id_health_unit_doctor
    INNER JOIN health_unit_patient hup ON hup.id_health_unit_patient = pd.id_health_unit_patient
    INNER JOIN users u_doc ON u_doc.id_user = hud.id_doctor
    INNER JOIN users u_pat ON u_pat.id_user = hup.id_patient
    INNER JOIN health_unit hu ON hu.id_health_unit = hud.id_health_unit
    INNER JOIN user_info ui_pat ON ui_pat.id_user = u_pat.id_user
    INNER JOIN user_info ui_doc ON ui_doc.id_user = u_doc.id_user
    WHERE pd.status = 1 AND hup.id_patient=id_patient_out;

END;
$$ LANGUAGE plpgsql;
    










