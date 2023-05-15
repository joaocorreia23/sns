-- Check Medication Prescription ID
CREATE OR REPLACE FUNCTION check_medication_prescription_id(medication_prescription_id BIGINT)
    RETURNS BOOLEAN AS $$
DECLARE
    medication_prescription_id_exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM medication_prescription WHERE id_medication_prescription = medication_prescription_id) INTO medication_prescription_id_exists;
    RETURN medication_prescription_id_exists;
END;
$$ LANGUAGE plpgsql;

-- Insert Medication Prescription
CREATE OR REPLACE FUNCTION create_medication_prescription(
    id_prescription BIGINT,
    id_medication BIGINT,
    access_pin INT,
    option_pin INT,
    prescription_number INT,
    expiration_date TIMESTAMP,
    prescribed_amount FLOAT,
    available_amount FLOAT,
    use_description VARCHAR(255),
    status INT DEFAULT 1
) RETURNS BIGINT AS $$
DECLARE
    medication_prescription_id BIGINT;
BEGIN
    IF id_prescription IS NULL OR id_prescription = '' THEN
        RAISE EXCEPTION 'ID da prescrição nulo ou vazio';
    END IF;

    IF id_medication IS NULL OR id_medication = '' THEN
        RAISE EXCEPTION 'ID da medicação nulo ou vazio';
    END IF;
    
    INSERT INTO medication_prescription (id_prescription, id_medication, access_pin, option_pin, prescription_number, expiration_date, prescribed_amount, available_amount, use_description, status) 
    VALUES (id_prescription, id_medication, access_pin, option_pin, prescription_number, expiration_date, prescribed_amount, available_amount, use_description, status) 
    RETURNING id_medication_prescription INTO medication_prescription_id;
    RETURN medication_prescription_id;
END;
$$ LANGUAGE plpgsql;

-- Update Medication Prescription
CREATE OR REPLACE FUNCTION update_medication_prescription(
    medication_prescription_id_in BIGINT,
    id_prescription_in BIGINT DEFAULT NULL,
    id_medication_in BIGINT DEFAULT NULL,
    access_pin_in INT DEFAULT NULL,
    option_pin_in INT DEFAULT NULL,
    prescription_number_in INT DEFAULT NULL,
    expiration_date_in TIMESTAMP DEFAULT NULL,
    prescribed_amount_in FLOAT DEFAULT NULL,
    available_amount_in FLOAT DEFAULT NULL,
    use_description_in VARCHAR(255) DEFAULT NULL,
    status_in INT DEFAULT NULL
) RETURNS BOOLEAN AS $$
BEGIN
    IF medication_prescription_id_in IS NULL THEN
        RAISE EXCEPTION 'É necessário passar o ID da prescrição de medicação';
    END IF;

    IF NOT check_medication_prescription_id(medication_prescription_id_in) THEN
        RAISE EXCEPTION 'Prescrição de medicação com o ID "%" não existe', medication_prescription_id_in;
    END IF;

    IF id_prescription_in IS NOT NULL THEN
        UPDATE medication_prescription SET id_prescription = id_prescription_in WHERE id_medication_prescription = medication_prescription_id_in;
    END IF;

    IF id_medication_in IS NOT NULL THEN
        UPDATE medication_prescription SET id_medication = id_medication_in WHERE id_medication_prescription = medication_prescription_id_in;
    END IF;

    IF access_pin_in IS NOT NULL THEN
        UPDATE medication_prescription SET access_pin = access_pin_in WHERE id_medication_prescription = medication_prescription_id_in;
    END IF;

    IF option_pin_in IS NOT NULL THEN
        UPDATE medication_prescription SET option_pin = option_pin_in WHERE id_medication_prescription = medication_prescription_id_in;
    END IF;

    IF prescription_number_in IS NOT NULL THEN
        UPDATE medication_prescription SET prescription_number = prescription_number_in WHERE id_medication_prescription = medication_prescription_id_in;
    END IF;

    IF expiration_date_in IS NOT NULL THEN
        UPDATE medication_prescription SET expiration_date = expiration_date_in WHERE id_medication_prescription = medication_prescription_id_in;
    END IF;

    IF prescribed_amount_in IS NOT NULL THEN
        UPDATE medication_prescription SET prescribed_amount = prescribed_amount_in WHERE id_medication_prescription = medication_prescription_id_in;
    END IF;

    IF available_amount_in IS NOT NULL THEN
        UPDATE medication_prescription SET available_amount = available_amount_in WHERE id_medication_prescription = medication_prescription_id_in;
    END IF;

    IF use_description_in IS NOT NULL THEN
        UPDATE medication_prescription SET use_description = use_description_in WHERE id_medication_prescription = medication_prescription_id_in;
    END IF;

    IF status_in IS NOT NULL THEN
        UPDATE medication_prescription SET status = status_in WHERE id_medication_prescription = medication_prescription_id_in;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Delete Medication Prescription
CREATE OR REPLACE FUNCTION delete_medication_prescription(medication_prescription_id_in BIGINT)
    RETURNS BOOLEAN AS $$
BEGIN
    IF medication_prescription_id_in IS NULL THEN
        RAISE EXCEPTION 'É necessário passar o ID da prescrição de medicação';
    END IF;

    IF NOT check_medication_prescription_id(medication_prescription_id_in) THEN
        RAISE EXCEPTION 'Prescrição de medicação com o ID "%" não existe', medication_prescription_id_in;
    END IF;

    DELETE FROM medication_prescription WHERE id_medication_prescription = medication_prescription_id_in;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
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

-- Trigger to Set Hashed ID on New Rows
CREATE OR REPLACE FUNCTION set_medication_prescription_hashed_id_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE prescription SET hashed_id = hash_id(NEW.id_prescription) WHERE id_prescription = NEW.id_prescription;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
