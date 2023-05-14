const pool = require("../../db");

const Get_Vaccines = (req, res) => {
    pool.query("SELECT * FROM get_vaccine()", (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json(results.rows);
    });
};

const Get_Vaccines_Disabled = (req, res) => {
    pool.query("SELECT * FROM get_vaccine(null, null, 0)", (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json(results.rows);
    });
};

const Get_Vaccines_DataTable = (req, res) => {
    pool.query("SELECT * FROM get_vaccine()", (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Get_Vaccines_DataTable_Disabled = (req, res) => {
    pool.query("SELECT * FROM get_vaccine(null, null, 0)", (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Get_VaccineByHashedId = (req, res) => {
    const hashed_id = req.params.hashed_id;
    pool.query("SELECT * FROM get_vaccine(NULL, $1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json({ "status": true, "data": results.rows[0] });
    });
};

const Add_Vaccine = (req, res) => {
    const { vaccine_name } = req.body;
    pool.query("SELECT * FROM insert_vaccine($1)", [vaccine_name], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Vacina adicionada com sucesso!" });
    });
};

const Update_Vaccine = (req, res) => {
    const { hashed_id, vaccine_name, status } = req.body;
    pool.query("SELECT * FROM update_vaccine(NULL, $1, $2, $3)", [hashed_id, vaccine_name, status], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Vacina atualizada com sucesso!" });
    });
};

const Deactivate_Vaccine = (req, res) => {
    const { hashed_id } = req.body
    pool.query("SELECT * FROM change_vaccine_status(NULL, $1, 0)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Vacina desativada com sucesso!" });
    });
};

const Activate_Vaccine = (req, res) => {
    const { hashed_id } = req.body
    pool.query("SELECT * FROM change_vaccine_status(NULL, $1, 1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Vacina ativada com sucesso!" });
    });
};

// Administered_Vaccine

const Get_Administered_Vaccines = (req, res) => {

    const hashed_id_administered_vaccine_in = req.body.hashed_id_administered_vaccine_in !== undefined && req.body.hashed_id_administered_vaccine_in !== '' ? req.body.hashed_id_administered_vaccine_in : null;
    const hashed_id_vaccine_in = req.body.hashed_id_vaccine_in !== undefined && req.body.hashed_id_vaccine_in !== '' ? req.body.hashed_id_vaccine_in : null;
    const hashed_id_doctor = req.body.hashed_id_doctor !== undefined && req.body.hashed_id_doctor !== '' ? req.body.hashed_id_doctor : null;
    const hashed_id_patient = req.body.hashed_id_patient !== undefined && req.body.hashed_id_patient !== '' ? req.body.hashed_id_patient : null;
    const hashed_id_appointment = req.body.hashed_id_appointment !== undefined && req.body.hashed_id_appointment !== '' ? req.body.hashed_id_appointment : null;
    const hashed_id_health_unit = req.body.hashed_id_health_unit !== undefined && req.body.hashed_id_health_unit !== '' ? req.body.hashed_id_health_unit : null;
    const administered_vaccine_date_in = req.body.administered_vaccine_date_in !== undefined && req.body.administered_vaccine_date_in !== '' ? req.body.administered_vaccine_date_in : null;
    const due_date_in = req.body.due_date_in !== undefined && req.body.due_date_in !== '' ? req.body.due_date_in : null;
    const status = req.body.status !== undefined && req.body.status !== '' ? req.body.status : null;

    pool.query("SELECT * FROM get_administered_vaccines(NULL, $1, NULL, $2, NULL, $3, NULL, $4, NULL, $5, NULL, $6, $7, $8, $9)", [hashed_id_administered_vaccine_in, hashed_id_vaccine_in, hashed_id_doctor, hashed_id_patient, hashed_id_appointment, hashed_id_health_unit, administered_vaccine_date_in, due_date_in, status], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows });
    });
};

const Get_Administered_Vaccines_DataTable = (req, res) => {

    const hashed_id_administered_vaccine_in = req.body.hashed_id_administered_vaccine_in !== undefined && req.body.hashed_id_administered_vaccine_in !== '' ? req.body.hashed_id_administered_vaccine_in : null;
    const hashed_id_vaccine_in = req.body.hashed_id_vaccine_in !== undefined && req.body.hashed_id_vaccine_in !== '' ? req.body.hashed_id_vaccine_in : null;
    const hashed_id_doctor = req.body.hashed_id_doctor !== undefined && req.body.hashed_id_doctor !== '' ? req.body.hashed_id_doctor : null;
    const hashed_id_patient = req.body.hashed_id_patient !== undefined && req.body.hashed_id_patient !== '' ? req.body.hashed_id_patient : null;
    const hashed_id_appointment = req.body.hashed_id_appointment !== undefined && req.body.hashed_id_appointment !== '' ? req.body.hashed_id_appointment : null;
    const hashed_id_health_unit = req.body.hashed_id_health_unit !== undefined && req.body.hashed_id_health_unit !== '' ? req.body.hashed_id_health_unit : null;
    const administered_vaccine_date_in = req.body.administered_vaccine_date_in !== undefined && req.body.administered_vaccine_date_in !== '' ? req.body.administered_vaccine_date_in : null;
    const due_date_in = req.body.due_date_in !== undefined && req.body.due_date_in !== '' ? req.body.due_date_in : null;
    const status = req.body.status !== undefined && req.body.status !== '' ? req.body.status : null;

    pool.query("SELECT * FROM get_administered_vaccines(NULL, $1, NULL, $2, NULL, $3, NULL, $4, NULL, $5, NULL, $6, $7, $8, $9)", [hashed_id_administered_vaccine_in, hashed_id_vaccine_in, hashed_id_doctor, hashed_id_patient, hashed_id_appointment, hashed_id_health_unit, administered_vaccine_date_in, due_date_in, status], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Add_Administered_Vaccine = (req, res) => {
    const { hashed_id_vaccine, hashed_id_doctor, hashed_id_patient, hashed_id_appointment, administered_date, dosage, due_date } = req.body;
    pool.query("SELECT * FROM create_administered_vaccine(NULL, $1, NULL, $2, NULL, $3, NULL, $4, $5, $6, NULL, $7)", [hashed_id_vaccine, hashed_id_doctor, hashed_id_patient, hashed_id_appointment, administered_date, dosage, due_date], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Registo de vacinação adicionado com sucesso!" });
    });
};

const Cancel_Administered_Vaccine = (req, res) => {
    const { hashed_id } = req.body
    pool.query("SELECT * FROM change_administered_vaccine_status(NULL, $1, 2)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Registo de vacinação cancelado com sucesso!" });
    });
};

const Administer_Administered_Vaccine = (req, res) => {
    const { hashed_id } = req.body
    pool.query("SELECT * FROM change_administered_vaccine_status(NULL, $1, 1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Vacina administrada com sucesso!" });
    });
};



module.exports = {
    Get_Vaccines,
    Get_Vaccines_Disabled,
    Get_Vaccines_DataTable,
    Get_Vaccines_DataTable_Disabled,
    Get_VaccineByHashedId,
    Add_Vaccine,
    Update_Vaccine,
    Deactivate_Vaccine,
    Activate_Vaccine,
    Get_Administered_Vaccines,
    Get_Administered_Vaccines_DataTable,
    Add_Administered_Vaccine,
    Cancel_Administered_Vaccine,
    Administer_Administered_Vaccine
};