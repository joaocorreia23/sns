
-----------------------------------------
-------START INSERT PRECRIBED EXAM-------
-----------------------------------------
CREATE OR REPLACE FUNCTION insert_prescribed_exam(
    hashed_id VARCHAR(255),
    requisition_date VARCHAR(255),
    expiration_date VARCHAR(255),
    id_appointment BIGINT,
    id_exam BIGINT,
    status INT,
    id_user_doctor BIGINT,
    id_user_patient BIGINT,
	created_at VARCHAR(255)
) RETURNS BOOLEAN AS $$
BEGIN

	IF(hashed_id IS NULL OR hashed_id=='') THEN
		RAISE EXCEPTION 'Hashed_Id esta nulo ou vazio';
		RETURN FALSE;
	END IF;
	
	IF(requisition_date IS NULL OR requisition_date=='') THEN
		RAISE EXCEPTION 'Data de Requisição do exame nula ou vazia';
		RETURN FALSE;
	END IF;
	
	IF(expiration_date IS NULL OR expiration_date=='') THEN
		RAISE EXCEPTION 'Data de expiração do exame nula ou vazia';
		RETURN FALSE;
	END IF;
	
	IF(id_appointment IS NULL OR id_appointment=='') THEN
		RAISE EXCEPTION 'Data de expiração do exame nula ou vazia';
		RETURN FALSE;
	END IF;
	
	IF(id_exam IS NULL OR id_exam=='') THEN
		RAISE EXCEPTION 'ID do exame nulo ou vazio';
		RETURN FALSE;
	END IF;
	
	IF(id_user_doctor IS NULL OR id_user_doctor=='') THEN
		RAISE EXCEPTION 'ID do Doutor nulo ou vazio';
		RETURN FALSE;
	END IF;
	
	IF(id_user_patient IS NULL OR id_user_patient=='') THEN
		RAISE EXCEPTION 'ID do Doente nulo ou vazio';
		RETURN FALSE;
	END IF;
	
	IF(created_at IS NULL OR created_at=='') THEN
		RAISE EXCEPTION 'Data de criação do exame nula ou vazia';
		RETURN FALSE;
	END IF;
	
	IF NOT EXISTS (SELECT 1 FROM exam WHERE id_exam = id_exam) THEN
    	RAISE EXCEPTION 'Exame não encontrado';
    RETURN FALSE;
	END IF;
	
	
	IF NOT EXISTS (SELECT 1 FROM patient WHERE id_patient = user_patient_id) THEN
    	RAISE EXCEPTION 'Paciente não encontrado';
    RETURN FALSE;
	END IF;
	
	IF NOT EXISTS (SELECT 1 FROM doctor WHERE id_doctor = user_doctor_id) THEN
    	RAISE EXCEPTION 'Doctor não encontrado';
    RETURN FALSE;
	END IF;
	
    INSERT INTO prescribed_exam (
        hashed_id,
        requisition_date,
        expiration_date,
        id_appointment,
        id_exam,
        status,
        id_user_doctor,
        id_user_patient,
		created_at
    ) VALUES (
 		hashed_id,
        CAST(requisition_date AS TIMESTAMP),
        CAST(expiration_date AS TIMESTAMP),
        id_appointment,
        id_exam,
        status,
        id_user_doctor,
        id_user_patient,
		CAST(created_at AS TIMESTAMP),
    );
END;
$$ LANGUAGE plpgsql;

-----------------------------------------
--------END INSERT PRECRIBED EXAM--------
-----------------------------------------


-----------------------------------------
---------START LIST PRECRIBED EXAM---------
-----------------------------------------

CREATE OR REPLACE FUNCTION list_prescribed_exam() 
RETURNS TABLE (
    id_prescribed_exam BIGINT,
    hashed_id VARCHAR(255),
    requisition_date TIMESTAMP,
    expiration_date TIMESTAMP,
    id_appointment BIGINT,
    id_exam BIGINT,
    status INT,
    id_user_doctor BIGINT,
    id_user_patient BIGINT,
    created_at TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY SELECT * FROM prescribed_exam;
END;
$$ LANGUAGE plpgsql;


-----------------------------------------
---------END LIST PRECRIBED EXAM---------
-----------------------------------------


-----------------------------------------
---START LIST PRECRIBED EXAM BY PATIENT--
-----------------------------------------

CREATE OR REPLACE FUNCTION list_prescribed_exam_by_user_patient(
	user_patient_id BIGINT
) 
RETURNS TABLE (
    id_prescribed_exam BIGINT,
    hashed_id VARCHAR(255),
    requisition_date TIMESTAMP,
    expiration_date TIMESTAMP,
    id_appointment BIGINT,
    id_exam BIGINT,
    status INT,
    id_user_doctor BIGINT,
    id_user_patient BIGINT,
    created_at TIMESTAMP
) AS $$
BEGIN

	IF(user_patient_id IS NULL OR user_patient_id = '') THEN
		RAISE EXCEPTION 'Paciente ID está nulo ou vazio.';
		RETURN;
	END IF;
	
	IF NOT EXISTS (SELECT 1 FROM patient WHERE id_patient = user_patient_id) THEN
    	RAISE EXCEPTION 'Paciente não encontrado';
    RETURN;
	END IF;

    RETURN QUERY SELECT * FROM prescribed_exam WHERE id_user_patient = user_patient_id;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------
---END LIST PRECRIBED EXAM BY PATIENT--
-----------------------------------------




-----------------------------------------
---START LIST PRECRIBED EXAM BY DOCTOR--
-----------------------------------------

CREATE OR REPLACE FUNCTION list_prescribed_exam_by_user_doctor(
	user_doctor_id BIGINT
) 
RETURNS TABLE (
    id_prescribed_exam BIGINT,
    hashed_id VARCHAR(255),
    requisition_date TIMESTAMP,
    expiration_date TIMESTAMP,
    id_appointment BIGINT,
    id_exam BIGINT,
    status INT,
    id_user_doctor BIGINT,
    id_user_patient BIGINT,
    created_at TIMESTAMP
) AS $$
BEGIN
	
	IF(user_doctor_id IS NULL OR user_doctor_id = '') THEN
		RAISE EXCEPTION 'Doctor ID está nulo ou vazio.';
	RETURN FALSE;
	END IF;
	
	IF NOT EXISTS (SELECT 1 FROM doctor WHERE id_doctor = user_doctor_id) THEN
    	RAISE EXCEPTION 'Doctor não encontrado';
    RETURN FALSE;
	END IF;
	
    RETURN QUERY SELECT * FROM prescribed_exam WHERE id_user_doctor = user_doctor_id;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------
---END LIST PRECRIBED EXAM BY DOCTOR--
-----------------------------------------





-----------------------------------------
--START DELETE PRECRIBED EXAM BY PACIENT-
-----------------------------------------

CREATE OR REPLACE FUNCTION delete_prescribed_exam_by_user_patient(
	user_patient_id BIGINT
) 
RETURNS BOOLEAN AS $$
BEGIN
	IF(user_patient_id IS NULL OR user_patient_id = '') THEN
		RAISE EXCEPTION 'Paciente ID está nulo ou vazio.';
		RETURN FALSE;
	END IF;
	
	IF NOT EXISTS (SELECT 1 FROM patient WHERE id_patient = user_patient_id) THEN
    	RAISE EXCEPTION 'Paciente não encontrado';
    RETURN FALSE;
	END IF;
	
	DELETE FROM prescribed_exam WHERE id_user_patient = user_patient_id;
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------
--END DELETE PRECRIBED EXAM BY PACIENT--
-----------------------------------------


-----------------------------------------
--START DELETE PRECRIBED EXAM BY DOCTOR--
-----------------------------------------

CREATE OR REPLACE FUNCTION delete_prescribed_exam_by_user_doctor(
	user_doctor_id BIGINT
) 
RETURNS RETURNS BOOLEAN AS $$
 AS $$
BEGIN
	IF(user_doctor_id IS NULL OR user_doctor_id = '') THEN
		RAISE EXCEPTION 'Doctor ID está nulo ou vazio.';
	RETURN FALSE;
	END IF;
	
	IF NOT EXISTS (SELECT 1 FROM doctor WHERE id_doctor = user_doctor_id) THEN
    	RAISE EXCEPTION 'Doctor não encontrado';
    RETURN FALSE;
	END IF;
	
	DELETE FROM prescribed_exam WHERE id_user_doctor = user_doctor_id;
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-----------------------------------------
--END DELETE PRECRIBED EXAM BY DOCTOR--
-----------------------------------------





-----------------------------------------
-------START UPDATE PRECRIBED EXAM-------
-----------------------------------------


CREATE OR REPLACE FUNCTION update_prescribed_exam(
    id_prescribed_exam BIGINT,
    hashed_id VARCHAR(255),
    requisition_date VARCHAR(255),
    expiration_date VARCHAR(255),
    id_appointment BIGINT,
    id_exam BIGINT,
    status INT,
    id_user_doctor BIGINT,
    id_user_patient BIGINT,
	created_at VARCHAR(255)
) RETURNS BOOLEAN AS $$
BEGIN

	IF(id_prescribed_exam IS NULL OR id_prescribed_exam='') THEN
		RAISE EXCEPTION 'ID do exame prescrito nulo ou vazio';
		RETURN FALSE;
	END IF;

	IF(hashed_id IS NULL OR hashed_id=='') THEN
		RAISE EXCEPTION 'Hashed_Id esta nulo ou vazio';
		RETURN FALSE;
	END IF;
	
	IF(requisition_date IS NULL OR requisition_date=='') THEN
		RAISE EXCEPTION 'Data de Requisição do exame nula ou vazia';
		RETURN FALSE;
	END IF;
	
	IF(expiration_date IS NULL OR expiration_date=='') THEN
		RAISE EXCEPTION 'Data de expiração do exame nula ou vazia';
		RETURN FALSE;
	END IF;
	
	IF(id_appointment IS NULL OR id_appointment=='') THEN
		RAISE EXCEPTION 'Data de expiração do exame nula ou vazia';
		RETURN FALSE;
	END IF;
	
	IF(id_exam IS NULL OR id_exam=='') THEN
		RAISE EXCEPTION 'ID do exame nulo ou vazio';
		RETURN FALSE;
	END IF;
	
	IF(id_user_doctor IS NULL OR id_user_doctor=='') THEN
		RAISE EXCEPTION 'ID do Doutor nulo ou vazio';
		RETURN FALSE;
	END IF;
	
	IF(id_user_patient IS NULL OR id_user_patient=='') THEN
		RAISE EXCEPTION 'ID do Doente nulo ou vazio';
		RETURN FALSE;
	END IF;
	
	IF(created_at IS NULL OR created_at=='') THEN
		RAISE EXCEPTION 'Data de criação do exame nula ou vazia';
		RETURN FALSE;
	END IF;
	
	IF NOT EXISTS (SELECT 1 FROM exam WHERE id_exam = id_exam) THEN
    	RAISE EXCEPTION 'Exame não encontrado';
    RETURN FALSE;
	END IF;
	
	
	IF NOT EXISTS (SELECT 1 FROM patient WHERE id_user = id_user_patient) THEN
    	RAISE EXCEPTION 'Paciente não encontrado';
    RETURN FALSE;
	END IF;
	
	IF NOT EXISTS (SELECT 1 FROM doctor WHERE id_user = id_user_doctor) THEN
    	RAISE EXCEPTION 'Doctor não encontrado';
    RETURN FALSE;
	END IF;
	
	
    UPDATE prescribed_exam SET
        hashed_id = hashed_id,
        requisition_date = CAST(requisition_date AS TIMESTAMP),
        expiration_date = CAST(expiration_date AS TIMESTAMP),
        id_appointment = id_appointment,
        id_exam = id_exam,
        status = status,
        id_user_doctor = id_user_doctor,
        id_user_patient = id_user_patient,
        created_at = CAST(created_at AS TIMESTAMP),
    WHERE
        id_prescribed_exam = id_prescribed_exam;
        
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;


-----------------------------------------
-------END UPDATE PRECRIBED EXAM-------
-----------------------------------------







