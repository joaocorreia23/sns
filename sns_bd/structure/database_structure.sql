-- =======================
-- BEGIN: ADDRESS
-- =======================

-- Country Sequence
CREATE SEQUENCE country_sequence
INCREMENT 1
START 1;

-- District Sequence
CREATE SEQUENCE district_sequence
INCREMENT 1
START 1;

-- County Sequence
CREATE SEQUENCE county_sequence
INCREMENT 1
START 1;

-- Zip Code Sequence
CREATE SEQUENCE zip_code_sequence
INCREMENT 1
START 1;

-- Address Sequence
CREATE SEQUENCE address_sequence
INCREMENT 1
START 1;

-- Country Table
CREATE TABLE country (
	id_country BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('country_sequence'::regclass),
	country_name VARCHAR(255) UNIQUE NOT NULL
);
INSERT INTO country (country_name) VALUES ('Afeganistão'), ('África do Sul'), ('Albânia'), ('Alemanha'), ('Andorra'), ('Angola'), ('Antígua e Barbuda'), ('Arábia Saudita'), ('Argélia'), ('Argentina'), ('Arménia'), ('Austrália'), ('Áustria'), ('Azerbaijão'), ('Bahamas'), ('Bangladesh'), ('Barbados'), ('Barém'), ('Bélgica'), ('Belize'), ('Benim'), ('Bielorrússia'), ('Bolívia'), ('Bósnia e Herzegovina'), ('Botsuana'), ('Brasil'), ('Brunei'), ('Bulgária'), ('Burquina Faso'), ('Burundi'), ('Butão'), ('Cabo Verde'), ('Camarões'), ('Camboja'), ('Canadá'), ('Catar'), ('Cazaquistão'), ('Chade'), ('Chile'), ('China'), ('Chipre'), ('Colômbia'), ('Comores'), ('Congo-Brazzaville'), ('Congo-Kinshasa'), ('Coreia do Norte'), ('Coreia do Sul'), ('Cosovo'), ('Costa do Marfim'), ('Costa Rica'), ('Croácia'), ('Cuaite'), ('Cuba'), ('Dinamarca'), ('Dominica'), ('Egito'), ('Emirados Árabes Unidos'), ('Equador'), ('Eritreia'), ('Eslováquia'), ('Eslovénia'), ('Espanha'), ('Estónia'), ('Etiópia'), ('Fiji'), ('Filipinas'), ('Finlândia'), ('França'), ('Gabão'), ('Gâmbia'), ('Gana'), ('Geórgia'), ('Granada'), ('Grécia'), ('Guatemala'), ('Guiana'), ('Guiné'), ('Guiné Equatorial'), ('Guiné-Bissau'), ('Haiti'), ('Honduras'), ('Hungria'), ('Iémen'), ('Ilhas Marechal'), ('Índia'), ('Indonésia'), ('Irão'), ('Iraque'), ('Irlanda'), ('Islândia'), ('Israel'), ('Itália'), ('Jamaica'), ('Japão'), ('Jibuti'), ('Jordânia'), ('Laus'), ('Lesoto'), ('Letónia'), ('Líbano'), ('Libéria'), ('Líbia'), ('Listenstaine'), ('Lituânia'), ('Luxemburgo'), ('Macedónia do Norte'), ('Madagáscar'), ('Malásia'), ('Malaui'), ('Maldivas'), ('Mali'), ('Malta'), ('Marrocos'), ('Maurícia'), ('Mauritânia'), ('México'), ('Micronésia'), ('Moçambique'), ('Moldávia'), ('Namíbia'), ('Nauru'), ('Nepal'), ('Nicarágua'), ('Níger'), ('Nigéria'), ('Noruega'), ('Nova Zelândia'), ('Omã'), ('Países Baixos'), ('Palau'), ('Panamá'), ('Papua Nova Guiné'), ('Paquistão'), ('Paraguai'), ('Peru'), ('Polónia'), ('Portugal'), ('Quénia'), ('Quirguistão'), ('Quiribáti'), ('Reino Unido'), ('República Centro-Africana'), ('República Checa'), ('República Democrática do Congo'), ('República do Congo'), ('República Dominicana'), ('Roménia'), ('Ruanda'), ('Rússia'), ('Salomão'), ('Salvador'), ('Samoa'), ('Santa Lúcia'), ('São Cristóvão e Neves'), ('São Marinho'), ('São Tomé e Príncipe'), ('São Vicente e Granadinas'), ('Seicheles'), ('Senegal'), ('Serra Leoa'), ('Sérvia'), ('Singapura'), ('Síria'), ('Somália'), ('Sri Lanka'), ('Suazilândia'), ('Sudão'), ('Sudão do Sul'), ('Suécia'), ('Suíça'), ('Suriname'), ('Tailândia'), ('Taiwan'), ('Tajiquistão'), ('Tanzânia'), ('Timor-Leste'), ('Togo'), ('Tonga'), ('Trindade e Tobago'), ('Tunísia'), ('Turcomenistão'), ('Turquia'), ('Tuvalu'), ('Ucrânia'), ('Uganda'), ('Uruguai'), ('Usbequistão'), ('Vanuatu'), ('Vaticano'), ('Venezuela'), ('Vietname'), ('Zâmbia'), ('Zimbábue');

-- District Table
CREATE TABLE district (
	id_district BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('district_sequence'::regclass),
	district_name VARCHAR(255) NOT NULL,
	id_country BIGINT NOT NULL,
	FOREIGN KEY (id_country) REFERENCES country(id_country)
);

-- County Table
CREATE TABLE county (
	id_county BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('county_sequence'::regclass),
	county_name VARCHAR(255) NOT NULL,
	id_district BIGINT NOT NULL,
	FOREIGN KEY (id_district) REFERENCES district(id_district)
);

-- County Table
CREATE TABLE zip_code (
	id_zip_code BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('zip_code_sequence'::regclass),
	address VARCHAR(255) NOT NULL,
	zip_code VARCHAR(255) NOT NULL,
	id_county BIGINT NOT NULL,
	FOREIGN KEY (id_county) REFERENCES county(id_county)
);

-- Address Table
CREATE TABLE address (
	id_address BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('address_sequence'::regclass),
	door_number VARChAR(255) NULL,
	floor VARCHAR(255) NULL,
	id_zip_code BIGINT NOT NULL,
	FOREIGN KEY (id_zip_code) REFERENCES zip_code(id_zip_code)
);

-- =======================
-- END: ADDRESS
-- =======================

-- =======================
-- BEGIN: USER
-- =======================

-- User Sequence
CREATE SEQUENCE user_sequence
INCREMENT 1
START 1;

-- Admin Sequence 
CREATE SEQUENCE admin_sequence
INCREMENT 1
START 1;

-- Doctor Sequence 
CREATE SEQUENCE doctor_sequence
INCREMENT 1
START 1;

-- Patient Sequence 
CREATE SEQUENCE patient_sequence
INCREMENT 1
START 1;

-- User Gender Type
CREATE TYPE gender AS ENUM ('Masculino', 'Feminino', 'Outro');

-- User Role Type
CREATE TYPE role AS ENUM ('Admin', 'Doctor', 'Patient');

-- User Table
CREATE TABLE users (
	id_user BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('user_sequence'::regclass),
	hashed_id VARCHAR(255) NULL,
	username VARCHAR(64) UNIQUE NOT NULL,
	email VARCHAR(255) UNIQUE NOT NULL,
	password VARCHAR(255) NOT NULL,
	status INT NOT NULL DEFAULT 0,
	created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- UserInfo Table
CREATE TABLE user_info (
	id_user BIGINT UNIQUE NOT NULL,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	birth_date DATE NOT NULL,
	gender gender NOT NULL,
	tax_number INT UNIQUE NOT NULL,
	phone_number VARCHAR(255) NULL,
	contact_email VARCHAR(255) NULL,
	nationality BIGINT NOT NULL,--Nationality
	id_address BIGINT DEFAULT NULL,
	avatar_path VARCHAR(255) DEFAULT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_user) REFERENCES users(id_user),
	FOREIGN KEY (nationality) REFERENCES country(id_country),
	FOREIGN KEY (id_address) REFERENCES address(id_address)
);

-- UserRole Table
CREATE TABLE user_role (
	id_user BIGINT NOT NULL,
	role role NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_user) REFERENCES users(id_user)
);
--ALTER TABLE user_role ALTER COLUMN role TYPE role USING role::role;

-- Admin Table
CREATE TABLE admin (
	id_admin BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('admin_sequence'::regclass),
	id_user BIGINT NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_user) REFERENCES users(id_user)
);

-- Doctor Table
CREATE TABLE doctor (
	id_doctor BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('doctor_sequence'::regclass),
	id_user BIGINT NOT NULL,
	doctor_number VARCHAR(255) UNIQUE NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_user) REFERENCES users(id_user)
);

-- Patient Table
CREATE TABLE patient (
	id_patient BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('patient_sequence'::regclass),
	id_user BIGINT NOT NULL,
	patient_number VARCHAR(255) UNIQUE NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_user) REFERENCES users(id_user)
);


-- =======================
-- END: USER
-- =======================

-- =======================
-- BEGIN: HEALTH UNIT
-- =======================

-- Health Unit Sequence
CREATE SEQUENCE health_unit_sequence
INCREMENT 1
START 1;

-- Health Unit Doctor Sequence
CREATE SEQUENCE health_unit_doctor_sequence
INCREMENT 1
START 1;

-- Health Unit Patient Sequence
CREATE SEQUENCE health_unit_patient_sequence
INCREMENT 1
START 1;

-- Health Unit Patient Doctor Sequence
CREATE SEQUENCE patient_doctor_sequence
INCREMENT 1
START 1;

-- Health Unit Table
CREATE TABLE health_unit (
	id_health_unit BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('health_unit_sequence'::regclass),
	hashed_id VARCHAR(255) NULL,
	name VARCHAR(255) UNIQUE NOT NULL,
	id_address BIGINT NOT NULL,
	phone_number VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	type INTEGER NOT NULL,
	tax_number INT UNIQUE NOT NULL,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_address) REFERENCES address(id_address)
);
CREATE TYPE health_unit_type AS ENUM ('Hospital Publico', 'Hospital Privado', 'Clinica Publica', 'Clinica Privada', 'Centro de Saúde');
ALTER TABLE health_unit DROP COLUMN type;
ALTER TABLE health_unit ADD COLUMN type health_unit_type;

ALTER TABLE health_unit ADD COLUMN status INT NOT NULL DEFAULT 1;

--NOT NULL
ALTER TABLE health_unit ALTER COLUMN phone_number SET NOT NULL;
ALTER TABLE health_unit ALTER COLUMN email SET NOT NULL;
--UPDATE health_unit SET type = 'Hospital Publico';

-- Health Unit Doctor Table
CREATE TABLE health_unit_doctor (
	id_health_unit_doctor BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('health_unit_doctor_sequence'::regclass),
	id_health_unit BIGINT NOT NULL,
	id_doctor BIGINT NOT NULL,--USER
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_health_unit) REFERENCES health_unit(id_health_unit),
	FOREIGN KEY (id_doctor) REFERENCES users(id_user)
);

-- Health Unit Patient Table
CREATE TABLE health_unit_patient (
	id_health_unit_patient BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('health_unit_patient_sequence'::regclass),
	id_health_unit BIGINT NOT NULL,
	id_patient BIGINT NOT NULL,--USER
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_health_unit) REFERENCES health_unit(id_health_unit),
	FOREIGN KEY (id_patient) REFERENCES users(id_user)
);

-- Health Unit Patient Doctor Table
CREATE TABLE patient_doctor (
	id_patient_doctor BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('patient_doctor_sequence'::regclass),
	id_health_unit_doctor BIGINT NOT NULL,
	id_health_unit_patient BIGINT NOT NULL,
	start_date TIMESTAMP NOT NULL DEFAULT NOW(),
	end_date TIMESTAMP NULL,
	status INT NOT NULL DEFAULT 1,
	created_at TIMESTAMP NOT NULL DEFAULT NOW()
);


--start date from date to timestam

-- =======================
-- END: HEALTH UNIT
-- =======================

-- =======================
-- BEGIN: APPOINTMENT
-- =======================

-- Appointment Sequence
CREATE SEQUENCE appointment_sequence
INCREMENT 1
START 1;

-- Appointment Table
CREATE TABLE appointment (
	id_appointment BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('appointment_sequence'::regclass),
	hashed_id VARCHAR(255) NULL,
	id_health_unit BIGINT NOT NULL,
	id_user_doctor BIGINT NOT NULL,
	id_user_patient BIGINT NOT NULL,
	status INT NOT NULL DEFAULT 0,
	type INT NOT NULL DEFAULT 0,
	created_at TIMESTAMP NOT NULL DEFAULT NOW(),
	FOREIGN KEY (id_health_unit) REFERENCES health_unit(id_health_unit),
	FOREIGN KEY (id_user_doctor) REFERENCES users(id_user),
	FOREIGN KEY (id_user_patient) REFERENCES users(id_user)
);

ALTER TABLE appointment ADD COLUMN start_date DATE NOT NULL;
ALTER TABLE appointment ADD COLUMN start_time TIME NOT NULL;
ALTER TABLE appointment ADD COLUMN end_time TIME NOT NULL;

ALTER TABLE appointment ADD COLUMN type INT NOT NULL DEFAULT 0;

-- =======================
-- END: APPOINTMENT
-- =======================

-- =======================
-- BEGIN: MEDICATION
-- =======================

-- Medication Sequence
CREATE SEQUENCE medication_sequence
INCREMENT 1
START 1;

-- Prescription Sequence
CREATE SEQUENCE prescription_sequence
INCREMENT 1
START 1;

-- Medication Prescription Sequence
CREATE SEQUENCE medication_prescription_sequence
INCREMENT 1
START 1;

-- Usual Medication Request Sequence
CREATE SEQUENCE usual_medication_request_sequence
INCREMENT 1
START 1;

-- Medication Table
CREATE TABLE medication (
	id_medication BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('medication_sequence'::regclass),
	hashed_id VARCHAR(255) NULL,
	medication_name VARCHAR(255) UNIQUE NOT NULL,
	status INT NOT NULL DEFAULT 0,
	created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Prescription Table
CREATE TABLE prescription (
	id_prescription BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('prescription_sequence'::regclass),
	hashed_id VARCHAR(255) NULL,
    id_appointment BIGINT NOT NULL,
    prescription_date TIMESTAMP NOT NULL DEFAULT NOW(),
    status INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id_appointment) REFERENCES appointment(id_appointment)
);

ALTER TABLE prescription DROP COLUMN id_doctor;
ALTER TABLE prescription DROP COLUMN id_patient;

-- Medication Prescription Table
CREATE TABLE medication_prescription (
    id_medication_prescription BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('medication_prescription_sequence'::regclass),
	hashed_id VARCHAR(255) NULL,
    id_prescription BIGINT NOT NULL,
    id_medication BIGINT NOT NULL,
    access_pin INT NULL,
    option_pin INT NULL,
    prescription_number INT NULL,
    expiration_date TIMESTAMP NULL,
    prescribed_amount FLOAT NOT NULL,
    available_amount FLOAT NOT NULL,
    use_description VARCHAR(255) NULL,
    status INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id_prescription) REFERENCES prescription(id_prescription),
    FOREIGN KEY (id_medication) REFERENCES medication(id_medication)
);

-- Usual Medication Table
CREATE TABLE usual_medication (
    id_medication_prescription BIGINT NOT NULL,
    status INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NULL,
    FOREIGN KEY (id_medication_prescription) REFERENCES medication_prescription(id_medication_prescription)
);

-- Usual Medication Request Table
CREATE TABLE usual_medication_request (
	id_usual_medication_request BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('usual_medication_request_sequence'::regclass),
	hashed_id VARCHAR(255) NULL,
	id_medication BIGINT NOT NULL,
	id_doctor BIGINT NOT NULL,
	id_patient BIGINT NOT NULL,
	status INT NOT NULL DEFAULT 0,
	request_date TIMESTAMP NOT NULL DEFAULT NOW(),
	response_date TIMESTAMP NULL,
	FOREIGN KEY (id_medication) REFERENCES medication(id_medication),
	FOREIGN KEY (id_doctor) REFERENCES health_unit_doctor(id_health_unit_doctor),
	FOREIGN KEY (id_patient) REFERENCES health_unit_patient(id_health_unit_patient)
);


-- =======================
-- END: MEDICATION
-- =======================

-- =======================
-- BEGIN: VACCINE
-- =======================

-- Vaccine Sequence
CREATE SEQUENCE vaccine_sequence
INCREMENT 1
START 1;

-- Administered Vaccine Sequence
CREATE SEQUENCE administered_vaccine_sequence
INCREMENT 1
START 1;

-- Vaccine Table
CREATE TABLE vaccine (
	id_vaccine BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('vaccine_sequence'::regclass),
	hashed_id VARCHAR(255) NULL,
	vaccine_name VARCHAR(255) UNIQUE NOT NULL,
	status INT NOT NULL DEFAULT 0,
	created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Administered Vaccine Table
CREATE TABLE administered_vaccine (
    id_administered_vaccine BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('administered_vaccine_sequence'::regclass),
	hashed_id VARCHAR(255) NULL,
    id_vaccine BIGINT NOT NULL,
    id_appointment BIGINT NOT NULL,
    administered_date TIMESTAMP NULL,
    status INT NOT NULL DEFAULT 0,
    dosage FLOAT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id_vaccine) REFERENCES vaccine(id_vaccine),
    FOREIGN KEY (id_appointment) REFERENCES appointment(id_appointment)
);

ALTER TABLE administered_vaccine DROP COLUMN id_doctor;
ALTER TABLE administered_vaccine DROP COLUMN id_patient;


-- =======================
-- END: VACCINE
-- =======================

-- =======================
-- BEGIN: EXAM
-- =======================

-- Exam Sequence
CREATE SEQUENCE exam_sequence
INCREMENT 1
START 1;

-- Prescribed Exam Sequence
CREATE SEQUENCE prescribed_exam_sequence
INCREMENT 1
START 1;

-- Exam Table
CREATE TABLE exam (
	id_exam BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('exam_sequence'::regclass),
	hashed_id VARCHAR(255) NULL,
	exam_name VARCHAR(255) UNIQUE NOT NULL,
	status INT NOT NULL DEFAULT 0,
	created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Prescribed Exam Table
CREATE TABLE prescribed_exam (
    id_prescribed_exam BIGINT PRIMARY KEY NOT NULL DEFAULT NEXTVAL('prescribed_exam_sequence'::regclass),
	hashed_id VARCHAR(255) NULL,
    requisition_date TIMESTAMP NOT NULL DEFAULT NOW(),
    expiration_date TIMESTAMP NOT NULL DEFAULT NOW()+INTERVAL '60 day',
	scheduled_date TIMESTAMP NULL,
    id_appointment BIGINT NOT NULL,
    id_exam BIGINT NOT NULL,
    status INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id_appointment) REFERENCES appointment(id_appointment),
    FOREIGN KEY (id_exam) REFERENCES exam(id_exam)
);

ALTER TABLE prescribed_exam ADD COLUMN scheduled_date TIMESTAMP NULL;

-- =======================
-- END: EXAM
-- =======================

