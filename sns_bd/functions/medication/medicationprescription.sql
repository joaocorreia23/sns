
-- Check Medication Prescription ID
CREATE OR REPLACE FUNCTION check_medication_prescription_id(
    medication_prescription_id BIGINT
) RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS(SELECT 1 FROM medication_prescription WHERE id_medication_prescription = medication_prescription_id);
END;
$$ LANGUAGE plpgsql;


-- Insert Medication Prescription
CREATE OR REPLACE FUNCTION add_medication_prescription(
    prescription_id_in BIGINT,
    medication_id_in BIGINT,
    access_pin_in INT,
    option_pin_in INT,
    prescription_number_in INT,
    expiration_date_in TIMESTAMP,
    prescribed_amount_in FLOAT,
    available_amount_in FLOAT,
    use_description_in VARCHAR(255)
) RETURNS VOID AS $$
BEGIN
    IF NOT check_prescription_id(prescription_id_in) THEN
        RAISE EXCEPTION 'Prescrição com o ID "%" não existe', prescription_id_in;
    END IF;
    
    IF NOT EXISTS(SELECT 1 FROM medication WHERE id_medication = medication_id_in) THEN
        RAISE EXCEPTION 'Medicação com o ID "%" não existe', medication_id_in;
    END IF;
    
    IF access_pin_in IS NOT NULL AND access_pin_in < 0 THEN
        RAISE EXCEPTION 'O PIN de Acesso deve ser um valor não negativo ou nulo';
    END IF;
    
    IF option_pin_in IS NOT NULL AND option_pin_in < 0 THEN
        RAISE EXCEPTION 'O PIN opcional deve ser um valor não negativo ou nulo';
    END IF;
    
    IF prescription_number_in IS NOT NULL AND prescription_number_in <= 0 THEN
        RAISE EXCEPTION 'O Número da prescrição deve ser um valor positivo ou nulo';
    END IF;
    
    IF expiration_date_in IS NOT NULL AND expiration_date_in <= NOW() THEN
        RAISE EXCEPTION 'A data de validade deve ser posterior à data atual';
    END IF;
    
    IF prescribed_amount_in <= 0 THEN
        RAISE EXCEPTION 'A quantidade prescrita deve ser um valor positivo';
    END IF;
    
    IF available_amount_in < 0 THEN
        RAISE EXCEPTION 'A quantidade disponível deve ser um valor não negativo';
    END IF;

    INSERT INTO medication_prescription (
        id_prescription,
        id_medication,
        access_pin,
        option_pin,
        prescription_number,
        expiration_date,
        prescribed_amount,
        available_amount,
        use_description
    ) VALUES (
        prescription_id_in,
        medication_id_in,
        access_pin_in,
        option_pin_in,
        prescription_number_in,
        expiration_date_in,
        prescribed_amount_in,
        available_amount_in,
        use_description_in
    );
END;
$$ LANGUAGE plpgsql;


-- Update Medication Prescription
CREATE OR REPLACE FUNCTION update_medication_prescription(
    medication_prescription_id_in BIGINT,
    prescription_id_in BIGINT,
    medication_id_in BIGINT,
    access_pin_in INT,
    option_pin_in INT,
    prescription_number_in INT,
    expiration_date_in TIMESTAMP,
    prescribed_amount_in FLOAT,
    available_amount_in FLOAT,
    use_description_in VARCHAR(255)
) RETURNS VOID AS $$
BEGIN
    IF NOT check_medication_prescription_id(medication_prescription_id_in) THEN
        RAISE EXCEPTION 'Prescrição de Medicamento com o ID "%" não existe', medication_prescription_id_in;
 IF prescription_id_in IS NOT NULL AND NOT check_prescription_id(prescription_id_in) THEN
        RAISE EXCEPTION 'Prescrição com o ID "%" não existe', prescription_id_in;
    END IF;

    IF medication_id_in IS NOT NULL AND NOT EXISTS(SELECT 1 FROM medication WHERE id_medication = medication_id_in) THEN
        RAISE EXCEPTION 'Medicação com o ID "%" não existe', medication_id_in;
    END IF;

    IF access_pin_in IS NOT NULL AND access_pin_in < 0 THEN
        RAISE EXCEPTION 'O PIN de Acesso deve ser um valor não negativo ou nulo';
    END IF;

    IF option_pin_in IS NOT NULL AND option_pin_in < 0 THEN
        RAISE EXCEPTION 'O PIN opcional deve ser um valor não negativo ou nulo';
    END IF;

    IF prescription_number_in IS NOT NULL AND prescription_number_in <= 0 THEN
        RAISE EXCEPTION 'O Numero da prescrição deve ser um valor positivo ou nulo';
    END IF;

    IF expiration_date_in IS NOT NULL AND expiration_date_in <= NOW() THEN
        RAISE EXCEPTION 'A data de validade deve ser posterior à data atual';
    END IF;

    IF prescribed_amount_in <= 0 THEN
        RAISE EXCEPTION 'A quantidade prescrita deve ser um valor positivo';
    END IF;

    IF available_amount_in < 0 THEN
        RAISE EXCEPTION 'A quantidade disponível deve ser um valor não negativo';
    END IF;

    UPDATE medication_prescription
    SET
        id_prescription = COALESCE(prescription_id_in, id_prescription),
        id_medication = COALESCE(medication_id_in, id_medication),
        access_pin = COALESCE(access_pin_in, access_pin),
        option_pin = COALESCE(option_pin_in, option_pin),
        prescription_number = COALESCE(prescription_number_in, prescription_number),
        expiration_date = COALESCE(expiration_date_in, expiration_date),
        prescribed_amount = COALESCE(prescribed_amount_in, prescribed_amount),
        available_amount = COALESCE(available_amount_in, available_amount),
        use_description = COALESCE(use_description_in, use_description)
    WHERE id_medication_prescription = medication_prescription_id_in;
END;
$$ LANGUAGE plpgsql;


-- Change medication prescription Status
CREATE OR REPLACE FUNCTION change_medication_prescription_status(
    IN id_medication_prescription_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL,
    IN status_in INT DEFAULT 1
)
RETURNS BOOLEAN AS $$
DECLARE
    medication_prescription_id BIGINT;
BEGIN
    IF status_in <> 0 AND status_in <> 1 THEN
        RAISE EXCEPTION 'O status deve ser 0 ou 1';
    END IF;

    IF id_medication_prescription_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_medication_prescription. Ambos foram passados.';
    END IF;

    IF hashed_id_in IS NOT NULL THEN
        SELECT medication_prescription.id_medication_prescription INTO medication_prescription_id 
        FROM medication_prescription 
        WHERE hashed_id = hashed_id_in;
    ELSE
        medication_prescription_id := id_medication_prescription_in;
    END IF;

    IF medication_prescription_id IS NULL AND id_medication_prescription_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhuma prescrição de medicamento com o ID passado';
    ELSEIF medication_prescription_id IS NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhuma prescrição de medicamento com o hashed_id passado';
    END IF;

    IF NOT EXISTS (
        SELECT medication_prescription.id_medication_prescription 
        FROM medication_prescription 
        WHERE medication_prescription.id_medication_prescription = medication_prescription_id 
        AND medication_prescription.status = status_in
    ) THEN
        UPDATE medication_prescription 
        SET status = status_in 
        WHERE id_medication_prescription = medication_prescription_id;
        RETURN TRUE;
    ELSE
        IF status_in = 0 THEN
            RAISE EXCEPTION 'A prescrição de medicamento já está desativada';
        ELSE
            RAISE EXCEPTION 'A prescrição de medicamento já está ativada';
        END IF;
    END IF;
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