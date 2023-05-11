--Create Vaccine 
CREATE OR REPLACE FUNCTION insert_vaccine(
    IN vaccine_name VARCHAR(50),
    IN status INTEGER DEFAULT 1
)
RETURNS INTEGER AS $$
DECLARE
    id_vaccine_out INTEGER;
BEGIN
	
	IF EXISTS (SELECT * FROM vaccine WHERE vaccine.vaccine_name = insert_vaccine.vaccine_name) THEN
    	RAISE EXCEPTION 'O nome da vacina já está registado.';
	END IF;

	IF insert_vaccine.vaccine_name = '' OR insert_vaccine.vaccine_name IS NULL THEN
        RAISE EXCEPTION 'O nome da vacina não pode ser nulo.';
    END IF;

    INSERT INTO vaccine (vaccine_name, status) VALUES (insert_vaccine.vaccine_name, insert_vaccine.status) RETURNING id_vaccine INTO id_vaccine_out;
    RETURN id_vaccine_out;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Set Hashed ID on New Rows
CREATE OR REPLACE FUNCTION set_vaccine_hashed_id()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE vaccine SET hashed_id = hash_id(NEW.id_vaccine) WHERE vaccine.id_vaccine = NEW.id_vaccine;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Trigger to Set Hashed ID on New Rows
CREATE OR REPLACE TRIGGER set_hashed_vaccine_id_trigger
AFTER INSERT ON vaccine
FOR EACH ROW
EXECUTE PROCEDURE set_vaccine_hashed_id();

CREATE OR REPLACE FUNCTION delete_vaccine(
    IN id_vaccine BIGINT DEFAULT NULL,
	IN hashed_id VARCHAR(50) DEFAULT NULL
) RETURNS BOOLEAN AS $$ 
BEGIN

	--para cada um verificar se existe na base de dados, se nao existir a vacina não existe
	IF delete_vaccine.id_vaccine IS NOT NULL AND NOT EXISTS (SELECT * FROM vaccine WHERE vaccine.id_vaccine = delete_vaccine.id_vaccine) THEN
		RAISE EXCEPTION 'Não existe vacina com esse id';
	END IF;
	
	IF delete_vaccine.hashed_id IS NOT NULL AND NOT EXISTS (SELECT * FROM vaccine WHERE vaccine.hashed_id = delete_vaccine.hashed_id) THEN
		RAISE EXCEPTION 'Não existe vacina com esse hashed_id';
	END IF;
	
    IF delete_vaccine.id_vaccine IS NOT NULL AND hashed_id IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_vaccine. Ambos foram passados.';
    ELSEIF delete_vaccine.id_vaccine IS NULL AND hashed_id IS NULL THEN
        RAISE EXCEPTION 'Tem de ser passado o hashed_id ou o id_vaccine.';
    END IF;
	
    IF delete_vaccine.id_vaccine IS NOT NULL THEN
        DELETE FROM vaccine WHERE vaccine.id_vaccine = delete_vaccine.id_vaccine;
    END IF;
	
	IF hashed_id IS NOT NULL THEN 
		DELETE FROM vaccine WHERE vaccine.hashed_id = delete_vaccine.hashed_id;
	END IF;
	
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_vaccine(
    id_vaccine BIGINT DEFAULT NULL,
    hashed_id VARCHAR(50) DEFAULT NULL,
    vaccine_name VARCHAR(50) DEFAULT NULL,
    status INT DEFAULT NULL
) RETURNS BOOLEAN AS $$ 
DECLARE
    id_vaccine_out INTEGER;
    BEGIN 
	
		IF update_vaccine.vaccine_name IS NULL OR update_vaccine.vaccine_name = '' THEN
            RAISE EXCEPTION 'O nome da vacina não pode ser nulo.';
		END IF;
		        
        IF update_vaccine.id_vaccine IS NOT NULL AND hashed_id IS NOT NULL THEN
            RAISE EXCEPTION 'Não é possível atualizar o id e o hashed_id ao mesmo tempo.';
        END IF;

        IF update_vaccine.hashed_id IS NOT NULL THEN
            SELECT vaccine.id_vaccine INTO id_vaccine_out FROM vaccine WHERE vaccine.hashed_id = update_vaccine.hashed_id;
            IF NOT FOUND THEN
                RAISE EXCEPTION 'Vacina com o hashed_id "%" não existe.', hashed_id;
            END IF;
        ELSEIF update_vaccine.id_vaccine IS NOT NULL THEN
            SELECT vaccine.id_vaccine INTO id_vaccine_out FROM vaccine WHERE vaccine.id_vaccine = update_vaccine.id_vaccine;
            IF NOT FOUND THEN
                RAISE EXCEPTION 'Vacina com o id_vaccine "%" não existe.', id_vaccine;
            END IF;
        ELSE
            RAISE EXCEPTION 'É necessário passar o "hashed_id" ou o "id_vaccine".';
        END IF; 

        IF status IS NULL THEN
            SELECT vaccine.status INTO status FROM vaccine WHERE vaccine.id_vaccine = id_vaccine_out;
        END IF; 

        IF NOT EXISTS (SELECT * FROM vaccine WHERE vaccine.vaccine_name=update_vaccine.vaccine_name AND vaccine.id_vaccine != id_vaccine_out) THEN
            UPDATE vaccine SET vaccine_name = update_vaccine.vaccine_name, status = update_vaccine.status WHERE vaccine.id_vaccine = id_vaccine_out;
        ELSE
            RAISE EXCEPTION 'O nome da vacina já está registado.';
        END IF;

        RETURN TRUE;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_vaccine(
    id_vaccine_in BIGINT DEFAULT NULL,
    hashed_id_in VARCHAR(50) DEFAULT NULL,
    status_in INT DEFAULT 1
) RETURNS TABLE (
    id_vaccine BIGINT,
    hashed_id VARCHAR(50),
    vaccine_name VARCHAR(50),
    status INT,
    created_at TIMESTAMP
) AS $$ 
    BEGIN
		IF id_vaccine_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
            RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_vaccine. Ambos foram passados.';
        END IF;
		
        IF id_vaccine_in IS NULL AND hashed_id_in IS NULL THEN
        	RETURN QUERY SELECT * FROM vaccine WHERE vaccine.status = get_vaccine.status_in;
    	ELSEIF hashed_id_in IS NULL THEN
       		RETURN QUERY SELECT * FROM vaccine WHERE vaccine.id_vaccine = get_vaccine.id_vaccine_in;
        	IF NOT FOUND THEN
        		RAISE EXCEPTION 'Vacina com o id_vaccine "%" não existe.', id_vaccine_in;
        	END IF;
			
    	ELSEIF id_vaccine_in IS NULL THEN
        	RETURN QUERY SELECT * FROM vaccine WHERE vaccine.hashed_id = get_vaccine.hashed_id_in;
        	IF NOT FOUND THEN
            	RAISE EXCEPTION 'Vacina com o hashed_id "%" não existe.', hashed_id_in;
         	END IF;
   		END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Change vaccine status
CREATE OR REPLACE FUNCTION change_vaccine_status(
    IN id_vaccine_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL,
    IN status_in INT DEFAULT 1
)
RETURNS BOOLEAN AS $$
DECLARE
    vaccine_id BIGINT;
BEGIN

    IF status_in <> 0 AND status_in <> 1 THEN
        RAISE EXCEPTION 'O status deve ser 0 ou 1';
    END IF;

    IF id_vaccine_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_vaccine. Ambos foram passados.';
    END IF;

    IF hashed_id_in IS NOT NULL THEN
        SELECT vaccine.id_vaccine INTO vaccine_id FROM vaccine WHERE hashed_id = hashed_id_in;
    ELSE
        vaccine_id := id_vaccine_in;
    END IF;

    IF vaccine_id IS NULL AND id_vaccine_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhuma Vacina com o id passado';
    ELSEIF vaccine_id IS NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhuma Vacina com o hashed_id passado';
    END IF;

    IF NOT EXISTS (SELECT vaccine.id_vaccine FROM vaccine WHERE vaccine.id_vaccine = vaccine_id AND vaccine.status = status_in) THEN
        UPDATE vaccine SET status = status_in WHERE id_vaccine = vaccine_id;
        RETURN TRUE;
    ELSE
        IF status_in = 0 THEN
            RAISE EXCEPTION 'A vacina já está desativada';
        ELSE
            RAISE EXCEPTION 'A vacina já está ativada';
        END IF;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
CREATE OR REPLACE FUNCTION create_appointment(
    id_health_unit_in BIGINT DEFAULT NULL,
    hashed_id_health_unit_in VARCHAR(255) DEFAULT NULL,
    id_doctor_in BIGINT DEFAULT NULL,
    hashed_id_doctor_in VARCHAR(255) DEFAULT NULL,
    id_patient_in BIGINT DEFAULT NULL,
    hashed_id_patient_in VARCHAR(255) DEFAULT NULL,
    start_date_in DATE DEFAULT NULL,
    start_time_in TIME DEFAULT NULL,
    end_time_in TIME DEFAULT NULL,
    status INT DEFAULT 0
) RETURNS BOOLEAN AS $$
DECLARE
    health_unit_id BIGINT;
    doctor_id BIGINT;
    patient_id BIGINT;
BEGIN
    IF id_health_unit_in IS NOT NULL AND hashed_id_health_unit_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_health_unit. Ambos foram passados.';
    ELSEIF (id_health_unit_in IS NULL) AND (hashed_id_health_unit_in IS NULL OR hashed_id_health_unit_in = '') THEN
        RAISE EXCEPTION 'É necessário passar o id ou o hashed_id da unidade de saúde.';
    END IF;

    IF id_doctor_in IS NOT NULL AND hashed_id_doctor_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_doctor. Ambos foram passados.';
    ELSEIF (id_doctor_in IS NULL) AND (hashed_id_doctor_in IS NULL OR hashed_id_doctor_in = '') THEN
        RAISE EXCEPTION 'É necessário passar o id ou o hashed_id do médico.';
    END IF;

    IF id_patient_in IS NOT NULL AND hashed_id_patient_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_patient. Ambos foram passados.';
    ELSEIF (id_patient_in IS NULL) AND (hashed_id_patient_in IS NULL OR hashed_id_patient_in = '') THEN
        RAISE EXCEPTION 'É necessário passar o id ou o hashed_id do paciente.';
    END IF;

    IF hashed_id_health_unit_in IS NOT NULL THEN
        SELECT health_unit.id_health_unit INTO health_unit_id FROM health_unit WHERE hashed_id = hashed_id_health_unit_in;
    ELSE
        health_unit_id := id_health_unit_in;
    END IF;

    IF hashed_id_doctor_in IS NOT NULL THEN
        SELECT users.id_user INTO doctor_id FROM users WHERE hashed_id = hashed_id_doctor_in;
    ELSE
        doctor_id := id_doctor_in;
    END IF;

    IF hashed_id_patient_in IS NOT NULL THEN
        SELECT users.id_user INTO patient_id FROM users WHERE hashed_id = hashed_id_patient_in;
    ELSE
        patient_id := id_patient_in;
    END IF;

    IF NOT EXISTS (SELECT * FROM health_unit WHERE id_health_unit = health_unit_id) THEN 
        RAISE EXCEPTION 'Unidade de Saúde não encontrada.';
    END IF;

    IF NOT EXISTS (SELECT * FROM users WHERE id_user = doctor_id) THEN 
        RAISE EXCEPTION 'Médico não encontrado.';
    ELSEIF (SELECT * FROM check_user_role(doctor_id, NULL, 'Doctor')) = FALSE THEN
        RAISE EXCEPTION 'O utilizador não é um médico.';
    END IF;

    IF NOT EXISTS (SELECT * FROM users WHERE id_user = patient_id) THEN 
        RAISE EXCEPTION 'Utente não encontrado.';
    ELSEIF (SELECT * FROM check_user_role(patient_id, NULL, 'Patient')) = FALSE THEN
        RAISE EXCEPTION 'O utilizador não é um utente.';
    END IF;

    IF doctor_id = patient_id THEN
        RAISE EXCEPTION 'O médico não pode ser o mesmo que o utente.';
    END IF;

    IF start_date_in IS NULL THEN
        RAISE EXCEPTION 'É necessário passar a data da consulta.';
    END IF;

    IF start_time_in IS NULL THEN
        RAISE EXCEPTION 'É necessário passar a hora da consulta.';
    END IF;

    IF end_date_in IS NULL THEN
        RAISE EXCEPTION 'É necessário passar a data de fim da consulta.';
    END IF;

    IF start_time_in >= end_time_in THEN
        RAISE EXCEPTION 'A hora de início da consulta tem de ser menor que a hora de fim da consulta.';
    END IF;

    IF start_date_in < CURRENT_DATE AND status_in == 0 THEN
        RAISE EXCEPTION 'Não é possível criar uma consulta pendente com uma data anterior à data atual.';
    END IF;
    
    INSERT INTO appointment (id_health_unit, id_user_doctor, id_user_patient, status, start_date, start_time, end_time) VALUES (health_unit_id, doctor_id, patient_id, status, start_date_in, start_time_in, end_time_in);
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
SELECT * FROM create_appointment(NULL, 'd4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35', NULL, '4ec9599fc203d176a301536c2e091a19bc852759b255bd6818810a42c5fed14a', NULL, '4523540f1504cd17100c4835e85b7eefd49911580f8efff0599a8f283be6b9e3', '2023-06-01', '10:00:00', '11:00:00');