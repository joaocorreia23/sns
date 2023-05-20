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
        RAISE EXCEPTION 'Utente já tem esta medicação na lista de medicações usuais';
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
    id_medication_prescription BIGINT,
    usual_medication_status INTEGER,
    usual_medication_created_at TIMESTAMP,
    usual_medication_updated_at TIMESTAMP,
    id_medication BIGINT,
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




       
