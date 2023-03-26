CREATE SEQUENCE sequence_doctors START 1 INCREMENT 1;

-- gender 0 = Feminino
-- gender 1 = Masculino
-- gender 3 = Outro

CREATE TYPE d_gender AS ENUM (
   'Feminino', 'Masculino', 'Outro'
)

CREATE TABLE Doctors(
	id_doctor BIGINT PRIMARY KEY DEFAULT nextval('sequence_doctors'::regclass),
	id_user BIGINT,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	birth_date DATE,
	d_gender d_gender,
	doctor_nif INT NOT NULL,
	phone_number INT NOT NULL,
	doctor_id BIGINT NOT NULL,
	doctor_number INT NOT NULL,
	foreign key (id_user) references users (id_user) 
)

CREATE OR REPLACE PROCEDURE delete_doctor(
	id_doctor BIGINT 
)AS $$
BEGIN
	IF delete_doctor.id_doctor IS NOT NULL THEN
	DELETE FROM Doctors d WHERE d.id_doctor = delete_doctor.id_doctor;
	END IF;
END;
$$ LANGUAGE plpgsql

-- 
CREATE OR REPLACE PROCEDURE insert_doctor(
	id_user BIGINT,
	first_name VARCHAR,
	last_name VARCHAR,
	birth_date DATE,
	d_gender d_gender,
	doctor_nif INT,
	phone_number INT,
	doctor_id BIGINT,
	doctor_number INT
)AS $$
	BEGIN
		IF id_user IS NOT NULL AND first_name IS NOT NULL AND last_name IS NOT NULL  
		AND doctor_nif IS NOT NULL AND phone_number IS NOT NULL AND doctor_id IS NOT NULL
		AND doctor_number IS NOT NULL THEN
		INSERT INTO Doctors(id_user, first_name, last_name, birth_date, d_gender, doctor_nif, phone_number, doctor_id, doctor_number)
		VALUES (id_user, first_name, last_name, birth_date, d_gender, doctor_nif, phone_number, doctor_id, doctor_number);
		END IF;
	END;
$$ LANGUAGE plpgsql

--
CREATE OR REPLACE PROCEDURE update_doctor(
	id_doctor BIGINT,
	id_user BIGINT,
	first_name VARCHAR,
	last_name VARCHAR,
	birth_date DATE,
	d_gender d_gender,
	doctor_nif INT,
	phone_number INT,
	doctor_id BIGINT,
	doctor_number INT
	
)AS $$
	BEGIN
		IF update_doctor.id_doctor IS NOT NULL AND update_doctor.id_user IS NOT NULL AND update_doctor.first_name IS NOT NULL AND update_doctor.last_name IS NOT NULL 
		AND update_doctor.doctor_nif IS NOT NULL AND update_doctor.phone_number IS NOT NULL AND update_doctor.doctor_id IS NOT NULL
		AND update_doctor.doctor_number IS NOT NULL THEN
		UPDATE Doctors d 
		SET id_user = update_doctor.id_user, first_name = update_doctor.first_name, last_name = update_doctor.last_name, 
			 birth_date = update_doctor.birth_date, d_gender = update_doctor.d_gender, doctor_nif = update_doctor.doctor_nif, phone_number = update_doctor.phone_number , 
			 doctor_id = update_doctor.doctor_id, doctor_number = update_doctor.doctor_number WHERE d.id_doctor = update_doctor.id_doctor;
		END IF;
	END;
$$ LANGUAGE plpgsql

--
-- testes !!!!!!!
select * from users;
INSERT INTO users (
	user_name,
	email,
	password,
	role,
	status
) VALUES ('svieirathays', 'svieirathays@gmail.com', 123455678, 0,0);

CALL insert_doctor(1, 'Thays', 'Vieira', DATE '1998-03-23', 'Feminino', 789, 999, 1, 19);
CALL update_doctor(2, 1, 'Thays', 'Souza', DATE '1998-03-23', 'Feminino', 789, 999, 1, 19);
CALL delete_doctor(2);
SELECT * FROM Doctors;
