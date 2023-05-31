-- Check Medication name
CREATE OR REPLACE FUNCTION check_medication_name(
    medication_name VARCHAR(255)
) RETURNS BOOLEAN AS $$
DECLARE
    medication_name_exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM medication WHERE medication.medication_name = check_medication_name.medication_name) INTO medication_name_exists;
    RETURN medication_name_exists;
END;
$$ LANGUAGE plpgsql;

--
--
--
-- Insert medication
CREATE OR REPLACE FUNCTION create_medication(
	medication_name VARCHAR(255),
	status INT DEFAULT 1
) RETURNS BOOLEAN AS $$
BEGIN
		
	IF(medication_name IS NULL OR medication_name='') THEN
		RAISE EXCEPTION 'Nome da Medicação nulo ou vazio';
	ELSE
        IF(check_medication_name(medication_name)) THEN
            RAISE EXCEPTION 'Nome da Medicação já existe';
        END IF;
    END IF;                
		
    INSERT INTO medication (medication_name, status) VALUES (medication_name, status);
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Update medication
CREATE OR REPLACE FUNCTION update_medication(
    id_medication_in BIGINT DEFAULT NULL,
    hashed_id_in VARCHAR(255) DEFAULT NULL,
    medication_name_in VARCHAR(255) DEFAULT NULL,
    status_in INT DEFAULT NULL
) RETURNS BOOLEAN AS $$
DECLARE
    medication_id BIGINT;
BEGIN


    IF hashed_id_in IS NULL AND id_medication_in IS NULL THEN
        RAISE EXCEPTION 'É necessário passar o id_medication ou o hashed_id';
    ELSEIF hashed_id_in IS NOT NULL AND id_medication_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não é possível passar o id_medication e o hashed_id';
    ELSEIF hashed_id_in IS NULL THEN
        SELECT id_medication INTO medication_id FROM medication WHERE id_medication = id_medication_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Medicação com o id "%" não existe', id_medication_in; --medication NOT FOUND
        END IF;
    ELSEIF id_medication_in IS NULL THEN
        SELECT id_medication INTO medication_id FROM medication WHERE hashed_id = hashed_id_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Medicação com o hashed_id "%" não existe', hashed_id_in; --medication NOT FOUND
        END IF;
    END IF;

    IF medication_name_in IS NOT NULL AND medication_name_in <> '' THEN
        IF EXISTS (SELECT * FROM medication WHERE medication_name = medication_name_in AND id_medication <> medication_id) THEN
            RAISE EXCEPTION 'Nome da Medicação já existe';
        END IF;
    END IF;

    UPDATE medication SET medication_name = medication_name_in WHERE id_medication = medication_id;
    
    IF status_in IS NOT NULL THEN
        UPDATE medication SET status = status_in WHERE id_medication = medication_id;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Set Hashed ID on New Rows
CREATE OR REPLACE FUNCTION set_medication_hashed_id_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE medication SET hashed_id = hash_id(NEW.id_medication) WHERE id_medication = NEW.id_medication;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Trigger to Set Hashed ID on New Rows
CREATE OR REPLACE TRIGGER set_medication_hashed_id_trigger
AFTER INSERT ON medication
FOR EACH ROW
EXECUTE PROCEDURE set_medication_hashed_id_function();
--
--
--
-- Get medications
CREATE OR REPLACE FUNCTION get_medications(
    IN id_medication_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL,
    IN status_in INT DEFAULT 1
)
RETURNS TABLE (
    hashed_id VARCHAR(255),
    medication_name VARCHAR(255),
    status INT,
    created_at TIMESTAMP
) AS $$
BEGIN
    IF hashed_id_in IS NULL AND id_medication_in IS NULL THEN
        RETURN QUERY SELECT 
            m.hashed_id, m.medication_name, m.status, m.created_at
        FROM medication m 
        WHERE m.status = status_in;
    ELSEIF hashed_id_in IS NULL OR hashed_id_in = '' THEN
        RETURN QUERY SELECT 
            m.hashed_id, m.medication_name, m.status, m.created_at
        FROM medication m 
        WHERE m.id_medication = id_medication_in AND m.status = status_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Medicação com o id "%" não existe', id_medication_in; --MEDICATION NOT FOUND
        END IF;
    ELSEIF id_medication_in IS NULL THEN
        RETURN QUERY SELECT 
            m.hashed_id, m.medication_name, m.status, m.created_at
        FROM medication m
        WHERE m.hashed_id = hashed_id_in AND m.status = status_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Medicação com o hashed_id "%" não existe', hashed_id_in; --MEDICATION NOT FOUND
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Change medication Status
CREATE OR REPLACE FUNCTION change_medication_status(
    IN id_medication_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL,
    IN status_in INT DEFAULT 1
)
RETURNS BOOLEAN AS $$
DECLARE
    medication_id BIGINT;
BEGIN

    IF status_in <> 0 AND status_in <> 1 THEN
        RAISE EXCEPTION 'O status deve ser 0 ou 1';
    END IF;

    IF id_medication_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_medication. Ambos foram passados.';
    END IF;

    IF hashed_id_in IS NOT NULL THEN
        SELECT medication.id_medication INTO medication_id FROM medication WHERE hashed_id = hashed_id_in;
    ELSE
        medication_id := id_medication_in;
    END IF;

    IF medication_id IS NULL AND id_medication_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhuma medicação com o id passado';
    ELSEIF medication_id IS NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhuma medicação com o hashed_id passado';
    END IF;

   
    IF NOT EXISTS (SELECT medication.id_medication FROM medication WHERE medication.id_medication = medication_id AND medication.status = status_in) THEN
        UPDATE medication SET status = status_in WHERE id_medication = medication_id;
        RETURN TRUE;
    ELSE
        IF status_in = 0 THEN
            RAISE EXCEPTION 'A medicação já está desativada';
        ELSE
            RAISE EXCEPTION 'A medicação já está ativada';
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Add To Usual Medication
CREATE OR REPLACE FUNCTION add_to_usual_medication(
    IN id_medication_prescription BIGINT DEFAULT NULL,
    IN hashed_id_medication_prescription VARCHAR(255) DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    medication_id BIGINT;
    medication_prescription_id BIGINT;
    patient_id BIGINT;
BEGIN
    IF id_medication_prescription IS NULL AND hashed_id_medication_prescription IS NULL THEN
        RAISE EXCEPTION 'É necessário passar o id_medication_prescription ou o hashed_id_medication_prescription';
    ELSEIF id_medication_prescription IS NOT NULL AND hashed_id_medication_prescription IS NOT NULL THEN
        RAISE EXCEPTION 'Não é possível passar o id_medication_prescription e o hashed_id_medication_prescription';
    ELSEIF id_medication_prescription IS NULL THEN
        SELECT medication_prescription.id_medication_prescription INTO medication_prescription_id FROM medication_prescription WHERE hashed_id = hashed_id_medication_prescription;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Prescrição de medicação com o hashed_id "%" não existe', hashed_id_medication_prescription; --medication_prescription NOT FOUND
        END IF;
    ELSEIF hashed_id_medication_prescription IS NULL THEN
        SELECT medication_prescription.id_medication_prescription INTO medication_prescription_id FROM medication_prescription WHERE medication_prescription.id_medication_prescription = add_to_usual_medication.id_medication_prescription;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Prescrição de medicação com o id "%" não existe', id_medication_prescription; --medication_prescription NOT FOUND
        END IF;
    END IF;

    IF EXISTS (SELECT * FROM usual_medication WHERE usual_medication.id_medication_prescription = medication_prescription_id) THEN
        RAISE EXCEPTION 'Prescrição de medicação já está na lista de medicações usuais';
        RETURN FALSE;
    END IF;

    medication_id := (SELECT m.id_medication FROM medication_prescription mp INNER JOIN medication m ON mp.id_medication = m.id_medication WHERE mp.id_medication_prescription = medication_prescription_id);
    IF NOT EXISTS (SELECT * FROM medication WHERE id_medication = medication_id AND status = 1) THEN
        RAISE EXCEPTION 'Medicação não está ativa';
    END IF;

    patient_id := (SELECT a.id_user_patient FROM medication_prescription mp INNER JOIN prescription p ON mp.id_prescription = p.id_prescription INNER JOIN appointment a ON p.id_appointment = a.id_appointment WHERE mp.id_medication_prescription = medication_prescription_id);

    -- Check if patient already has this medication in usual medication
    IF EXISTS (SELECT * FROM usual_medication um 
    INNER JOIN medication_prescription mp ON um.id_medication_prescription = mp.id_medication_prescription 
    INNER JOIN prescription p ON mp.id_prescription = p.id_prescription
    INNER JOIN appointment a ON p.id_appointment = a.id_appointment AND a.id_user_patient = patient_id
    WHERE mp.id_medication = medication_id AND um.status = 1) THEN
        --RAISE EXCEPTION 'Utente já tem esta medicação na lista de medicações usuais';
        RETURN TRUE;--Already has this medication in usual medication, so no need to add
    END IF;

    INSERT INTO usual_medication (id_medication_prescription) VALUES (medication_prescription_id);
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Remove From Usual Medication
CREATE OR REPLACE FUNCTION remove_from_usual_medication(
    IN id_medication_prescription BIGINT DEFAULT NULL,
    IN hashed_id_medication_prescription VARCHAR(255) DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    medication_prescription_id BIGINT;
BEGIN
    IF id_medication_prescription IS NULL AND hashed_id_medication_prescription IS NULL THEN
        RAISE EXCEPTION 'É necessário passar o id_medication_prescription ou o hashed_id_medication_prescription';
    ELSEIF id_medication_prescription IS NOT NULL AND hashed_id_medication_prescription IS NOT NULL THEN
        RAISE EXCEPTION 'Não é possível passar o id_medication_prescription e o hashed_id_medication_prescription';
    ELSEIF id_medication_prescription IS NULL THEN
        SELECT medication_prescription.id_medication_prescription INTO medication_prescription_id FROM medication_prescription WHERE hashed_id = hashed_id_medication_prescription;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Prescrição de medicação com o hashed_id "%" não existe', hashed_id_medication_prescription; --medication_prescription NOT FOUND
        END IF;
    ELSEIF hashed_id_medication_prescription IS NULL THEN
        SELECT medication_prescription.id_medication_prescription INTO medication_prescription_id FROM medication_prescription WHERE medication_prescription.id_medication_prescription = remove_from_usual_medication.id_medication_prescription;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Prescrição de medicação com o id "%" não existe', id_medication_prescription; --medication_prescription NOT FOUND
        END IF;
    END IF;

    IF NOT EXISTS (SELECT * FROM usual_medication WHERE usual_medication.id_medication_prescription = medication_prescription_id) THEN
        RAISE EXCEPTION 'Prescrição de medicação não está na lista de medicações usuais';
    END IF;

    IF EXISTS(SELECT * FROM usual_medication WHERE usual_medication.id_medication_prescription = medication_prescription_id AND usual_medication.status = 0) THEN
        RAISE EXCEPTION 'Prescrição de medicação já está desativada';
    END IF;

    UPDATE usual_medication SET status = 0, updated_at=NOW WHERE usual_medication.id_medication_prescription = medication_prescription_id;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Get Usual Medication
CREATE OR REPLACE FUNCTION get_usual_medication(
    IN id_user_patient BIGINT DEFAULT NULL,
    IN hashed_id_user_patient VARCHAR(255) DEFAULT NULL,
    status INTEGER DEFAULT NULL
)
RETURNS TABLE (
    hashed_medication_prescription BIGINT,
    usual_medication_status INTEGER,
    usual_medication_created_at TIMESTAMP,
    usual_medication_updated_at TIMESTAMP,
    id_medication BIGINT,
	hashed_id_medication VARCHAR(255),
    medication_name VARCHAR(255),
    medication_status INTEGER
) AS $$
DECLARE
    patient_id BIGINT;
BEGIN
    IF id_user_patient IS NULL AND hashed_id_user_patient IS NULL THEN
        RAISE EXCEPTION 'É necessário passar o id_user_patient ou o hashed_id_user_patient';
    ELSEIF id_user_patient IS NOT NULL AND hashed_id_user_patient IS NOT NULL THEN
        RAISE EXCEPTION 'Não é possível passar o id_user_patient e o hashed_id_user_patient';
    ELSEIF id_user_patient IS NULL THEN
        SELECT users.id_user INTO patient_id FROM users WHERE hashed_id = hashed_id_user_patient;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Utente com o hashed_id "%" não existe', hashed_id_user_patient; --user_patient NOT FOUND
        END IF;
    ELSEIF hashed_id_user_patient IS NULL THEN
        SELECT users.id_user INTO patient_id FROM users WHERE users.id_user = get_usual_medication.id_user_patient;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Utente com o id "%" não existe', id_user_patient; --user_patient NOT FOUND
        END IF;
    END IF;

    IF get_usual_medication.status IS NULL THEN
        RETURN QUERY
        SELECT 
            um.id_medication_prescription, 
            um.status AS usual_medication_status, 
            um.created_at AS usual_medication_created_at, 
            um.updated_at AS usual_medication_updated_at, 
            m.id_medication, 
			m.hashed_id AS hashed_id_medication,
            m.medication_name AS medication_name, 
            m.status AS medication_status 
        FROM usual_medication um
        INNER JOIN medication_prescription mp ON um.id_medication_prescription = mp.id_medication_prescription
        INNER JOIN medication m ON mp.id_medication = m.id_medication
        INNER JOIN prescription p ON mp.id_prescription = p.id_prescription
        INNER JOIN appointment a ON p.id_appointment = a.id_appointment AND a.id_user_patient = patient_id;
    ELSEIF get_usual_medication.status IN (0, 1) THEN
        RETURN QUERY
        SELECT 
            um.id_medication_prescription, 
            um.status AS usual_medication_status, 
            um.created_at AS usual_medication_created_at, 
            um.updated_at AS usual_medication_updated_at, 
            m.id_medication, 
			m.hashed_id AS hashed_id_medication,
            m.medication_name AS medication_name, 
            m.status AS medication_status 
        FROM usual_medication um
        INNER JOIN medication_prescription mp ON um.id_medication_prescription = mp.id_medication_prescription
        INNER JOIN medication m ON mp.id_medication = m.id_medication
        INNER JOIN prescription p ON mp.id_prescription = p.id_prescription
        INNER JOIN appointment a ON p.id_appointment = a.id_appointment AND a.id_user_patient = patient_id
        WHERE um.status = get_usual_medication.status;
    ELSE
        RAISE EXCEPTION 'Estado inválido';
    END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Add To Usual Medication Request
CREATE OR REPLACE FUNCTION add_to_usual_medication_request(
    IN id_medication_in BIGINT DEFAULT NULL,
    IN hashed_id_medication_in VARCHAR(255) DEFAULT NULL,
    IN id_patient_in BIGINT DEFAULT NULL,
    IN hashed_id_patient_in VARCHAR(255) DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    medication_id BIGINT;
    health_unit_patient_id BIGINT;
    patient_id BIGINT;
    health_unit_doctor_id BIGINT;
    doctor_id BIGINT;
    health_unit_id BIGINT;
BEGIN
    IF id_medication_in IS NULL AND (hashed_id_medication_in IS NULL OR hashed_id_medication_in = '') THEN
        RAISE EXCEPTION 'É necessário passar o id_medication ou o hashed_id_medication';
    ELSEIF id_medication_in IS NOT NULL AND hashed_id_medication_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não é possível passar o id_medication e o hashed_id_medication';
    ELSEIF id_medication_in IS NULL THEN
        SELECT id_medication INTO medication_id FROM medication WHERE hashed_id = hashed_id_medication_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Medicamento com o hashed_id "%" não existe', hashed_id_medication_in; --medication NOT FOUND
        END IF;
    ELSEIF hashed_id_medication_in IS NULL THEN
        SELECT id_medication INTO medication_id FROM medication WHERE medication.id_medication = id_medication_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Medicamento com o id "%" não existe', id_medication_in; --medication NOT FOUND
        END IF;
    END IF;

    --check if medication is active
    PERFORM 1 FROM medication WHERE medication.id_medication = medication_id AND medication.status = 1;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Medicamento não está ativo'; --medication NOT FOUND
    END IF;

    IF id_patient_in IS NULL AND (hashed_id_patient_in IS NULL OR hashed_id_patient_in = '') THEN
        RAISE EXCEPTION 'É necessário passar o id_patient ou o hashed_id_patient';
    ELSEIF id_patient_in IS NOT NULL AND hashed_id_patient_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não é possível passar o id_patient e o hashed_id_patient';
    ELSEIF id_patient_in IS NULL THEN
        SELECT id_user INTO patient_id FROM users WHERE hashed_id = hashed_id_patient_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Utente com o hashed_id "%" não existe', hashed_id_patient_in; --patient NOT FOUND
        END IF;
    ELSEIF hashed_id_patient_in IS NULL THEN
        SELECT id_user INTO patient_id FROM users WHERE id_user = id_patient_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Utente com o id "%" não existe', id_patient_in; --patient NOT FOUND
        END IF;
    END IF;

    -- Get Health Unit Patient
    SELECT id_health_unit_patient, id_patient INTO health_unit_patient_id, patient_id FROM health_unit_patient WHERE id_patient = patient_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Utente não está associado a nenhuma unidade de saúde';
    END IF;

    -- Get Health Unit Doctor Linked to Patient
    SELECT id_health_unit_doctor INTO health_unit_doctor_id FROM patient_doctor WHERE id_health_unit_patient = health_unit_patient_id AND status = 1;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Utente não está associado a nenhum médico';
    END IF;

    -- Check if Medication is an usual medication of the patient
    PERFORM
        id_medication 
    FROM medication_prescription mp
    INNER JOIN usual_medication um ON mp.id_medication_prescription = um.id_medication_prescription
    INNER JOIN prescription p ON mp.id_prescription = p.id_prescription
    INNER JOIN appointment a ON p.id_appointment = a.id_appointment AND id_user_patient = patient_id
    WHERE mp.id_medication = medication_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'A medicamento não é uma medicação habitual do utente';
    END IF;

    -- Check if Medication is already requested
    PERFORM
        id_usual_medication_request
    FROM usual_medication_request
    WHERE id_medication = medication_id AND id_patient = health_unit_patient_id AND status = 0;
    IF FOUND THEN
        RAISE EXCEPTION 'Já existe um pedido em curso para esta medicação';
    END IF;

    INSERT INTO usual_medication_request (id_medication, id_doctor, id_patient, status) VALUES (medication_id, health_unit_doctor_id, health_unit_patient_id, 0);
    RETURN TRUE;
    
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Set Hashed ID on New Rows
CREATE OR REPLACE FUNCTION set_usual_medication_request_hashed_id_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE usual_medication_request SET hashed_id = hash_id(NEW.id_usual_medication_request) WHERE id_usual_medication_request = NEW.id_usual_medication_request;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Trigger to Set Hashed ID on New Rows
CREATE OR REPLACE TRIGGER set_usual_medication_request_hashed_id_trigger
AFTER INSERT ON usual_medication_request
FOR EACH ROW
EXECUTE PROCEDURE set_usual_medication_request_hashed_id_function();
--
--
--
-- Get Usual Medication Requests
CREATE OR REPLACE FUNCTION get_usual_medication_requests(
    id_health_unit_in BIGINT DEFAULT NULL,
    hashed_id_health_unit_in VARCHAR(255) DEFAULT NULL,
    id_doctor_in BIGINT DEFAULT NULL,
    hashed_id_doctor_in VARCHAR(255) DEFAULT NULL,
    id_patient_in BIGINT DEFAULT NULL,
    hashed_id_patient_in VARCHAR(255) DEFAULT NULL,
    status_in INT DEFAULT NULL
) RETURNS TABLE (
    hashed_id_medication VARCHAR(255),
    medication_name VARCHAR(255),
    hashed_id_usual_medication_request VARCHAR(255),
    request_date TIMESTAMP,
    response_date TIMESTAMP,
    status INT,
    hashed_id_health_unit VARCHAR(255),
    health_unit_name VARCHAR(255),
    health_unit_email VARCHAR(255),
    health_unit_phone_number VARCHAR(255),
    health_unit_type health_unit_type,
    health_unit_tax_number INT,
    health_unit_address VARCHAR(255),
    health_unit_door_number VARCHAR(255),
    health_unit_floor VARCHAR(255),
    health_unit_zip_code VARCHAR(255),
    health_unit_county_name VARCHAR(255),
    health_unit_district_name VARCHAR(255),
    health_unit_country_name VARCHAR(255),
    health_unit_status INT,
    hashed_id_doctor VARCHAR(255),
    doctor_username VARCHAR(255),
    doctor_email VARCHAR(255),
    doctor_first_name VARCHAR(255),
    doctor_last_name VARCHAR(255),
    doctor_birth_date DATE,
    doctor_gender gender,
    doctor_tax_number INT,
    doctor_phone_number VARCHAR(255),
    doctor_address VARCHAR(255),
    doctor_door_number VARCHAR(255),
    doctor_floor VARCHAR(255),
    doctor_zip_code VARCHAR(255),
    doctor_county_name VARCHAR(255),
    doctor_district_name VARCHAR(255),
    doctor_country_name VARCHAR(255),
    doctor_status INT,
    doctor_number VARCHAR(255),
    hashed_id_patient VARCHAR(255),
    patient_username VARCHAR(255),
    patient_email VARCHAR(255),
    patient_first_name VARCHAR(255),
    patient_last_name VARCHAR(255),
    patient_birth_date DATE,
    patient_gender gender,
    patient_tax_number INT,
    patient_phone_number VARCHAR(255),
    patient_address VARCHAR(255),
    patient_door_number VARCHAR(255),
    patient_floor VARCHAR(255),
    patient_zip_code VARCHAR(255),
    patient_county_name VARCHAR(255),
    patient_district_name VARCHAR(255),
    patient_country_name VARCHAR(255),
    patient_status INT,
    patient_number VARCHAR(255)

) AS $$
DECLARE
    appointment_id BIGINT DEFAULT NULL;
    health_unit_id BIGINT DEFAULT NULL;
    doctor_id BIGINT DEFAULT NULL;
    patient_id BIGINT DEFAULT NULL;
    query TEXT;
    first_condition BOOLEAN DEFAULT TRUE;
BEGIN

    IF id_health_unit_in IS NOT NULL AND hashed_id_health_unit_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_health_unit. Ambos foram passados.';
    END IF;

    IF id_doctor_in IS NOT NULL AND hashed_id_doctor_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_doctor. Ambos foram passados.';
    END IF;

    IF id_patient_in IS NOT NULL AND hashed_id_patient_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_patient. Ambos foram passados.';
    END IF;

    query := 'SELECT
        umr.hashed_id as hashed_id_medication,
        m.medication_name as medication_name,
        umr.hashed_id as hashed_id_usual_medication_request,
        umr.request_date as request_date,
        umr.response_date as response_date,
        umr.status as status,
        hu.hashed_id as hashed_id_health_unit,
        hu.name as health_unit_name,
        hu.email as health_unit_email,
        hu.phone_number as health_unit_phone_number,
        hu.type as health_unit_type,
        hu.tax_number as health_unit_tax_number,
        hu_zc.address as health_unit_address,
        hu_a.door_number as health_unit_door_number,
        hu_a.floor as health_unit_floor,
        hu_zc.zip_code as health_unit_zip_code,
        hu_c.county_name as health_unit_county_name,
        hu_d.district_name as health_unit_district_name,
        hu_ct.country_name as health_unit_country_name,
        hu.status as health_unit_status,
        u_doctor.hashed_id as hashed_id_doctor,
        u_doctor.username as doctor_username,
        u_doctor.email as doctor_email,
        ui_doctor.first_name as doctor_first_name,
        ui_doctor.last_name as doctor_last_name,
        ui_doctor.birth_date as doctor_birth_date,
        ui_doctor.gender as doctor_gender,
        ui_doctor.tax_number as doctor_tax_number,
        ui_doctor.phone_number as doctor_phone_number,
        u_doctor_zc.address as doctor_address,
        u_doctor_a.door_number as doctor_door_number,
        u_doctor_a.floor as doctor_floor,
        u_doctor_zc.zip_code as doctor_zip_code,
        u_doctor_c.county_name as doctor_county_name,
        u_doctor_d.district_name as doctor_district_name,
        u_doctor_ct.country_name as doctor_country_name,
        u_doctor.status as doctor_status,
        doc.doctor_number as doctor_number,
        u_patient.hashed_id as hashed_id_patient,
        u_patient.username as patient_username,
        u_patient.email as patient_email,
        ui_patient.first_name as patient_first_name,
        ui_patient.last_name as patient_last_name,
        ui_patient.birth_date as patient_birth_date,
        ui_patient.gender as patient_gender,
        ui_patient.tax_number as patient_tax_number,
        ui_patient.phone_number as patient_phone_number,
        u_patient_zc.address as patient_address,
        u_patient_a.door_number as patient_door_number,
        u_patient_a.floor as patient_floor,
        u_patient_zc.zip_code as patient_zip_code,
        u_patient_c.county_name as patient_county_name,
        u_patient_d.district_name as patient_district_name,
        u_patient_ct.country_name as patient_country_name,
        u_patient.status as patient_status,
        pat.patient_number as patient_number
        FROM usual_medication_request umr
        INNER JOIN medication m ON m.id_medication = umr.id_medication
        INNER JOIN health_unit_patient hup ON hup.id_health_unit_patient = umr.id_patient
        INNER JOIN health_unit_doctor hud ON hud.id_health_unit_doctor = umr.id_doctor
        INNER JOIN health_unit hu ON hu.id_health_unit = hup.id_health_unit AND hu.id_health_unit = hud.id_health_unit
        INNER JOIN users u_doctor ON u_doctor.id_user = hud.id_doctor
        INNER JOIN users u_patient ON u_patient.id_user = hup.id_patient
        INNER JOIN user_info ui_doctor ON ui_doctor.id_user = u_doctor.id_user
        INNER JOIN user_info ui_patient ON ui_patient.id_user = u_patient.id_user
        INNER JOIN address u_doctor_a ON u_doctor_a.id_address = ui_doctor.id_address
        INNER JOIN address u_patient_a ON u_patient_a.id_address = ui_patient.id_address
        INNER JOIN zip_code u_doctor_zc ON u_doctor_zc.id_zip_code = u_doctor_a.id_zip_code
        INNER JOIN zip_code u_patient_zc ON u_patient_zc.id_zip_code = u_patient_a.id_zip_code
        INNER JOIN county u_doctor_c ON u_doctor_c.id_county = u_doctor_zc.id_county
        INNER JOIN county u_patient_c ON u_patient_c.id_county = u_patient_zc.id_county
        INNER JOIN district u_doctor_d ON u_doctor_d.id_district = u_doctor_c.id_district
        INNER JOIN district u_patient_d ON u_patient_d.id_district = u_patient_c.id_district
        INNER JOIN country u_doctor_ct ON u_doctor_ct.id_country = u_doctor_d.id_country
        INNER JOIN country u_patient_ct ON u_patient_ct.id_country = u_patient_d.id_country
        INNER JOIN patient pat ON pat.id_user = u_patient.id_user
        INNER JOIN doctor doc ON doc.id_user = u_doctor.id_user
        INNER JOIN address hu_a ON hu_a.id_address = hu.id_address
        INNER JOIN zip_code hu_zc ON hu_zc.id_zip_code = hu_a.id_zip_code
        INNER JOIN county hu_c ON hu_c.id_county = hu_zc.id_county
        INNER JOIN district hu_d ON hu_d.id_district = hu_c.id_district
        INNER JOIN country hu_ct ON hu_ct.id_country = hu_d.id_country
    ';

    IF id_health_unit_in IS NOT NULL THEN
        health_unit_id := id_health_unit_in;
        SELECT id_health_unit INTO health_unit_id FROM health_unit WHERE id_health_unit = id_health_unit_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe unidade de saúde com o id passado.';
        END IF;
    ELSIF hashed_id_health_unit_in IS NOT NULL AND hashed_id_health_unit_in != '' THEN
        SELECT id_health_unit INTO health_unit_id FROM health_unit WHERE hashed_id = hashed_id_health_unit_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe unidade de saúde com o hashed_id passado.';
        END IF;
    END IF;

    IF id_doctor_in IS NOT NULL THEN
        doctor_id := id_doctor_in;
        SELECT id_user INTO doctor_id FROM users WHERE id_user = id_doctor_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe médico com o id passado.';
        END IF;
    ELSIF hashed_id_doctor_in IS NOT NULL AND hashed_id_doctor_in != '' THEN
        SELECT id_user INTO doctor_id FROM users WHERE hashed_id = hashed_id_doctor_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe médico com o hashed_id passado.';
        END IF;
    END IF;

    IF id_patient_in IS NOT NULL THEN
        patient_id := id_patient_in;
        SELECT id_user INTO patient_id FROM users WHERE id_user = id_patient_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe paciente com o id passado.';
        END IF;
    ELSIF hashed_id_patient_in IS NOT NULL AND hashed_id_patient_in != '' THEN
        SELECT id_user INTO patient_id FROM users WHERE hashed_id = hashed_id_patient_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe paciente com o hashed_id passado.';
        END IF;
    END IF;

    IF health_unit_id IS NOT NULL OR doctor_id IS NOT NULL OR patient_id IS NOT NULL OR status_in IS NOT NULL THEN
        query := query || ' WHERE ';
    END IF;

    IF health_unit_id IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'hu.id_health_unit = ' || quote_literal(health_unit_id);
    END IF;

    IF doctor_id IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'u_doctor.id_user = ' || quote_literal(doctor_id);
    END IF;

    IF patient_id IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'u_patient.id_user = ' || quote_literal(patient_id);
    END IF;

    IF status_in IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'umr.status = ' || quote_literal(status_in);
    END IF;

    query := query || ' ORDER BY umr.request_date DESC';
    RETURN QUERY EXECUTE query;
END;
$$
LANGUAGE plpgsql;
--
--
--
-- Change status of a request
CREATE OR REPLACE FUNCTION change_request_status(
    id_usual_medication_request_in BIGINT DEFAULT NULL,
    hashed_id_usual_medication_request_in VARCHAR(255) DEFAULT NULL,
    status_in INTEGER DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    usual_medication_request_id INTEGER;
    actual_status INTEGER;

    id_user_patient BIGINT;
    id_user_doctor BIGINT;
    id_health_unit_out BIGINT;

    id_appointment_out BIGINT;
    hashed_id_appointment_out VARCHAR(255) DEFAULT NULL;
    start_date_out DATE;
    start_time_out TIME;
    end_time_out TIME;
    hashed_id_medication_out VARCHAR(255);
    medication_prescription_list_out json[];
BEGIN
    IF id_usual_medication_request_in IS NOT NULL THEN
        usual_medication_request_id := id_usual_medication_request_in;
        SELECT id_usual_medication_request INTO usual_medication_request_id FROM usual_medication_request WHERE id_usual_medication_request = id_usual_medication_request_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe pedido de medicação usual com o id passado.';
        END IF;
    ELSIF hashed_id_usual_medication_request_in IS NOT NULL AND hashed_id_usual_medication_request_in != '' THEN
        SELECT id_usual_medication_request INTO usual_medication_request_id FROM usual_medication_request WHERE hashed_id = hashed_id_usual_medication_request_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe pedido de medicação usual com o hashed_id passado.';
        END IF;
    END IF;

    IF status_in IS NULL OR (status_in != 0 AND status_in != 1 AND status_in != 2) THEN
        RAISE EXCEPTION 'O status passado é inválido.';
    END IF;

    SELECT status INTO actual_status FROM usual_medication_request WHERE id_usual_medication_request = usual_medication_request_id;

    IF status_in = actual_status THEN
        RAISE EXCEPTION 'O pedido já se encontra com o status passado.';
    END IF;

    IF actual_status = 0 THEN
        UPDATE usual_medication_request SET status = status_in, response_date = NOW() WHERE id_usual_medication_request = usual_medication_request_id;
    ELSE 
        RAISE EXCEPTION 'O pedido já se encontra respondido.';
    END IF;

    IF status_in = 1 THEN

        SELECT 
            u.id_user INTO id_user_patient
        FROM usual_medication_request umr
        INNER JOIN health_unit_patient hup ON hup.id_health_unit_patient = umr.id_patient
        INNER JOIN users u ON u.id_user = hup.id_patient
        WHERE umr.id_usual_medication_request = usual_medication_request_id;

        SELECT 
            u.id_user INTO id_user_doctor
        FROM usual_medication_request umr
        INNER JOIN health_unit_doctor hud ON hud.id_health_unit_doctor = umr.id_doctor
        INNER JOIN users u ON u.id_user = hud.id_doctor
        WHERE umr.id_usual_medication_request = usual_medication_request_id;

        SELECT 
            hu.id_health_unit INTO id_health_unit_out
        FROM usual_medication_request umr
        INNER JOIN health_unit_patient hup ON hup.id_health_unit_patient = umr.id_patient
        INNER JOIN health_unit hu ON hu.id_health_unit = hup.id_health_unit
        WHERE umr.id_usual_medication_request = usual_medication_request_id;

        SELECT 
            m.hashed_id INTO hashed_id_medication_out
        FROM usual_medication_request umr
        INNER JOIN medication m ON m.id_medication = umr.id_medication
        WHERE umr.id_usual_medication_request = usual_medication_request_id;


        start_date_out := NOW()::DATE;
        start_time_out := NOW()::TIME;
        end_time_out := NOW()::TIME + '00:05:00'::INTERVAL;
        INSERT INTO appointment (id_health_unit, id_user_doctor, id_user_patient, status, start_date, start_time, end_time, type) VALUES (id_health_unit_out, id_user_doctor, id_user_patient, 1, start_date_out, start_time_out, end_time_out, 1) RETURNING id_appointment INTO id_appointment_out;

        medication_prescription_list_out = ARRAY(
            SELECT json_build_object(
                'hashed_id_medication', hashed_id_medication_out,
                'prescribed_amount', 1
            )
        );



        PERFORM create_prescription_with_medication(
            id_appointment_out,
            hashed_id_appointment_out,
            NOW()::TIMESTAMP without time zone,
            1,
            medication_prescription_list_out
        );
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
    
END;
$$ LANGUAGE plpgsql;

SELECT * FROM change_request_status(NULL, '7902699be42c8a8e46fbbb4501726517e86b22c56a189f7625a6da49081b2451', 1)


       
