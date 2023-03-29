CREATE SEQUENCE sequence_patients START 1 INCREMENT 1;

-- gender 0 = Feminino
-- gender 1 = Masculino
-- gender 3 = Outro

CREATE TABLE Patients(
	id_patient BIGINT PRIMARY KEY DEFAULT nextval('sequence_doctors'::regclass),
	id_user BIGINT,
	patient_number INT NOT NULL,
	gender gender,
	p_birth_date DATE NOT NULL,
	p_phone VARCHAR NOT NULL,
	p_email VARCHAR NOT NULL,
	nationality VARCHAR NOT NULL,
	foreign key (id_user) references users (id_user)
)

CREATE OR REPLACE PROCEDURE delete_patient(
	id_patient BIGINT 
)AS $$
BEGIN
	IF delete_patient.id_patient IS NOT NULL THEN
	DELETE FROM Patients p WHERE p.id_patient = delete_patient.id_patient;
	END IF;
END;
$$ LANGUAGE plpgsql

CREATE OR REPLACE PROCEDURE insert_patient(
	id_user BIGINT,
	patient_number INT,
	gender gender,
	p_birth_date DATE,
	p_phone VARCHAR,
	p_email VARCHAR,
	nationality VARCHAR
)AS $$
	BEGIN
		IF id_user IS NOT NULL AND patient_number IS NOT NULL AND gender IS NOT NULL AND p_birth_date IS NOT NULL AND p_phone IS NOT NULL AND p_email IS NOT NULL AND 
		nationality IS NOT NULL THEN
		INSERT INTO Patients(id_user, patient_number, gender, p_birth_date, p_phone, p_email, nationality)
		VALUES (id_user, patient_number, gender, p_birth_date, p_phone, p_email, nationality);
		END IF;
	END;
$$ LANGUAGE plpgsql

CREATE OR REPLACE PROCEDURE update_patient(
	id_user BIGINT,
	patient_number INT,
	gender gender,
	p_birth_date DATE,
	p_phone VARCHAR,
	p_email VARCHAR,
	nationality VARCHAR
)AS $$
	BEGIN
		IF id_user IS NOT NULL AND patient_number IS NOT NULL AND gender IS NOT NULL AND p_birth_date IS NOT NULL AND p_phone IS NOT NULL AND p_email IS NOT NULL AND 
		nationality IS NOT NULL THEN
		UPDATE Patients p
		SET id_user = update_patient.id_patient, patient_number = update_patient.patient_number, gender = update_patient.gender, p_birth_date = update_patient.p_birth_date, 
			 p_phone = update_patient.p_phone, p_email = update_patient.p_email, nationality = update_patient.nationality;
		END IF;
	END;
$$ LANGUAGE plpgsql

-- não testei ein 0.0