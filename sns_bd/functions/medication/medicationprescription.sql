-- Check Medication Prescription ID
CREATE OR REPLACE FUNCTION check_medication_prescription_id(
    medication_prescription_id BIGINT
) RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS(SELECT 1 FROM medication_prescription WHERE id_medication_prescription = medication_prescription_id);
END;
$$ LANGUAGE plpgsql;


-- Insert Medication Prescription
CREATE OR REPLACE FUNCTION create_medication_prescription(
    prescription_name VARCHAR(255),
    medication_id BIGINT,
    status INT DEFAULT 1
) RETURNS BOOLEAN AS $$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM medication WHERE id_medication = medication_id) THEN
        RAISE EXCEPTION 'Medicação com o ID "%" não existe', medication_id;
    END IF;
    
    INSERT INTO medication_prescription (prescription_name, id_medication, status)
    VALUES (prescription_name, medication_id, status);
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


-- Update Medication Prescription
CREATE OR REPLACE FUNCTION update_medication_prescription(
    medication_prescription_id BIGINT,
    prescription_name VARCHAR(255),
    medication_id BIGINT,
    status INT DEFAULT NULL
) RETURNS BOOLEAN AS $$
BEGIN
    IF NOT check_medication_prescription_id(medication_prescription_id) THEN
        RAISE EXCEPTION 'Prescrição de Medicamento com o ID "%" não existe', medication_prescription_id;
    END IF;

    IF medication_id IS NOT NULL THEN
        IF NOT EXISTS(SELECT 1 FROM medication WHERE id_medication = medication_id) THEN
            RAISE EXCEPTION 'Medicação com o ID "%" não existe', medication_id;
        END IF;
    END IF;

    UPDATE medication_prescription SET
        prescription_name = prescription_name,
        id_medication = COALESCE(medication_id, id_medication),
        status = COALESCE(status, status)
    WHERE id_medication_prescription = medication_prescription_id;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


-- Change Medication Prescription Status
CREATE OR REPLACE FUNCTION change_medication_prescription_status(
    IN medication_prescription_id_in BIGINT,
    IN status_in INT DEFAULT 1
)
RETURNS BOOLEAN AS $$
BEGIN
    IF status_in <> 0 AND status_in <> 1 THEN
        RAISE EXCEPTION 'O status deve ser 0 ou 1';
    END IF;

    IF NOT check_medication_prescription_id(medication_prescription_id_in) THEN
        RAISE EXCEPTION 'Prescrição de Medicamento com o ID "%" não existe', medication_prescription_id_in;
    END IF;

    UPDATE medication_prescription SET status = status_in WHERE id_medication_prescription = medication_prescription_id_in;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


-- Set Hashed ID on New Rows
CREATE OR REPLACE FUNCTION set_medication_prescription_hashed_id_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE medication_prescription SET hashed_id = hash_id(NEW.id_medication_prescription) WHERE id_medication_prescription = NEW.id_medication_prescription;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Trigger to Set Hashed ID on New Rows
CREATE OR REPLACE TRIGGER set_medication_prescription_hashed_id_trigger
AFTER INSERT ON medication_prescription
FOR EACH ROW
EXECUTE PROCEDURE set_medication_prescription_hashed_id_function();