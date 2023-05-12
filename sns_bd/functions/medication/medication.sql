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