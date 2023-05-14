-- STATUS
-- 0 - Not Administered
-- 1 - Administered
-- 2 - Not Administered - Canceled

--Insert Administered Vaccine
CREATE OR REPLACE FUNCTION create_administered_vaccine(

    id_vaccine_in BIGINT DEFAULT NULL,
    hashed_id_vaccine_in VARCHAR(255) DEFAULT NULL,

    id_doctor_in BIGINT DEFAULT NULL,
    hashed_id_doctor_in VARCHAR(255) DEFAULT NULL,

    id_patient_in BIGINT DEFAULT NULL,
    hashed_id_patient_in VARCHAR(255) DEFAULT NULL,

	id_appointment_in BIGINT DEFAULT NULL,
    hashed_id_appointment_in VARCHAR(255) DEFAULT NULL,

    administered_date_in TIMESTAMP DEFAULT NULL,
    dosage_in FLOAT DEFAULT NULL,
	status INT DEFAULT 0,
    due_date_in DATE DEFAULT NULL
) RETURNS BOOLEAN AS $$
DECLARE
    vaccine_id BIGINT;
    doctor_id BIGINT;
    patient_id BIGINT;
    appointment_id BIGINT;
BEGIN

    IF id_vaccine_in IS NULL AND (hashed_id_vaccine_in IS NULL OR hashed_id_vaccine_in = '') THEN
        RAISE EXCEPTION 'É necessário passar o id_vaccine ou o hashed_id_vaccine';
    ELSEIF id_vaccine_in IS NOT NULL AND (hashed_id_vaccine_in IS NOT NULL OR hashed_id_vaccine_in <> '') THEN
        RAISE EXCEPTION 'Não é possível passar o id_vaccine e o hashed_id_vaccine';
    ELSEIF id_vaccine_in IS NULL THEN
        SELECT id_vaccine INTO vaccine_id FROM vaccine v WHERE v.hashed_id = hashed_id_vaccine_in AND v. status = 1;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Vacina com o hashed_id "%" não existe', hashed_id_vaccine_in; --vaccine NOT FOUND
        ELSE 
            IF EXISTS (SELECT id_vaccine FROM vaccine v WHERE v.hashed_id = hashed_id_vaccine_in AND v.status = 0) THEN
                RAISE EXCEPTION 'Vacina com o hashed_id "%" não Permite Vacinar', hashed_id_vaccine_in; --vaccine NOT ACTIVE
            END IF;
        END IF;
    ELSEIF hashed_id_vaccine_in IS NULL OR hashed_id_vaccine_in = '' THEN
        SELECT id_vaccine INTO vaccine_id FROM vaccine v WHERE v.id_vaccine = id_vaccine_in AND v.status = 1;	
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Vacina com o id "%" não existe', id_vaccine_in; --vaccine NOT FOUND
        ELSE
            IF EXISTS (SELECT id_vaccine FROM vaccine v WHERE v.id_vaccine = id_vaccine_in AND v.status = 0) THEN
                RAISE EXCEPTION 'Vacina com o id "%" não Permite Vacinar', id_vaccine_in; --vaccine NOT ACTIVE
            END IF;
        END IF;
    END IF;

    IF id_doctor_in IS NULL AND (hashed_id_doctor_in IS NULL OR hashed_id_doctor_in = '') THEN
        RAISE EXCEPTION 'É necessário passar o id_doctor ou o hashed_id_doctor';
    ELSEIF id_doctor_in IS NOT NULL AND (hashed_id_doctor_in IS NOT NULL OR hashed_id_doctor_in <> '') THEN
        RAISE EXCEPTION 'Não é possível passar o id_doctor e o hashed_id_doctor';
    ELSEIF id_doctor_in IS NULL THEN
        SELECT id_user INTO doctor_id FROM users WHERE hashed_id = hashed_id_doctor_in;	
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Médico com o hashed_id "%" não existe', hashed_id_doctor_in; --doctor NOT FOUND
        END IF;
    ELSEIF hashed_id_doctor_in IS NULL OR hashed_id_doctor_in = '' THEN
        SELECT id_user INTO doctor_id FROM users WHERE id_user = id_doctor_in;	
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Médico com o id "%" não existe', id_doctor_in; --doctor NOT FOUND
        END IF;
    END IF;

    IF id_patient_in IS NULL AND (hashed_id_patient_in IS NULL OR hashed_id_patient_in = '') THEN
        RAISE EXCEPTION 'É necessário passar o id_patient ou o hashed_id_patient';
    ELSEIF id_patient_in IS NOT NULL AND (hashed_id_patient_in IS NOT NULL OR hashed_id_patient_in <> '') THEN
        RAISE EXCEPTION 'Não é possível passar o id_patient e o hashed_id_patient';
    ELSEIF id_patient_in IS NULL THEN
        SELECT id_user INTO patient_id FROM users WHERE hashed_id = hashed_id_patient_in;	
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Utente com o hashed_id "%" não existe', hashed_id_patient_in; --patient NOT FOUND
        END IF;
    ELSEIF hashed_id_patient_in IS NULL OR hashed_id_patient_in = '' THEN
        SELECT id_user INTO patient_id FROM users WHERE id_user = id_patient_in;	
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Utente com o id "%" não existe', id_patient_in; --patient NOT FOUND
        END IF;
    END IF;

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

    IF doctor_id = patient_id THEN
        RAISE EXCEPTION 'O médico não pode ser o mesmo que o utente.';
    END IF;

    IF dosage_in IS NULL THEN
        RAISE EXCEPTION 'É necessário passar a dosagem.';
    ELSIF dosage_in <= 0 THEN
        RAISE EXCEPTION 'A dosagem deve ser maior que 0.';
    END IF;

    IF status IS NULL THEN
        status := 0;
    --ALOWED STATUS
    ELSIF status <> 0 AND status <> 1 AND status <> 2 THEN
        RAISE EXCEPTION 'O status deve ser 0, 1 ou 2.';
    END IF;

    IF due_date_in IS NULL THEN
        RAISE EXCEPTION 'É necessário passar a Data de nova Vacinação.';
    END IF;

    INSERT INTO administered_vaccine (id_vaccine, id_doctor, id_patient, id_appointment, administered_date, dosage, status, due_date) VALUES (vaccine_id, doctor_id, patient_id, appointment_id, administered_date_in, dosage_in, status, due_date_in);
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION set_administered_vaccine_hashed_id_function()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE administered_vaccine SET hashed_id = hash_id(NEW.id_administered_vaccine) WHERE id_administered_vaccine = NEW.id_administered_vaccine;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--
--
--
-- Trigger to Set Hashed ID on New Rows
CREATE OR REPLACE TRIGGER set_administered_vaccine_hashed_id_trigger
AFTER INSERT ON administered_vaccine
FOR EACH ROW
EXECUTE PROCEDURE set_administered_vaccine_hashed_id_function();
--
--
--
-- Update Status
CREATE OR REPLACE FUNCTION change_administered_vaccine_status(
    IN id_administered_vaccine_in BIGINT DEFAULT NULL,
    IN hashed_id_in VARCHAR(255) DEFAULT NULL,
    IN status_in INT DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    administered_vaccine_id BIGINT;
    administered_date_in TIMESTAMP DEFAULT NULL;
BEGIN

    IF status_in <> 0 AND status_in <> 1 AND status_in <> 2 THEN
        RAISE EXCEPTION 'O status deve ser 0 ou 1 ou 2.';
    END IF;

    IF id_administered_vaccine_in IS NULL AND hashed_id_in IS NULL THEN
        RAISE EXCEPTION 'É necessário passar o id_administered_vaccine ou o hashed_id';
    END IF;

    IF hashed_id_in IS NOT NULL THEN
        SELECT id_administered_vaccine INTO administered_vaccine_id FROM administered_vaccine WHERE hashed_id = hashed_id_in;
    ELSE
        administered_vaccine_id := id_administered_vaccine_in;
    END IF;

    IF administered_vaccine_id IS NULL AND id_administered_vaccine_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum registo de vacinação com o id_administered_vaccine "%"', id_administered_vaccine_in;
    ELSIF administered_vaccine_id IS NULL AND hashed_id_in IS NOT NULL THEN
        RAISE EXCEPTION 'Não existe nenhum registo de vacinação com o hashed_id "%"', hashed_id_in;
    END IF;

    IF status_in IS NOT NULL THEN
        IF status_in = 1 THEN
            administered_date_in := NOW();
        END IF;
    ELSE  
        RAISE EXCEPTION 'É necessário passar o status da vacina';
    END IF;

    IF NOT EXISTS (SELECT * FROM administered_vaccine WHERE id_administered_vaccine = administered_vaccine_id ) THEN
        RAISE EXCEPTION 'Não existe nenhum registo de vacinação com o id_administered_vaccine "%"', administered_vaccine_id;
    END IF;
   
    IF EXISTS (SELECT * FROM administered_vaccine WHERE id_administered_vaccine = administered_vaccine_id AND status = 2) THEN
        RAISE EXCEPTION 'Não é possível alterar o status de uma vacina que já foi cancelada';
    END IF;

    IF EXISTS (SELECT * FROM administered_vaccine WHERE id_administered_vaccine = administered_vaccine_id AND status = 1) AND status_in != 2 THEN
        RAISE EXCEPTION 'Não é possível alterar o status de uma vacina que já foi administrada. Apenas é possível cancelar a vacina';
    END IF;

    UPDATE administered_vaccine SET status = status_in, administered_date = administered_date_in WHERE id_administered_vaccine = administered_vaccine_id;
    RETURN TRUE;
    
END;
$$ LANGUAGE plpgsql;
--
--
--
CREATE OR REPLACE FUNCTION get_administered_vaccines(
    IN id_administered_vaccine_in BIGINT DEFAULT NULL,
    IN hashed_id_administered_vaccine_in VARCHAR(255) DEFAULT NULL,
    IN id_vaccine_in BIGINT DEFAULT NULL,
    IN hashed_id_vaccine_in VARCHAR(255) DEFAULT NULL,
    IN id_doctor_in BIGINT DEFAULT NULL,
    IN hashed_id_doctor_in VARCHAR(255) DEFAULT NULL,
    IN id_patient_in BIGINT DEFAULT NULL,
    IN hashed_id_patient_in VARCHAR(255) DEFAULT NULL,
    IN id_appointment_in BIGINT DEFAULT NULL,
    IN hashed_id_appointment_in VARCHAR(255) DEFAULT NULL,
    IN id_health_unit_in BIGINT DEFAULT NULL,
    IN hashed_id_health_unit_in VARCHAR(255) DEFAULT NULL,
    IN administered_vaccine_date_in TIMESTAMP DEFAULT NULL,
    IN due_date_in TIMESTAMP DEFAULT NULL,
    IN status_in INT DEFAULT NULL
)
RETURNS TABLE (
    hashed_id_administered_vaccine VARCHAR(255),
    administered_date TIMESTAMP,
    administered_date_status INT,
    administered_dosage FLOAT,
    due_date DATE,
    hashed_id_vaccine VARCHAR(255),
    vaccine_name VARCHAR(255),
    vaccine_status INT,
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
    administered_vaccine_id BIGINT DEFAULT NULL;
    vaccine_id BIGINT DEFAULT NULL;
    appointment_id BIGINT DEFAULT NULL;
    health_unit_id BIGINT DEFAULT NULL;
    doctor_id BIGINT DEFAULT NULL;
    patient_id BIGINT DEFAULT NULL;
    query TEXT;
    first_condition BOOLEAN DEFAULT TRUE;
BEGIN

    IF id_administered_vaccine_in IS NOT NULL AND hashed_id_administered_vaccine_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_administered_vaccine. Ambos foram passados.';
    END IF;

    IF id_vaccine_in IS NOT NULL AND hashed_id_vaccine_in IS NOT NULL THEN
        RAISE EXCEPTION 'Apenas pode ser passado o hashed_id ou o id_vaccine. Ambos foram passados.';
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
        av.hashed_id as hashed_id_administered_vaccine,
        av.administered_date as administered_date,
        av.status as administered_date_status,
        av.dosage as administered_dosage,
        av.due_date as due_date,
        v.hashed_id as hashed_id_vaccine,
        v.vaccine_name as vaccine_name,
        v.status as vaccine_status,
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
        FROM administered_vaccine av
        INNER JOIN vaccine v ON v.id_vaccine = av.id_vaccine
        INNER JOIN appointment a ON a.id_appointment = av.id_appointment
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

    IF id_administered_vaccine_in IS NOT NULL THEN
        administered_vaccine_id := id_administered_vaccine_in;
        SELECT id_administered_vaccine INTO administered_vaccine_id FROM administered_vaccine WHERE id_administered_vaccine = id_administered_vaccine_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe vacinação com o id passado.';
        END IF;
    ELSIF hashed_id_administered_vaccine_in IS NOT NULL AND hashed_id_administered_vaccine_in != '' THEN
        SELECT id_administered_vaccine INTO administered_vaccine_id FROM administered_vaccine WHERE hashed_id = hashed_id_administered_vaccine_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe vacinação com o hashed_id passado.';
        END IF;
    END IF;

    IF id_vaccine_in IS NOT NULL THEN
        vaccine_id := id_vaccine_in;
        SELECT id_vaccine INTO vaccine_id FROM vaccine WHERE id_vaccine = id_vaccine_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe vacina com o id passado.';
        END IF;
    ELSIF hashed_id_vaccine_in IS NOT NULL AND hashed_id_vaccine_in != '' THEN
        SELECT id_vaccine INTO vaccine_id FROM vaccine WHERE hashed_id = hashed_id_vaccine_in;
        IF NOT FOUND
        THEN
            RAISE EXCEPTION 'Não existe vacina com o hashed_id passado.';
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

    IF administered_vaccine_id IS NOT NULL OR vaccine_id IS NOT NULL OR appointment_id IS NOT NULL OR health_unit_id IS NOT NULL OR doctor_id IS NOT NULL OR patient_id IS NOT NULL OR status_in IS NOT NULL OR administered_vaccine_date_in IS NOT NULL OR due_date IS NOT NULL OR status_in IS NOT NULL THEN
        query := query || ' WHERE ';
    END IF;

    IF administered_vaccine_id IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'av.id_administered_vaccine = ' || quote_literal(administered_vaccine_id);
    END IF;

    IF vaccine_id IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'av.id_vaccine = ' || quote_literal(vaccine_id);
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

    IF administered_vaccine_date_in IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'DATE(av.administered_date) = ' || quote_literal(administered_vaccine_date_in);
    END IF;

    IF due_date_in IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'DATE(av.due_date) = ' || quote_literal(due_date_in);
    END IF;

    IF status_in IS NOT NULL THEN
        IF first_condition THEN
            first_condition := FALSE;
        ELSE
            query := query || ' AND ';
        END IF;
        query := query || 'av.status = ' || quote_literal(status_in);
    END IF;

    query := query || ' ORDER BY av.administered_date DESC';
    RETURN QUERY EXECUTE query;
    
END;
$$ LANGUAGE plpgsql; 