CREATE TABLE vaccine (
	id_vaccine BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('vaccine_sequence'::regclass),
	hashed_id VARCHAR(255) NULL,
	vaccine_name VARCHAR(255) UNIQUE NOT NULL,
	status INT NOT NULL DEFAULT 0,
	created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION insert_vaccine(
    IN vaccine_name VARCHAR(50),
    IN status INTEGER DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
    id_vaccine_out INTEGER;
BEGIN
	
	IF EXISTS (SELECT * FROM vaccine WHERE vaccine.vaccine_name = insert_vaccine.vaccine_name) THEN
    	RAISE EXCEPTION 'O nome desta vacina já está registado.';
	END IF;

	IF insert_vaccine.vaccine_name = '' THEN
        RAISE EXCEPTION 'O nome da vacina não pode ser vazio.';
    END IF;
	
    IF insert_vaccine.vaccine_name IS NULL THEN
        RAISE EXCEPTION 'O nome da vacina não pode ser nulo.';   
    END IF;

    IF insert_vaccine.status IS NULL THEN
        insert_vaccine.status := 1;
    END IF;

    IF EXISTS(SELECT * FROM vaccine WHERE vaccine.vaccine_name = insert_vaccine.vaccine_name) THEN
        RAISE EXCEPTION 'Já existe uma vacina com esse nome.';
    END IF;

    INSERT INTO vaccine (vaccine_name, status) VALUES (insert_vaccine.vaccine_name, insert_vaccine.status) RETURNING id_vaccine INTO id_vaccine_out;
    UPDATE vaccine SET hashed_id = hash_id(id_vaccine_out) WHERE id_vaccine = id_vaccine_out;
    RETURN id_vaccine_out;
END;
$$ LANGUAGE plpgsql;

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
CREATE OR REPLACE TRIGGER set_hashed_id
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
    id_vaccine BIGINT,
    hashed_id VARCHAR(50),
    vaccine_name VARCHAR(50),
    status INT DEFAULT NULL
) RETURNS BOOLEAN AS $$ 
    BEGIN 
	
		IF update_vaccine.vaccine_name IS NULL THEN
            RAISE EXCEPTION 'O nome da vacina não pode ser nulo.';
		END IF;
		
		IF EXISTS (SELECT * FROM vaccine WHERE vaccine.vaccine_name = update_vaccine.vaccine_name) THEN
    		RAISE EXCEPTION 'O nome desta vacina já está registado.';
		END IF;

		IF update_vaccine.vaccine_name = '' THEN
        	RAISE EXCEPTION 'O nome da vacina não pode ser vazio.';
    	END IF;
        
        IF update_vaccine.id_vaccine IS NOT NULL AND hashed_id IS NOT NULL THEN
            RAISE EXCEPTION 'Não é possível atualizar o id e o hashed_id ao mesmo tempo.';
        END IF;

        IF update_vaccine.hashed_id IS NOT NULL THEN
            SELECT vaccine.id_vaccine INTO id_vaccine FROM vaccine WHERE vaccine.hashed_id = update_vaccine.hashed_id;
			IF update_vaccine.status IS NULL THEN
			SELECT vaccine.status INTO status FROM vaccine WHERE vaccine.hashed_id = update_vaccine.hashed_id;
			END IF;
        ELSEIF update_vaccine.id_vaccine IS NOT NULL THEN
            SELECT vaccine.id_vaccine INTO id_vaccine FROM vaccine WHERE vaccine.id_vaccine = update_vaccine.id_vaccine;
			IF update_vaccine.status IS NULL THEN
			SELECT vaccine.status INTO status FROM vaccine WHERE vaccine.id_vaccine = update_vaccine.id_vaccine;
			END IF;
        ELSE
            RAISE EXCEPTION 'É necessário passar o "hashed_id" ou o "id_vaccine".';
        END IF;  
		IF id_vaccine IS NOT NULL THEN
			UPDATE vaccine SET vaccine_name = update_vaccine.vaccine_name, status = update_vaccine.status;
			RETURN TRUE;
		ELSE
			RAISE EXCEPTION 'Vacina não encontrada.';
		END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_vaccine(
    id_vaccine_in BIGINT DEFAULT NULL,
    hashed_id_in VARCHAR(50) DEFAULT NULL
) RETURNS TABLE (
    id_vaccine BIGINT,
    hashed_id VARCHAR(50),
    vaccine_name VARCHAR(50),
    status INT,
    created_at TIMESTAMP
) AS $$ 
    BEGIN
		IF id_vaccine_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
            RAISE EXCEPTION 'Não é possível procurar pelo id e o hashed_id ao mesmo tempo.';
        END IF;
		
        IF id_vaccine_in IS NULL AND hashed_id_in IS NULL THEN
        	RETURN QUERY SELECT * FROM vaccine;
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


--testes
ALTER TABLE vaccine ADD COLUMN hashed_id VARCHAR(255) NULL
SELECT insert_vaccine('COVID-18');
SELECT insert_vaccine('Poliomielite');
SELECT insert_vaccine('BCG');
SELECT insert_vaccine('Tétano');
SELECT * FROM vaccine
SELECT * FROM get_vaccine();
SELECT delete_vaccine(14, NULL);
SELECT update_vaccine(NULL,'2c624232cdd221771294dfbb310aca000a0df6ac8b66b696d90ef06fdefb64a3','COVID-19');
SELECT * FROM get_vaccine(12, '6b51d431df5d7f141cbececcf79edf3dd861c3b4069f0b11661a3eefacbba918');


-- verificação do nome das vacinas (tem que ser unicos)