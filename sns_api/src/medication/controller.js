const pool = require("../../db");

const Get_Medication = (req, res) => {
    pool.query("SELECT * FROM get_medications()", (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json(results.rows);
    });
};

const Get_Medication_Disabled = (req, res) => {
    pool.query("SELECT * FROM get_medications(null, null, 0)", (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json(results.rows);
    });
};

const Get_Medication_DataTable = (req, res) => {
    pool.query("SELECT * FROM get_medications()", (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Get_Medication_DataTable_Disabled = (req, res) => {
    pool.query("SELECT * FROM get_medications(null, null, 0)", (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Get_MedicationByHashedId = (req, res) => {
    const hashed_id = req.params.hashed_id;
    pool.query("SELECT * FROM get_medications(NULL, $1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json({ "status": true, "data": results.rows[0] });
    });
};

const Add_Medication = (req, res) => {
    const { medication_name } = req.body;
    pool.query("SELECT * FROM create_medication($1)", [medication_name], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Medicação adicionada com sucesso!" });
    });
};

const Update_Medication = (req, res) => {
    const { hashed_id, medication_name, status } = req.body;
    pool.query("SELECT * FROM update_medication(NULL, $1, $2, $3)", [hashed_id, medication_name, status], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Medicação atualizada com sucesso!" });
    });
};

const Deactivate_Medication = (req, res) => {
    const { hashed_id } = req.body
    pool.query("SELECT * FROM change_medication_status(NULL, $1, 0)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Medicação desativada com sucesso!" });
    });
};

const Activate_Medication = (req, res) => {
    const { hashed_id } = req.body
    pool.query("SELECT * FROM change_medication_status(NULL, $1, 1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Medicação ativada com sucesso!" });
    });
};

const Add_Usual_Medication = (req, res) => {
    const { hashed_id_medication_prescription } = req.body;
    pool.query("SELECT * FROM add_to_usual_medication(NULL, $1)", [hashed_id_medication_prescription], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Medicação adicionada com sucesso!" });
    });
};

const Remove_Usual_Medication = (req, res) => {
    const { hashed_id_medication_prescription } = req.body;
    pool.query("SELECT * FROM remove_from_usual_medication(NULL, $1)", [hashed_id_medication_prescription], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Medicação removida com sucesso!" });
    });
};

const Get_Usual_Medication = (req, res) => {
    const { hashed_id_patient, status} = req.body;
    pool.query("SELECT * FROM get_usual_medication(NULL, $1, $2)", [hashed_id_patient, status], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows });
    });
};

const Get_Usual_Medication_DataTable = (req, res) => {
    const { hashed_id_patient, status} = req.body;
    pool.query("SELECT * FROM get_usual_medication(NULL, $1, $2)", [hashed_id_patient, status], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};


module.exports = {
    Get_Medication,
    Get_Medication_Disabled,
    Get_Medication_DataTable,
    Get_Medication_DataTable_Disabled,
    Get_MedicationByHashedId,
    Add_Medication,
    Update_Medication,
    Deactivate_Medication,
    Activate_Medication,
    Add_Usual_Medication,
    Remove_Usual_Medication,
    Get_Usual_Medication,
    Get_Usual_Medication_DataTable
};