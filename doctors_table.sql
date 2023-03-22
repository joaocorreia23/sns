CREATE SEQUENCE sequence_doctors START 1 INCREMENT 1;

CREATE TABLE Doctors(
	id_doctor BIGINT PRIMARY KEY DEFAULT nextval('sequence_doctor::regclass'),
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	birth_date DATETIME,
	doctor_gender VARCHAR(11),
	doctor_nif INT(9),
	phone_number INT(9),
	doctor_id BIGINT,
	doctor_number INT(11),
	foreign key (id_user) references users (id_user) 
)

CREATE OR REPLACE PROCEDURE delete_doctor(

)