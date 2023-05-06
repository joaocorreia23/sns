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
    type INTEGER DEFAULT NULL,
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
    IN hashed_id_in VARCHAR(255) DEFAULT NULL
)
RETURNS TABLE (
    hashed_id VARCHAR(255),
    name VARCHAR(255),
    phone_number VARCHAR(255),
    email VARCHAR(255),
    type INTEGER,
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
    created_at TIMESTAMP
) AS $$
BEGIN
    IF hashed_id_in IS NULL AND id_health_unit_in IS NULL THEN
        RETURN QUERY SELECT 
            hu.hashed_id, hu.name, hu.phone_number, hu.email, hu.type, hu.tax_number, hu.id_address,
            ad.door_number, ad.floor,
            zc.address, zc.zip_code,
            c.county_name,
            d.district_name,
            cty.id_country, cty.country_name,
            hu.created_at
        FROM health_unit hu
        LEFT JOIN address ad ON hu.id_address=ad.id_address
        LEFT JOIN zip_code zc ON ad.id_zip_code=zc.id_zip_code
        LEFT JOIN county c ON zc.id_county=c.id_county
        LEFT JOIN district d ON c.id_district=d.id_district
        LEFT JOIN country cty ON d.id_country=cty.id_country;
    ELSEIF hashed_id_in IS NULL THEN
        RETURN QUERY SELECT 
            hu.hashed_id, hu.name, hu.phone_number, hu.email, hu.type, hu.tax_number, hu.id_address,
            ad.door_number, ad.floor,
            zc.address, zc.zip_code,
            c.county_name,
            d.district_name,
            cty.id_country, cty.country_name,
            hu.created_at
        FROM health_unit hu
        LEFT JOIN address ad ON hu.id_address=ad.id_address
        LEFT JOIN zip_code zc ON ad.id_zip_code=zc.id_zip_code
        LEFT JOIN county c ON zc.id_county=c.id_county
        LEFT JOIN district d ON c.id_district=d.id_district
        LEFT JOIN country cty ON d.id_country=cty.id_country
        WHERE hu.id_health_unit = id_health_unit_in;
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
            hu.created_at
        FROM health_unit hu
        LEFT JOIN address ad ON hu.id_address=ad.id_address
        LEFT JOIN zip_code zc ON ad.id_zip_code=zc.id_zip_code
        LEFT JOIN county c ON zc.id_county=c.id_county
        LEFT JOIN district d ON c.id_district=d.id_district
        LEFT JOIN country cty ON d.id_country=cty.id_country
        WHERE hu.hashed_id = hashed_id_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Unidade de Saúde com o hashed_id "%" não existe', hashed_id_in; --USER NOT FOUND
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Add Health Unit Doctor
CREATE OR REPLACE FUNCTION add_health_unit_doctor(
    id_health_unit INTEGER,
    hashed_id_health_unit VARCHAR(255)
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
        id_health_unit_out = (SELECT id_health_unit FROM health_unit WHERE hashed_id = hashed_id_health_unit);
    END IF;

    -- Check if health unit exists
    IF NOT EXISTS(SELECT * FROM health_unit WHERE id_health_unit = id_health_unit_out) THEN
        RAISE EXCEPTION 'A unidade de saúde não existe';
    END IF;

    IF id_doctor IS NOT NULL THEN
        id_doctor_out = id_doctor;
    ELSE
        id_doctor_out = (SELECT id_doctor FROM doctor WHERE hashed_id = hashed_id_doctor);
    END IF;

    -- Check if doctor exists
    IF NOT EXISTS(SELECT * FROM doctor WHERE id_doctor = id_doctor_out) THEN
        RAISE EXCEPTION 'O médico não existe';
    END IF;

    -- Check if doctor is already in health unit
    IF EXISTS(SELECT * FROM health_unit_doctor WHERE id_health_unit = id_health_unit_out AND id_doctor = id_doctor_out) THEN
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
    hashed_id_health_unit VARCHAR(255)
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
        id_health_unit_out = (SELECT id_health_unit FROM health_unit WHERE hashed_id = hashed_id_health_unit);
    END IF;

    -- Check if health unit exists
    IF NOT EXISTS(SELECT * FROM health_unit WHERE id_health_unit = id_health_unit_out) THEN
        RAISE EXCEPTION 'A unidade de saúde não existe';
    END IF;

    IF id_doctor IS NOT NULL THEN
        id_doctor_out = id_doctor;
    ELSE
        id_doctor_out = (SELECT id_doctor FROM doctor WHERE hashed_id = hashed_id_doctor);
    END IF;

    -- Check if doctor exists
    IF NOT EXISTS(SELECT * FROM doctor WHERE id_doctor = id_doctor_out) THEN
        RAISE EXCEPTION 'O médico não existe';
    END IF;

    -- Check if doctor is already in health unit
    IF NOT EXISTS(SELECT * FROM health_unit_doctor WHERE id_health_unit = id_health_unit_out AND id_doctor = id_doctor_out) THEN
        RAISE EXCEPTION 'O médico não está associado à unidade de saúde';
    END IF;

    DELETE FROM health_unit_doctor WHERE id_health_unit = id_health_unit_out AND id_doctor = id_doctor_out;
    RETURN TRUE;
END;
--
--
--
-- Get Health Unit Doctors
CREATE OR REPLACE FUNCTION get_health_unit_doctors(
    id_health_unit INTEGER,
    hashed_id_health_unit VARCHAR(255)
)
RETURNS TABLE(
    id_doctor INTEGER, 
    hashed_id_doctor VARCHAR(255), 
    doctor_name VARCHAR(255)
) AS $$
DECLARE
    id_health_unit_out INTEGER;
BEGIN
    IF id_health_unit IS NOT NULL AND hashed_id_health_unit IS NOT NULL THEN
        RAISE EXCEPTION 'O id_health_unit e o hash_id não podem ser informados ao mesmo tempo';
    END IF;

    IF id_health_unit IS NULL AND hashed_id_health_unit IS NULL THEN
        RAISE EXCEPTION 'O id_health_unit ou o hash_id devem ser informados';
    END IF;

    IF id_health_unit IS NOT NULL THEN
        id_health_unit_out = id_health_unit;
    ELSE
        id_health_unit_out = (SELECT id_health_unit FROM health_unit WHERE hashed_id = hashed_id_health_unit);
    END IF;

    -- Check if health unit exists
    IF NOT EXISTS(SELECT * FROM health_unit WHERE id_health_unit = id_health_unit_out) THEN
        RAISE EXCEPTION 'A unidade de saúde não existe';
    END IF;

    RETURN QUERY
    SELECT
        u.id_user,
        u.hashed_id,
        uf.first_name || ' ' || uf.last_name AS name
    FROM
        health_unit_doctor hud
    INNER JOIN
        doctor d ON d.id_user = hud.id_doctor
    INNER JOIN
        user u ON u.id_user = d.id_user
    INNER JOIN
        user_info uf ON uf.id_user = u.id_user
    WHERE
        hud.id_health_unit = id_health_unit_out;

END;
$$ LANGUAGE plpgsql;
--
--
--
-- Add Health Unit Patient
CREATE OR REPLACE FUNCTION add_health_unit_patient(
    id_health_unit INTEGER,
    hashed_id_health_unit VARCHAR(255)
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
        id_health_unit_out = (SELECT id_health_unit FROM health_unit WHERE hashed_id = hashed_id_health_unit);
    END IF;

    -- Check if health unit exists
    IF NOT EXISTS(SELECT * FROM health_unit WHERE id_health_unit = id_health_unit_out) THEN
        RAISE EXCEPTION 'A unidade de saúde não existe';
    END IF;

    IF id_patient IS NOT NULL THEN
        id_patient_out = id_patient;
    ELSE
        id_patient_out = (SELECT id_patient FROM patient WHERE hashed_id = hashed_id_patient);
    END IF;

    -- Check if patient exists
    IF NOT EXISTS(SELECT * FROM patient WHERE id_patient = id_patient_out) THEN
        RAISE EXCEPTION 'O doente não existe';
    END IF;

    -- Check if patient is already in health unit
    IF EXISTS(SELECT * FROM health_unit_patient WHERE id_health_unit = id_health_unit_out AND id_patient = id_patient_out) THEN
        RAISE EXCEPTION 'O doente já está associado à unidade de saúde';
    END IF;

    INSERT INTO health_unit_patient (id_health_unit, id_patient) VALUES (id_health_unit_out, id_patient_out);
    RETURN TRUE;
END;
--
--
--
-- Get Health Unit Patients
CREATE OR REPLACE FUNCTION get_health_unit_patients(
    id_health_unit INTEGER,
    hashed_id_health_unit VARCHAR(255)
)
RETURNS TABLE(
    id_patient INTEGER, 
    hashed_id_patient VARCHAR(255), 
    patient_name VARCHAR(255)
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
        id_health_unit_out = (SELECT id_health_unit FROM health_unit WHERE hashed_id = hashed_id_health_unit);
    END IF;

    -- Check if health unit exists
    IF NOT EXISTS(SELECT * FROM health_unit WHERE id_health_unit = id_health_unit_out) THEN
        RAISE EXCEPTION 'A unidade de saúde não existe';
    END IF;

    RETURN QUERY
    SELECT
        u.id_user,
        u.hashed_id,
        uf.first_name || ' ' || uf.last_name AS name
    FROM
        health_unit_patient hup
    INNER JOIN
        patient p ON p.id_user = hup.id_patient
    INNER JOIN
        user u ON u.id_user = p.id_user
    INNER JOIN
        user_info uf ON uf.id_user = u.id_user
    WHERE
        hup.id_health_unit = id_health_unit_out;

END;
$$ LANGUAGE plpgsql;




