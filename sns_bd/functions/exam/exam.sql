-- Check Exam name
CREATE OR REPLACE FUNCTION check_exam_name(
    exam_name VARCHAR(255)
) RETURNS BOOLEAN AS $$
DECLARE
    exam_name_exists BOOLEAN;
BEGIN
    SELECT EXISTS(SELECT 1 FROM exam WHERE exam.exam_name = check_exam_name.exam_name) INTO exam_name_exists;
    RETURN exam_name_exists;
END;
$$ LANGUAGE plpgsql;

--
--
--
-- Insert Exam
CREATE OR REPLACE FUNCTION create_exam(
	exam_name VARCHAR(255),
	status INT DEFAULT 1
) RETURNS BOOLEAN AS $$
BEGIN
		
	IF(exam_name IS NULL OR exam_name='') THEN
		RAISE EXCEPTION 'Nome do exame nulo ou vazio';
	ELSE
        IF(check_exam_name(exam_name)) THEN
            RAISE EXCEPTION 'Nome do exame já existe';
        END IF;
    END IF;                
		
    INSERT INTO exam (exam_name, status) VALUES (exam_name, status);
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Update Exam
CREATE OR REPLACE FUNCTION update_exam(
    id_exam_in BIGINT DEFAULT NULL,
    hashed_id_in VARCHAR(255) DEFAULT NULL,
    exam_name_in VARCHAR(255) DEFAULT NULL,
    status_in INT DEFAULT NULL
) RETURNS BOOLEAN AS $$
DECLARE
    exam_id BIGINT;
BEGIN


    IF hashed_id_in IS NULL AND id_exam_in IS NULL THEN
        RAISE EXCEPTION 'É necessário passar o id_exam ou o hashed_id';
    ELSEIF hashed_id_in IS NOT NULL AND id_exam_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não é possível passar o id_exam e o hashed_id';
    ELSEIF hashed_id_in IS NULL THEN
        SELECT id_exam INTO exam_id FROM exam WHERE id_exam = id_exam_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Exame com o id "%" não existe', id_exam_in; --EXAM NOT FOUND
        END IF;
    ELSEIF id_exam_in IS NULL THEN
        SELECT id_exam INTO exam_id FROM exam WHERE hashed_id = hashed_id_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Exame com o hashed_id "%" não existe', hashed_id_in; --EXAM NOT FOUND
        END IF;
    END IF;

    IF exam_name_in IS NOT NULL AND exam_name_in <> '' THEN
        IF EXISTS (SELECT * FROM exam WHERE exam_name = exam_name_in AND id_exam <> exam_id) THEN
            RAISE EXCEPTION 'Nome do exame já existe';
        END IF;
    END IF;

    UPDATE exam SET exam_name = exam_name_in WHERE id_exam = exam_id;
    
    IF status_in IS NOT NULL THEN
        UPDATE exam SET status = status_in WHERE id_exam = exam_id;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Set Hashed ID on New Rows
CREATE OR REPLACE FUNCTION set_exam_hashed_id_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE exam SET hashed_id = hash_id(NEW.id_exam) WHERE id_exam = NEW.id_exam;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Trigger to Set Hashed ID on New Rows
CREATE OR REPLACE TRIGGER set_exam_hashed_id_trigger
AFTER INSERT ON exam
FOR EACH ROW
EXECUTE PROCEDURE set_exam_hashed_id_function();
--
--
--
-- Get Exams
CREATE OR REPLACE FUNCTION get_exams(
    IN id_exam_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL,
    IN status_in INT DEFAULT 1
)
RETURNS TABLE (
    hashed_id VARCHAR(255),
    exam_name VARCHAR(255),
    status INT,
    created_at TIMESTAMP
) AS $$
BEGIN
    IF hashed_id_in IS NULL AND id_exam_in IS NULL THEN
        RETURN QUERY SELECT 
            e.hashed_id, e.exam_name, e.status, e.created_at
        FROM exam e 
        WHERE e.status = status_in;
    ELSEIF hashed_id_in IS NULL THEN
        RETURN QUERY SELECT 
            e.hashed_id, e.exam_name, e.status, e.created_at
        FROM exam e
        WHERE e.id_exam = id_exam_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Exame com o id "%" não existe', id_exam_in; --USER NOT FOUND
        END IF;
    ELSEIF id_exam_in IS NULL THEN
        RETURN QUERY SELECT 
            e.hashed_id, e.exam_name, e.status, e.created_at
        FROM exam e
        WHERE e.hashed_id = hashed_id_in;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Exame com o hashed_id "%" não existe', hashed_id_in; --USER NOT FOUND
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Change Exam Status
CREATE OR REPLACE FUNCTION change_exam_status(
    IN id_exam_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL,
    IN status_in INT DEFAULT 1
)
RETURNS BOOLEAN AS $$
DECLARE
    exam_id BIGINT;
BEGIN

    IF status_in <> 0 AND status_in <> 1 THEN
        RAISE EXCEPTION 'O status deve ser 0 ou 1';
    END IF;

    IF id_exam_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_exam. Ambos foram passados.';
    END IF;

    IF hashed_id_in IS NOT NULL THEN
        SELECT exam.id_exam INTO exam_id FROM exam WHERE hashed_id = hashed_id_in;
    ELSE
        exam_id := id_exam_in;
    END IF;

    IF exam_id IS NULL AND id_exam_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum exame com o id passado';
    ELSEIF exam_id IS NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum exame com o hashed_id passado';
    END IF;

   
    IF NOT EXISTS (SELECT exam.id_exam FROM exam WHERE exam.id_exam = exam_id AND exam.status = status_in) THEN
        UPDATE exam SET status = status_in WHERE id_exam = exam_id;
        RETURN TRUE;
    ELSE
        IF status_in = 0 THEN
            RAISE EXCEPTION 'O exame já está desativado';
        ELSE
            RAISE EXCEPTION 'O exame já está ativado';
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;