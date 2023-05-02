--Create Health Unit
CREATE OR REPLACE FUNCTION create_health_unit(
    health_unit_name VARCHAR(50),
)
RETURNS INTEGER AS $$
DECLARE
    id_health_unit_out INTEGER;
BEGIN
    IF health_unit_name IS NULL THEN
        RAISE EXCEPTION 'O nome da unidade de saúde não pode ser nulo';
    END IF;

    IF EXISTS(SELECT * FROM health_unit WHERE health_unit_name = health_unit_name) THEN
        RAISE EXCEPTION 'A unidade de saúde já existe';
    END IF;

    INSERT INTO health_unit (health_unit_name) VALUES (health_unit_name) RETURNING health_unit.id_health_unit INTO id_health_unit_out;
    RETURN id_health_unit_out;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Set Hashed ID on New Rows
CREATE OR REPLACE FUNCTION set_hashed_id()
RETURNS TRIGGER AS $$
BEGIN
    NEW.hashed_id = hash_id(NEW.id_health_unit);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--
CREATE TRIGGER set_hashed_id
AFTER INSERT ON health_unit
FOR EACH ROW
EXECUTE PROCEDURE set_hashed_id();
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




