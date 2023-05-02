CREATE OR REPLACE FUNCTION insert_vaccine(
    IN vaccine_name VARCHAR(50),
    IN status INTEGER DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
    id_vaccine_out INTEGER;
BEGIN
    IF vaccine_name IS NULL THEN
        RAISE EXCEPTION 'O nome da vacina não pode ser nulo';   
    END IF;

    IF status IS NULL THEN
        status := 1;
    END IF;

    IF EXISTS(SELECT * FROM vaccine WHERE vaccine_name = vaccine_name) THEN
        RAISE EXCEPTION 'Já existe uma vacina com esse nome';
    END IF;

    INSERT INTO vaccine (vaccine_name, status) VALUES (vaccine_name, status) RETURNING vaccine.id_vaccine INTO id_vaccine_out;
    UPDATE vaccine SET hashed_id = hash_id(id_vaccine_out) WHERE id_vaccine = id_vaccine_out;
    RETURN id_vaccine;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_vaccine(
    id_vaccine BIGINT
) RETURNS BOOLEAN AS $$ 
BEGIN
    IF delete_vaccine.id_vaccine IS NOT NULL THEN
        DELETE FROM vaccine v WHERE v.id_vaccine = delete_vaccine.id_vaccine;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_vaccine(
    id_vaccine BIGINT,
    hashed_id VARCHAR(50),
    vaccine_name VARCHAR(50),
    status INT DEFAULT NULL
) RETURNS BOOLEAN AS $$ 
    BEGIN 
        
        IF id_vaccine IS NOT NULL AND hashed_id IS NOT NULL THEN
            RAISE EXCEPTION 'Não é possível atualizar o id e o hashed_id ao mesmo tempo';
        END IF;

        IF hashed_id IS NOT NULL THEN
            SELECT vaccine.id_vaccine INTO id_vaccine FROM vaccine WHERE vaccine.hashed_id = hashed_id;
        ELSEIF id_vaccine IS NOT NULL THEN
            SELECT vaccine.id_user INTO id_vaccine FROM vaccine WHERE vaccine.id_vaccine = id_vaccine;
        ELSE
            RAISE EXCEPTION 'É necessário passar o "hashed_id" ou o "id_user".';
        END IF;

        IF update_vaccine.id_vaccine IS NOT NULL AND update_vaccine.vaccine_name IS NOT NULL THEN
            UPDATE vaccine v SET vaccine_name = update_vaccine.vaccine_name, status = update_vaccine.status WHERE v.id_vaccine = update_vaccine.id_vaccine;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_vaccine(
    id_vaccine_in BIGINT,
    hashed_id_in VARCHAR(50)
) RETURNS TABLE (
    id_vaccine BIGINT,
    hashed_id VARCHAR(50),
    vaccine_name VARCHAR(50),
    status INT,
    created_at TIMESTAMP
) AS $$ 
    BEGIN
        IF id_vaccine IS NULL THEN
            RETURN QUERY SELECT * FROM VACCINE;
            ELSEIF hashed_id_in IS NULL THEN
                RETURN QUERY SELECT * FROM VACCINE WHERE VACCINE.id_vaccine = get_vaccine.id_vaccine_in;
                IF NOT FOUND THEN
                    RAISE EXCEPTION 'Vacina com o id_vaccine "%" não existe', id_vaccine_in;
                END IF;
            ELSEIF id_vaccine_in IS NULL THEN
                RETURN QUERY SELECT * FROM VACCINE WHERE VACCINE.hashed_id = get_vaccine.hashed_id_in;
                IF NOT FOUND THEN
                    RAISE EXCEPTION 'Vacina com o hashed_id "%" não existe', hashed_id_in;
                END IF;
            END IF;
END;
$$ LANGUAGE plpgsql;
