const pool = require("../../db");

const Get_Prescriptions = (req, res) => {

    const hashed_id_prescription = req.body.hashed_id_prescription !== undefined && req.body.hashed_id_prescription !== '' ? req.body.hashed_id_prescription : null;
    const hashed_id_doctor = req.body.hashed_id_doctor !== undefined && req.body.hashed_id_doctor !== '' ? req.body.hashed_id_doctor : null;
    const hashed_id_patient = req.body.hashed_id_patient !== undefined && req.body.hashed_id_patient !== '' ? req.body.hashed_id_patient : null;
    const hashed_id_appointment = req.body.hashed_id_appointment !== undefined && req.body.hashed_id_appointment !== '' ? req.body.hashed_id_appointment : null;
    const hashed_id_health_unit = req.body.hashed_id_health_unit !== undefined && req.body.hashed_id_health_unit !== '' ? req.body.hashed_id_health_unit : null;
    const prescription_date = req.body.prescription_date !== undefined && req.body.prescription_date !== '' ? req.body.prescription_date : null;
    const status = req.body.status !== undefined && req.body.status !== '' ? req.body.status : null;

    pool.query("SELECT * FROM get_prescription(NULL, $1, NULL, $2, NULL, $3, NULL, $4, NULL, $5, $6, $7)", [hashed_id_prescription, hashed_id_doctor, hashed_id_patient, hashed_id_appointment, hashed_id_health_unit, prescription_date, status], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows });
    });
};

const Get_Prescriptions_DataTable = (req, res) => {

    const hashed_id_prescription = req.body.hashed_id_prescription !== undefined && req.body.hashed_id_prescription !== '' ? req.body.hashed_id_prescription : null;
    const hashed_id_doctor = req.body.hashed_id_doctor !== undefined && req.body.hashed_id_doctor !== '' ? req.body.hashed_id_doctor : null;
    const hashed_id_patient = req.body.hashed_id_patient !== undefined && req.body.hashed_id_patient !== '' ? req.body.hashed_id_patient : null;
    const hashed_id_appointment = req.body.hashed_id_appointment !== undefined && req.body.hashed_id_appointment !== '' ? req.body.hashed_id_appointment : null;
    const hashed_id_health_unit = req.body.hashed_id_health_unit !== undefined && req.body.hashed_id_health_unit !== '' ? req.body.hashed_id_health_unit : null;
    const prescription_date = req.body.prescription_date !== undefined && req.body.prescription_date !== '' ? req.body.prescription_date : null;
    const status = req.body.status !== undefined && req.body.status !== '' ? req.body.status : null;

    pool.query("SELECT * FROM get_prescription(NULL, $1, NULL, $2, NULL, $3, NULL, $4, NULL, $5, $6, $7)", [hashed_id_prescription, hashed_id_doctor, hashed_id_patient, hashed_id_appointment, hashed_id_health_unit, prescription_date, status], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Add_Prescription = (req, res) => {
    const { hashed_id_doctor, hashed_id_patient, hashed_id_appointment, prescription_date } = req.body;
    pool.query("SELECT * FROM create_prescription(NULL, $1, NULL, $2, NULL, $3, $4, NULL)", [hashed_id_doctor, hashed_id_patient, hashed_id_appointment, prescription_date], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Prescrição criada com sucesso!" });
    });
};

const Update_Prescription = (req, res) => {
    const { hashed_id_prescription, hashed_id_doctor, hashed_id_patient, hashed_id_appointment, prescription_date } = req.body;
    pool.query("SELECT * FROM update_prescription(NULL, $1, NULL, $2, NULL, $3, NULL, $4, $5, NULL)", [hashed_id_prescription, hashed_id_doctor, hashed_id_patient, hashed_id_appointment, prescription_date], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Prescrição atualizada com sucesso!" });
    });
};

const Get_PrescriptionByHashedId = (req, res) => {
    const hashed_id = req.params.hashed_id;
    pool.query("SELECT * FROM get_prescription(NULL, $1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows });
    });
};

const Deactivate_Prescription = (req, res) => {
    const { hashed_id } = req.body
    pool.query("SELECT * FROM change_prescription_status(NULL, $1, 0)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Prescrição desativada com sucesso!" });
    });
};

const Activate_Prescription = (req, res) => {
    const { hashed_id } = req.body
    pool.query("SELECT * FROM change_prescription_status(NULL, $1, 1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Prescrição ativada com sucesso!" });
    });
};




module.exports = {
    Get_Prescriptions,
    Get_Prescriptions_DataTable,
    Add_Prescription,
    Update_Prescription,
    Get_PrescriptionByHashedId,
    Deactivate_Prescription,
    Activate_Prescription
};