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


module.exports = {
    Get_Vaccines,
    Get_Vaccines_Disabled,
    Get_Vaccines_DataTable,
    Get_Vaccines_DataTable_Disabled,
    Get_VaccineByHashedId,
    Add_Vaccine,
    Update_Vaccine,
    Deactivate_Vaccine,
    Activate_Vaccine
};