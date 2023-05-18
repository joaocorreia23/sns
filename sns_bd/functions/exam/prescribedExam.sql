--STATUS
-- 0 - Prescrito
-- 1 - Realizado
-- 2 - Cancelado
-- Insert Prescribed Exam
CREATE OR REPLACE FUNCTION create_prescribed_exam(
	id_appointment_in BIGINT DEFAULT NULL,
    hashed_id_appointment_in VARCHAR(255) DEFAULT NULL,
    id_exam_in BIGINT DEFAULT NULL,
    hashed_id_exam_in VARCHAR(255) DEFAULT NULL,
    requisition_date_in TIMESTAMP DEFAULT NULL,
	status INT DEFAULT 0,
    scheduled_date_in DATE DEFAULT NULL
) RETURNS BOOLEAN AS $$
DECLARE
    appointment_id BIGINT;
    exam_id BIGINT;
    expiration_date_out DATE;
BEGIN

    IF id_appointment_in IS NULL AND (hashed_id_appointment_in IS NULL OR hashed_id_appointment_in = '') THEN
        RAISE EXCEPTION 'É necessário passar o id_appointment ou o hashed_id_appointment';
    ELSEIF id_appointment_in IS NOT NULL AND (hashed_id_appointment_in IS NOT NULL OR hashed_id_appointment_in <> '') THEN
        RAISE EXCEPTION 'Não é possível passar o id_appointment e o hashed_id_appointment';
    ELSEIF id_appointment_in IS NULL THEN
        SELECT id_appointment INTO appointment_id FROM appointment WHERE hashed_id = hashed_id_appointment_in;	
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Consulta com o hashed_id "%" não existe', hashed_id_appointment_in; --appointment NOT FOUND
        END IF;
    ELSEIF hashed_id_appointment_in IS NULL OR hashed_id_appointment_in = '' THEN
        SELECT id_appointment INTO appointment_id FROM appointment WHERE id_appointment = id_appointment_in;	
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Consulta com o id "%" não existe', id_appointment_in; --appointment NOT FOUND
        END IF;
    END IF;

    IF id_exam_in IS NULL AND (hashed_id_exam_in IS NULL OR hashed_id_exam_in = '') THEN
        RAISE EXCEPTION 'É necessário passar o id_exam ou o hashed_id_exam';
    ELSEIF id_exam_in IS NOT NULL AND (hashed_id_exam_in IS NOT NULL OR hashed_id_exam_in <> '') THEN
        RAISE EXCEPTION 'Não é possível passar o id_exam e o hashed_id_exam';
    ELSEIF id_exam_in IS NULL THEN
        SELECT id_exam INTO exam_id FROM exam WHERE hashed_id = hashed_id_exam_in;	
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Exame com o hashed_id "%" não existe', hashed_id_exam_in; --exam NOT FOUND
        END IF;
    ELSEIF hashed_id_exam_in IS NULL OR hashed_id_exam_in = '' THEN
        SELECT id_exam INTO exam_id FROM exam WHERE id_exam = id_exam_in;	
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Exame com o id "%" não existe', id_exam_in; --exam NOT FOUND
        END IF;
    END IF;

    IF NOT EXISTS (SELECT * FROM appointment WHERE appointment.id_appointment = appointment_id AND appointment.status = 0) THEN
        RAISE EXCEPTION 'O Estado da consulta não permite a prescrição de exames';
    END IF;
    
    IF requisition_date_in IS NULL THEN
        requisition_date_in := NOW();
    END IF;

    expiration_date_out := requisition_date_in + INTERVAL '6 months';

    IF status IS NULL THEN
        status := 0;
    ELSEIF status <> 0 AND status <> 1 AND status <> 2 THEN
        RAISE EXCEPTION 'Estado inválido';
    END IF;

    INSERT INTO prescribed_exam (id_appointment, id_exam, requisition_date, status, scheduled_date, expiration_date) VALUES (appointment_id, exam_id, requisition_date_in, status, scheduled_date_in, expiration_date_out);
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Set Hashed ID on New Rows
CREATE OR REPLACE FUNCTION set_prescribed_exam_hashed_id_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE prescribed_exam SET hashed_id = hash_id(NEW.id_prescribed_exam) WHERE id_prescribed_exam = NEW.id_prescribed_exam;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Trigger to Set Hashed ID on New Rows
CREATE OR REPLACE TRIGGER set_prescribed_exam_hashed_id_trigger
AFTER INSERT ON prescribed_exam
FOR EACH ROW
EXECUTE PROCEDURE set_prescribed_exam_hashed_id_function();
--
--
--
--Get Prescribed Exam
CREATE OR REPLACE FUNCTION get_prescribed_exam(
    IN id_prescribed_exam_in BIGINT DEFAULT NULL,
    IN hashed_id_prescribed_exam_in VARCHAR(255) DEFAULT NULL,
    IN id_exam_in BIGINT DEFAULT NULL,
    IN hashed_id_exam_in VARCHAR(255) DEFAULT NULL,
    IN id_doctor_in BIGINT DEFAULT NULL,
    IN hashed_id_doctor_in VARCHAR(255) DEFAULT NULL,
    IN id_patient_in BIGINT DEFAULT NULL,
    IN hashed_id_patient_in VARCHAR(255) DEFAULT NULL,
    IN id_appointment_in BIGINT DEFAULT NULL,
    IN hashed_id_appointment_in VARCHAR(255) DEFAULT NULL,
    IN id_health_unit_in BIGINT DEFAULT NULL,
    IN hashed_id_health_unit_in VARCHAR(255) DEFAULT NULL,
    IN requisition_date_in DATE DEFAULT NULL,
    IN scheduled_date_in DATE DEFAULT NULL,
    IN expiration_date_in DATE DEFAULT NULL,
    IN status_in INT DEFAULT NULL
)
RETURNS TABLE (
    hashed_id_prescribed_exam VARCHAR(255),
    requisition_date DATE,
    expiration_date TIMESTAMP,
    sheduled_date DATE,
    prescribed_exam_status INT,
    hashed_id_exam VARCHAR(255),
    exam_name VARCHAR(255),
    exam_status INT,
    hashed_id_appointment VARCHAR(255),
    id VARCHAR(255),
    appointment_status INT,
    start_date VARCHAR(255),
    end_date VARCHAR(255),
    start_time TIME,
    end_time TIME,
    created_at TIMESTAMP,
    hashed_id_health_unit VARCHAR(255),
    health_unit_name VARCHAR(255),
    health_unit_email VARCHAR(255),
    health_unit_phone_number VARCHAR(255),
    health_unit_type health_unit_type,
    health_unit_tax_number INT,
    health_unit_address VARCHAR(255),
    health_unit_door_number VARCHAR(255),
    health_unit_floor VARCHAR(255),
    health_unit_zip_code VARCHAR(255),
    health_unit_county_name VARCHAR(255),
    health_unit_district_name VARCHAR(255),
    health_unit_country_name VARCHAR(255),
    health_unit_status INT,
    hashed_id_doctor VARCHAR(255),
    doctor_username VARCHAR(255),
    doctor_email VARCHAR(255),
    doctor_first_name VARCHAR(255),
    doctor_last_name VARCHAR(255),
    doctor_birth_date DATE,
    doctor_gender gender,
    doctor_tax_number INT,
    doctor_phone_number VARCHAR(255),
    doctor_address VARCHAR(255),
    doctor_door_number VARCHAR(255),
    doctor_floor VARCHAR(255),
    doctor_zip_code VARCHAR(255),
    doctor_county_name VARCHAR(255),
    doctor_district_name VARCHAR(255),
    doctor_country_name VARCHAR(255),
    doctor_status INT,
    hashed_id_patient VARCHAR(255),
    patient_username VARCHAR(255),
    patient_email VARCHAR(255),
    patient_first_name VARCHAR(255),
    patient_last_name VARCHAR(255),
    patient_birth_date DATE,
    patient_gender gender,
    patient_tax_number INT,
    patient_phone_number VARCHAR(255),
    patient_address VARCHAR(255),
    patient_door_number VARCHAR(255),
    patient_floor VARCHAR(255),
    patient_zip_code VARCHAR(255),
    patient_county_name VARCHAR(255),
    patient_district_name VARCHAR(255),
    patient_country_name VARCHAR(255),
    patient_status INT
) AS $$
DECLARE
    exam_id BIGINT DEFAULT NULL;
    prescribed_exam_id BIGINT DEFAULT NULL;
    appointment_id BIGINT DEFAULT NULL;
    health_unit_id BIGINT DEFAULT NULL;
    doctor_id BIGINT DEFAULT NULL;
    patient_id BIGINT DEFAULT NULL;
    query TEXT;
    first_condition BOOLEAN DEFAULT TRUE;
BEGIN

    IF id_prescribed_exam_in IS NOT NULL AND hashed_id_prescribed_exam_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_prescribed_exam. Ambos foram passados.';
    END IF;

    IF id_exam_in IS NOT NULL AND hashed_id_exam_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_exam. Ambos foram passados.';
    END IF;

    IF id_appointment_in IS NOT NULL AND hashed_id_appointment_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_appointment. Ambos foram passados.';
    END IF;

    IF id_health_unit_in IS NOT NULL AND hashed_id_health_unit_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_health_unit. Ambos foram passados.';
    END IF;

    IF id_doctor_in IS NOT NULL AND hashed_id_doctor_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_doctor. Ambos foram passados.';
    END IF;

    IF id_patient_in IS NOT NULL AND hashed_id_patient_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_patient. Ambos foram passados.';
    END IF;

    query := '
        SELECT 
        pe.hashed_id as hashed_id_prescribed_exam,
        pe.requisition_date as requisition_date,
        pe.expiration_date as expiration_date,
        pe.scheduled_date as sheduled_date,
        e.hashed_id as hashed_id_exam,
        e.exam_name as exam_name,
        e.status as exam_status,
        a.hashed_id as hashed_id_appointment,
        a.hashed_id as id,
        a.status as appointment_status,
		(a.start_date || ''T'' || a.start_time)::VARCHAR(255) as start_date,
        (a.start_date || ''T'' || a.end_time)::VARCHAR(255) as end_date,
        a.start_time as start_time,
        a.end_time as end_time,
        a.created_at as created_at,
        hu.hashed_id as hashed_id_health_unit,
        hu.name as health_unit_name,
        hu.email as health_unit_email,
        hu.phone_number as health_unit_phone_number,
        hu.type as health_unit_type,
        hu.tax_number as health_unit_tax_number,
        hu_zc.address as health_unit_address,
        hu_a.door_number as health_unit_door_number,
        hu_a.floor as health_unit_floor,
        hu_zc.zip_code as health_unit_zip_code,
        hu_c.county_name as health_unit_county_name,
        hu_d.district_name as health_unit_district_name,
        hu_ct.country_name as health_unit_country_name,
        hu.status as health_unit_status,
        u_doctor.hashed_id as hashed_id_doctor,
        u_doctor.username as doctor_username,
        u_doctor.email as doctor_email,
        ui_doctor.first_name as doctor_first_name,
        ui_doctor.last_name as doctor_last_name,
        ui_doctor.birth_date as doctor_birth_date,
        ui_doctor.gender as doctor_gender,
        ui_doctor.tax_number as doctor_tax_number,
        ui_doctor.phone_number as doctor_phone_number,
        u_doctor_zc.address as doctor_address,
        u_doctor_a.door_number as doctor_door_number,
        u_doctor_a.floor as doctor_floor,
        u_doctor_zc.zip_code as doctor_zip_code,
        u_doctor_c.county_name as doctor_county_name,
        u_doctor_d.district_name as doctor_district_name,
        u_doctor_ct.country_name as doctor_country_name,
        u_doctor.status as doctor_status,
        u_patient.hashed_id as hashed_id_patient,
        u_patient.username as patient_username,
        u_patient.email as patient_email,
        ui_patient.first_name as patient_first_name,
        ui_patient.last_name as patient_last_name,
        ui_patient.birth_date as patient_birth_date,
        ui_patient.gender as patient_gender,
        ui_patient.tax_number as patient_tax_number,
        ui_patient.phone_number as patient_phone_number,
        u_patient_zc.address as patient_address,
        u_patient_a.door_number as patient_door_number,
        u_patient_a.floor as patient_floor,
        u_patient_zc.zip_code as patient_zip_code,
        u_patient_c.county_name as patient_county_name,
        u_patient_d.district_name as patient_district_name,
        u_patient_ct.country_name as patient_country_name,
        u_patient.status as patient_status
        FROM prescribed_exam pe
        INNER JOIN exam e ON e.id_exam = pe.id_exam
        INNER JOIN appointment a ON a.id_appointment = pe.id_appointment
        INNER JOIN health_unit hu ON hu.id_health_unit = a.id_health_unit
        LEFT JOIN address hu_a ON hu_a.id_address = hu.id_address
        LEFT JOIN zip_code hu_zc ON hu_zc.id_zip_code = hu_a.id_zip_code
        LEFT JOIN county hu_c ON hu_c.id_county = hu_zc.id_county
        LEFT JOIN district hu_d ON hu_d.id_district = hu_c.id_district
        LEFT JOIN country hu_ct ON hu_ct.id_country = hu_d.id_country
        INNER JOIN users u_doctor ON u_doctor.id_user = a.id_user_doctor
        LEFT JOIN user_info ui_doctor ON ui_doctor.id_user = u_doctor.id_user
        LEFT JOIN address u_doctor_a ON u_doctor_a.id_address = ui_doctor.id_address
        LEFT JOIN zip_code u_doctor_zc ON u_doctor_zc.id_zip_code = u_doctor_a.id_zip_code
        LEFT JOIN county u_doctor_c ON u_doctor_c.id_county = u_doctor_zc.id_county
        LEFT JOIN district u_doctor_d ON u_doctor_d.id_district = u_doctor_c.id_district
        LEFT JOIN country u_doctor_ct ON u_doctor_ct.id_country = u_doctor_d.id_country
        INNER JOIN users u_patient ON u_patient.id_user = a.id_user_patient
        LEFT JOIN user_info ui_patient ON ui_patient.id_user = u_patient.id_user
        LEFT JOIN address u_patient_a ON u_patient_a.id_address = ui_patient.id_address
        LEFT JOIN zip_code u_patient_zc ON u_patient_zc.id_zip_code = u_patient_a.id_zip_code
        LEFT JOIN county u_patient_c ON u_patient_c.id_county = u_patient_zc.id_county
        LEFT JOIN district u_patient_d ON u_patient_d.id_district = u_patient_c.id_district
        LEFT JOIN country u_patient_ct ON u_patient_ct.id_country = u_patient_d.id_country
    ';

    

    IF id_prescribed_exam_in IS NOT NULL THEN
        prescribed_exam_id := id_prescribed_exam_in;
        SELECT id_prescribed_exam INTO prescribed_exam_id FROM prescribed_exam WHERE id_prescribed_exam = id_prescribed_exam_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe exame prescrito com o id passado.';
        END IF;
    ELSIF hashed_id_prescribed_exam_in IS NOT NULL AND hashed_id_prescribed_exam_in != '' THEN
        SELECT id_prescribed_exam INTO prescribed_exam_id FROM prescribed_exam WHERE hashed_id = hashed_id_prescribed_exam_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe exame prescrito com o hashed_id passado.';
        END IF;
    END IF;

    IF id_exam_in IS NOT NULL THEN
        exam_id := id_exam_in;
        SELECT id_exam INTO exam_id FROM exam WHERE id_exam = id_exam_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe exame com o id passado.';
        END IF;
    ELSIF hashed_id_exam_in IS NOT NULL AND hashed_id_exam_in != '' THEN
        SELECT id_exam INTO exam_id FROM exam WHERE hashed_id = hashed_id_exam_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe exame com o hashed_id passado.';
        END IF;
    END IF;

    IF id_appointment_in IS NOT NULL THEN
        appointment_id := id_appointment_in;
        SELECT id_appointment INTO appointment_id FROM appointment WHERE id_appointment = id_appointment_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe consulta com o id passado.';
        END IF;
    ELSIF hashed_id_appointment_in IS NOT NULL AND hashed_id_appointment_in != '' THEN
        SELECT id_appointment INTO appointment_id FROM appointment WHERE hashed_id = hashed_id_appointment_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe consulta com o hashed_id passado.';
        END IF;
    END IF;

    IF id_health_unit_in IS NOT NULL THEN
        health_unit_id := id_health_unit_in;
        SELECT id_health_unit INTO health_unit_id FROM health_unit WHERE id_health_unit = id_health_unit_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe unidade de saúde com o id passado.';
        END IF;
    ELSIF hashed_id_health_unit_in IS NOT NULL AND hashed_id_health_unit_in != '' THEN
        SELECT id_health_unit INTO health_unit_id FROM health_unit WHERE hashed_id = hashed_id_health_unit_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe unidade de saúde com o hashed_id passado.';
        END IF;
    END IF;

    IF id_doctor_in IS NOT NULL THEN
        doctor_id := id_doctor_in;
        SELECT id_user INTO doctor_id FROM users WHERE id_user = id_doctor_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe médico com o id passado.';
        END IF;
    ELSIF hashed_id_doctor_in IS NOT NULL AND hashed_id_doctor_in != '' THEN
        SELECT id_user INTO doctor_id FROM users WHERE hashed_id = hashed_id_doctor_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe médico com o hashed_id passado.';
        END IF;
    END IF;

    IF id_patient_in IS NOT NULL THEN
        patient_id := id_patient_in;
        SELECT id_user INTO patient_id FROM users WHERE id_user = id_patient_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe paciente com o id passado.';
        END IF;
    ELSIF hashed_id_patient_in IS NOT NULL AND hashed_id_patient_in != '' THEN
        SELECT id_user INTO patient_id FROM users WHERE hashed_id = hashed_id_patient_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe paciente com o hashed_id passado.';
        END IF;
    END IF;

    IF exam_id IS NOT NULL OR prescribed_exam_id IS NOT NULL OR appointment_id IS NOT NULL OR health_unit_id IS NOT NULL OR doctor_id IS NOT NULL OR patient_id IS NOT NULL OR requisition_date_in IS NOT NULL OR scheduled_date_in IS NOT NULL OR expiration_date_in IS NOT NULL OR status_in IS NOT NULL THEN
        query := query || ' WHERE ';
    END IF;

    IF exam_id IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'pe.id_exam = ' || quote_literal(exam_id);
    END IF;

    IF prescribed_exam_id IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'pe.id_prescribed_exam = ' || quote_literal(prescribed_exam_id);
    END IF;

    IF appointment_id IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'a.id_appointment = ' || quote_literal(appointment_id);
    END IF;

    IF health_unit_id IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'a.id_health_unit = ' || quote_literal(health_unit_id);
    END IF;

    IF doctor_id IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'a.id_user_doctor = ' || quote_literal(doctor_id);
    END IF;

    IF patient_id IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'a.id_user_patient = ' || quote_literal(patient_id);
    END IF;

    IF requisition_date_in IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'pe.requisition_date = ' || quote_literal(requisition_date_in);
    END IF;

    IF scheduled_date_in IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'pe.sheduled_date = ' || quote_literal(scheduled_date_in);
    END IF;

    IF expiration_date_in IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'pe.expiration_date = ' || quote_literal(expiration_date_in);
    END IF;

    IF status_in IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'pe.status = ' || quote_literal(status_in);
    END IF;

    query := query || ' ORDER BY pe.requisition_date DESC';
    RETURN QUERY EXECUTE query;
END;
$$ LANGUAGE plpgsql; 
--
--
--
-- Shedule Exam
CREATE OR REPLACE FUNCTION schedule_exam(
    id_prescribed_exam_in BIGINT DEFAULT NULL,
    hashed_id_prescribed_exam_in VARCHAR(255) DEFAULT NULL,
    scheduled_date_in TIMESTAMP DEFAULT NULL
) RETURNS BOOLEAN AS $$
DECLARE
    prescribed_exam_id BIGINT;
BEGIN
    IF id_prescribed_exam_in IS NOT NULL AND hashed_id_prescribed_exam_in IS NOT NULL AND hashed_id_prescribed_exam_in != '' THEN
        RAISE EXCEPTION 'Não é possível passar o id e o hashed_id ao mesmo tempo.';
    END IF;

    IF scheduled_date_in IS NULL THEN
        RAISE EXCEPTION 'É necessário passar a data de agendamento do exame.';
    END IF;

    IF id_prescribed_exam_in IS NOT NULL THEN
        prescribed_exam_id := id_prescribed_exam_in;
        SELECT id_prescribed_exam INTO prescribed_exam_id FROM prescribed_exam WHERE id_prescribed_exam = id_prescribed_exam_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe exame prescrito com o id passado.';
        END IF;
    ELSIF hashed_id_prescribed_exam_in IS NOT NULL AND hashed_id_prescribed_exam_in != '' THEN
        SELECT id_prescribed_exam INTO prescribed_exam_id FROM prescribed_exam WHERE hashed_id = hashed_id_prescribed_exam_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe exame prescrito com o hashed_id passado.';
        END IF;
    END IF;

    UPDATE prescribed_exam SET scheduled_date = scheduled_date_in, status=1 WHERE id_prescribed_exam = prescribed_exam_id;
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Change Status
CREATE OR REPLACE FUNCTION change_prescribed_exam_status(
    IN id_prescribed_exam_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL,
    IN status_in INT DEFAULT 1
)
RETURNS BOOLEAN AS $$
DECLARE
    prescribed_exam_id BIGINT;
BEGIN

    IF status_in <> 0 AND status_in <> 1 AND status_in <> 2 THEN
        RAISE EXCEPTION 'O status deve ser 0 ou 1 ou 2.';
    END IF;

    IF id_prescribed_exam_in IS NOT NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_prescribed_exam.';
    END IF;

    IF hashed_id_in IS NOT NULL THEN
        SELECT id_prescribed_exam INTO prescribed_exam_id FROM prescribed_exam WHERE hashed_id = hashed_id_in;
    ELSE
        prescribed_exam_id := id_prescribed_exam_in;
    END IF;

    IF prescribed_exam_id IS NULL AND id_prescribed_exam_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum exame prescrito com o id passado';
    ELSEIF prescribed_exam_id IS NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum exame prescrito com o hashed_id passado';
    END IF;

   
    IF NOT EXISTS (SELECT * FROM prescribed_exam WHERE id_prescribed_exam = prescribed_exam_id AND status = status_in) THEN
        UPDATE prescribed_exam SET status = status_in WHERE id_prescribed_exam = prescribed_exam_id;
        RETURN TRUE;
    ELSE
        IF status_in = 0 THEN
            RAISE EXCEPTION 'O exame já está Pendente';
        ELSEIF status_in = 1 THEN
            RAISE EXCEPTION 'O exame já está Agendado';
        ELSEIF status_in = 2 THEN
            RAISE EXCEPTION 'O exame já está Realizado';
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;







