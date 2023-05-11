const { json } = require("express");
const pool = require("../../db");

const Get_Appointments = (req, res) => {

    const hashed_id_appointment = req.body.hashed_id_appointment !== undefined && req.body.hashed_id_appointment !== '' ? req.body.hashed_id_appointment : null;
    const hashed_id_health_unit = req.body.hashed_id_health_unit !== undefined && req.body.hashed_id_health_unit !== '' ? req.body.hashed_id_health_unit : null;
    const hashed_id_doctor = req.body.hashed_id_doctor !== undefined && req.body.hashed_id_doctor !== '' ? req.body.hashed_id_doctor : null;
    const hashed_id_patient = req.body.hashed_id_patient !== undefined && req.body.hashed_id_patient !== '' ? req.body.hashed_id_patient : null;
    const start_date = req.body.start_date !== undefined && req.body.start_date !== '' ? req.body.start_date : null;
    const status = req.body.status !== undefined && req.body.status !== '' ? req.body.status : null;

    pool.query("SELECT * FROM get_appointments(NULL, $1, NULL, $2, NULL, $3, NULL, $4, $5, $6)", [hashed_id_appointment, hashed_id_health_unit, hashed_id_doctor, hashed_id_patient, start_date, status], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json({ "status": true, "data": results.rows });
    });
};

const Get_Appointments_DataTable = (req, res) => {
    
    const hashed_id_appointment = req.body.hashed_id_appointment !== undefined && req.body.hashed_id_appointment !== '' ? req.body.hashed_id_appointment : null;
    const hashed_id_health_unit = req.body.hashed_id_health_unit !== undefined && req.body.hashed_id_health_unit !== '' ? req.body.hashed_id_health_unit : null;
    const hashed_id_doctor = req.body.hashed_id_doctor !== undefined && req.body.hashed_id_doctor !== '' ? req.body.hashed_id_doctor : null;
    const hashed_id_patient = req.body.hashed_id_patient !== undefined && req.body.hashed_id_patient !== '' ? req.body.hashed_id_patient : null;
    const start_date = req.body.start_date !== undefined && req.body.start_date !== '' ? req.body.start_date : null;
    const status = req.body.status !== undefined && req.body.status !== '' ? req.body.status : null;

    pool.query("SELECT * FROM get_appointments(NULL, $1, NULL, $2, NULL, $3, NULL, $4, $5, $6)", [hashed_id_appointment, hashed_id_health_unit, hashed_id_doctor, hashed_id_patient, start_date, status], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Get_AppointmentByHashedId = (req, res) => {
    const hashed_id = req.params.hashed_id;
    pool.query("SELECT * FROM get_appointments(NULL, $1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json({ "status": true, "data": results.rows });
    });
};


const Add_Appoitment = (req, res) => {
    const { hashed_id_health_unit, hashed_id_doctor, hashed_id_patient, start_date, start_time, end_time } = req.body;
    pool.query("SELECT * FROM create_appointment(NULL, $1, NULL, $2, NULL, $3, $4, $5, $6)", [hashed_id_health_unit, hashed_id_doctor, hashed_id_patient, start_date, start_time, end_time], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Consulta marcada com sucesso para o dia " + start_date + " às " + start_time + "!" });
    });
};




module.exports = {
    Get_Appointments,
    Get_Appointments_DataTable,
    Get_AppointmentByHashedId,
    Add_Appoitment
};