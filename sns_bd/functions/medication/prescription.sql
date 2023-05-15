-- Check Medication Prescription ID
CREATE OR REPLACE FUNCTION check_medication_prescription_id(
medication_prescription_id BIGINT
) RETURNS BOOLEAN AS $$
BEGIN
RETURN EXISTS(SELECT 1 FROM medication_prescription WHERE id_medication_prescription = medication_prescription_id);
END;
$$ LANGUAGE plpgsql;

--
-- Insert Medication Prescription
CREATE OR REPLACE FUNCTION add_medication_prescription(
prescription_id_in BIGINT,
medication_id_in BIGINT,
dosage_in VARCHAR(255),
frequency_in VARCHAR(255)
) RETURNS BIGINT AS $$
DECLARE
medication_prescription_id BIGINT;
BEGIN
IF NOT check_prescription_id(prescription_id_in) THEN
RAISE EXCEPTION 'Prescrição com o ID "%" não existe', prescription_id_in;
END IF;
IF NOT check_medication_id(medication_id_in) THEN
RAISE EXCEPTION 'Medicação com o ID "%" não existe', medication_id_in;
END IF;
INSERT INTO medication_prescription (prescription_id, medication_id, dosage, frequency)
VALUES (prescription_id_in, medication_id_in, dosage_in, frequency_in)
RETURNING id_medication_prescription INTO medication_prescription_id;
RETURN medication_prescription_id;
END;
$$ LANGUAGE plpgsql;


--
-- Update Medication Prescription
CREATE OR REPLACE FUNCTION update_medication_prescription(
medication_prescription_id_in BIGINT,
prescription_id_in BIGINT DEFAULT NULL,
medication_id_in BIGINT DEFAULT NULL,
dosage_in VARCHAR(255) DEFAULT NULL,
frequency_in VARCHAR(255) DEFAULT NULL
) RETURNS BOOLEAN AS $$
BEGIN
IF NOT check_medication_prescription_id(medication_prescription_id_in) THEN
RAISE EXCEPTION 'Prescrição de Medicamento com o ID "%" não existe', medication_prescription_id_in;
END IF;
IF prescription_id_in IS NOT NULL AND NOT check_prescription_id(prescription_id_in) THEN
RAISE EXCEPTION 'Prescrição com o ID "%" não existe', prescription_id_in;
END IF;
IF medication_id_in IS NOT NULL AND NOT check_medication_id(medication_id_in) THEN
RAISE EXCEPTION 'Medicação com o ID "%" não existe', medication_id_in;
END IF;
IF prescription_id_in IS NOT NULL THEN
UPDATE medication_prescription SET prescription_id = prescription_id_in WHERE id_medication_prescription = medication_prescription_id_in;
END IF;
IF medication_id_in IS NOT NULL THEN
UPDATE medication_prescription SET medication_id = medication_id_in WHERE id_medication_prescription = medication_prescription_id_in;
END IF;
IF dosage_in IS NOT NULL THEN
UPDATE medication_prescription SET dosage = dosage_in WHERE id_medication_prescription = medication_prescription_id_in;
END IF;
IF frequency_in IS NOT NULL THEN
UPDATE medication_prescription SET frequency = frequency_in WHERE id_medication_prescription = medication_prescription_id_in;
END IF;
RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
-- Delete Medication Prescription
CREATE OR REPLACE FUNCTION delete_medication_prescription(
    medication_prescription_id_in BIGINT
) RETURNS BOOLEAN AS $$
BEGIN
    IF NOT check_medication_prescription_id(medication_prescription_id_in) THEN
        RAISE EXCEPTION 'Prescrição de Medicamento com o ID "%" não existe', medication_prescription_id_in;
    END IF;
    
    DELETE FROM medication_prescription
    WHERE id_medication_prescription = medication_prescription_id_in;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


-- Set Hashed ID on New Rows
CREATE OR REPLACE FUNCTION set_medication_prescription_hashed_id_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE prescription SET hashed_id = hash_id(NEW.id_prescription) WHERE id_prescription = NEW.id_prescription;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Trigger to Set Hashed ID on New Rows
CREATE OR REPLACE TRIGGER set_prescription_hashed_id_trigger
AFTER INSERT ON prescription
FOR EACH ROW
EXECUTE PROCEDURE set_medication_prescription_hashed_id_function();