
-- Check Usual Medication ID
CREATE OR REPLACE FUNCTION check_usual_medication_id(
    usual_medication_id_in BIGINT
)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 
        FROM usual_medication 
        WHERE id_usual_medication = usual_medication_id_in
    );
END;
$$ LANGUAGE plpgsql;



-- Insert Usual Medication
CREATE OR REPLACE FUNCTION add_usual_medication_prescription(
    id_patient_in BIGINT,
    id_medication_in BIGINT,
    id_medication_prescription_in BIGINT,
    status_in INT DEFAULT 1
)
RETURNS BIGINT AS $$
DECLARE
    usual_medication_id BIGINT;
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM users 
        WHERE id_user = id_patient_in
    ) THEN
        RAISE EXCEPTION 'Usuário com o ID "%" não existe', id_patient_in;
    END IF;

    IF NOT EXISTS (
        SELECT 1 
        FROM medication 
        WHERE id_medication = id_medication_in
    ) THEN
        RAISE EXCEPTION 'Medicação com o ID "%" não existe', id_medication_in;
    END IF;

    IF id_medication_prescription_in IS NOT NULL AND NOT EXISTS (
        SELECT 1 
        FROM medication_prescription 
        WHERE id_medication_prescription = id_medication_prescription_in
    ) THEN
        RAISE EXCEPTION 'Prescrição de Medicamento com o ID "%" não existe', id_medication_prescription_in;
    END IF;

    INSERT INTO usual_medication (id_patient, id_medication, id_medication_prescription, status)
    VALUES (id_patient_in, id_medication_in, id_medication_prescription_in, status_in)
    RETURNING id_usual_medication INTO usual_medication_id;

    RETURN usual_medication_id;
END;
$$ LANGUAGE plpgsql;




-- Update Usual Medication
CREATE OR REPLACE FUNCTION update_usual_medication(
    usual_medication_id BIGINT,
    patient_id BIGINT,
    medication_id BIGINT,
    medication_prescription_id BIGINT
) RETURNS BOOLEAN AS $$
BEGIN
    IF NOT check_usual_medication_id(usual_medication_id) THEN
        RAISE EXCEPTION 'Medicação usual com o ID "%" não existe', usual_medication_id;
    END IF;
    IF NOT EXISTS(SELECT 1 FROM users WHERE id_user = patient_id) THEN
        RAISE EXCEPTION 'Utilizador com o ID "%" não existe', patient_id;
    END IF;
    IF NOT EXISTS(SELECT 1 FROM medication WHERE id_medication = medication_id) THEN
        RAISE EXCEPTION 'Medicação com o ID "%" não existe', medication_id;
    END IF;
    IF medication_prescription_id IS NOT NULL AND NOT check_medication_prescription_id(medication_prescription_id) THEN
        RAISE EXCEPTION 'Prescrição de Medicamento com o ID "%" não existe', medication_prescription_id;
    END IF;
    
    UPDATE usual_medication SET
        id_patient = patient_id,
        id_medication = medication_id,
        id_medication_prescription = medication_prescription_id
    WHERE id_usual_medication = usual_medication_id;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


-- Change usual medication Status
CREATE OR REPLACE FUNCTION change_usual_medication_status(
    IN id_patient_in BIGINT,
    IN id_medication_in BIGINT,
    IN id_medication_prescription_in BIGINT DEFAULT NULL,
    IN status_in INT DEFAULT 1
)
RETURNS BOOLEAN AS $$
BEGIN
    IF status_in <> 0 AND status_in <> 1 THEN
        RAISE EXCEPTION 'O status deve ser 0 ou 1';
    END IF;

    IF id_medication_prescription_in IS NOT NULL AND NOT EXISTS (
        SELECT 1 
        FROM medication_prescription 
        WHERE id_medication_prescription = id_medication_prescription_in
    ) THEN
        RAISE EXCEPTION 'Prescrição de Medicamento com o ID "%" não existe', id_medication_prescription_in;
    END IF;

    UPDATE usual_medication 
    SET status = status_in, updated_at = NOW() 
    WHERE id_patient = id_patient_in 
    AND id_medication = id_medication_in 
    AND (id_medication_prescription = id_medication_prescription_in OR id_medication_prescription IS NULL AND id_medication_prescription_in IS NULL);
    
    IF FOUND THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Set Hashed ID on New Rows
CREATE OR REPLACE FUNCTION set_usual_medication_hashed_id_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE users SET hashed_id = hash_id(NEW.id_patient) WHERE id_user = NEW.id_patient;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Trigger to Set Hashed ID on New Rows
CREATE OR REPLACE TRIGGER set_usual_medication_hashed_id_trigger
AFTER INSERT ON usual_medication
FOR EACH ROW
EXECUTE PROCEDURE set_usual_medication_hashed_id_function();
