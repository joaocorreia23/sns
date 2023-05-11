-- Create Appointment
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
        RAISE EXCEPTION 'É necessário passar a hora de inicio da consulta.';
    END IF;

    IF end_time_in IS NULL THEN
        RAISE EXCEPTION 'É necessário passar a hora de fim da consulta.';
    END IF;

    IF start_time_in >= end_time_in THEN
        RAISE EXCEPTION 'A hora de início da consulta tem de ser menor que a hora de fim da consulta.';
    END IF;

    IF start_date_in < CURRENT_DATE AND status = 0 THEN
        RAISE EXCEPTION 'Não é possível criar uma consulta pendente com uma data anterior à data atual.';
    END IF;
    
    INSERT INTO appointment (id_health_unit, id_user_doctor, id_user_patient, status, start_date, start_time, end_time) VALUES (health_unit_id, doctor_id, patient_id, status, start_date_in, start_time_in, end_time_in);
	RETURN TRUE;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Set Hashed ID on New Rows
CREATE OR REPLACE FUNCTION set_appointment_hashed_id_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE appointment SET hashed_id = hash_id(NEW.id_appointment) WHERE id_appointment = NEW.id_appointment;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Trigger to Set Hashed ID on New Rows
CREATE OR REPLACE TRIGGER set_appointment_hashed_id_trigger
AFTER INSERT ON appointment
FOR EACH ROW
EXECUTE PROCEDURE set_appointment_hashed_id_function();
--
--
--
-- Get Appointments
CREATE OR REPLACE FUNCTION get_appointments(
    id_health_unit_in BIGINT DEFAULT NULL,
    hashed_id_health_unit_in VARCHAR(255) DEFAULT NULL,
    id_doctor_in BIGINT DEFAULT NULL,
    hashed_id_doctor_in VARCHAR(255) DEFAULT NULL,
    id_patient_in BIGINT DEFAULT NULL,
    hashed_id_patient_in VARCHAR(255) DEFAULT NULL,
    start_date_in DATE DEFAULT NULL,
    end_date_in DATE DEFAULT NULL,
    status_in INT DEFAULT 1
) RETURNS TABLE (
    hashed_id_appointment BIGINT,
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
    hashed_id_patient VARCHAR(255),
    status INT,
    start_date DATE,
    start_time TIME,
    end_time TIME
) AS $$
DECLARE
    health_unit_id BIGINT;
    doctor_id BIGINT;
    patient_id BIGINT;
    query TEXT;
BEGIN
    IF id_health_unit_in IS NOT NULL AND hashed_id_health_unit_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_health_unit. Ambos foram passados.';
    END IF;

    IF id_doctor_in IS NOT NULL AND hashed_id_doctor_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_doctor. Ambos foram passados.';
    END IF;

    IF id_patient_in IS NOT NULL AND hashed_id_patient_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_patient. Ambos foram passados.';
    END IF;

    query := "SELECT 

        a.hashed_id as hashed_id_appointment, 
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
        ui_doctor.first_name || ' ' || ui_doctor.last_name as doctor_name,
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
        ui_patient.first_name || ' ' || ui_patient.last_name as patient_name,
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

        FROM appointment a
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
        LEFT JOIN country u_patient_ct ON u_patient_ct.id_country = u_patient_d.id_country";


        
       


        


    

   

    