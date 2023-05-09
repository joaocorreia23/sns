const pool = require("../../db");

const Get_Health_Units = (req, res) => {
    pool.query("SELECT * FROM get_health_unit(null, null, 1)", (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(200).json(results.rows);
    });
};

const Get_Health_Units_Disabled = (req, res) => {
    pool.query("SELECT * FROM get_health_unit(null, null, 0)", (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(200).json(results.rows);
    });
};

const Get_Health_Units_DataTable = (req, res) => {
    pool.query("SELECT * FROM get_health_unit(null, null , 1)", (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(200).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Get_Health_Units_DataTable_Disabled = (req, res) => {
    pool.query("SELECT * FROM get_health_unit(null, null , 0)", (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(200).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Get_Health_UnitByHashedId = (req, res) => {
    const hashed_id = req.params.hashed_id;
    pool.query("SELECT * FROM get_health_unit(NULL, $1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(200).json(results.rows[0]);
    });
};

const Add_Health_Unit = (req, res) => {
    const { name, phone_number, email, type, tax_number, door_number, floor, address, zip_code, county, district } = req.body;
    pool.query("SELECT * FROM create_health_unit($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, 137)", [name, phone_number, email, type, tax_number, door_number, floor, address, zip_code, county, district], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Unidade de Saúde Adicionada Com Sucesso!" });
    });
};

const Deactivate_Health_Unit = (req, res) => {
    const { hashed_id } = req.body
    pool.query("SELECT * FROM change_health_unit_status(NULL, $1, 0)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Unidade de Saúde Desativada Com Sucesso!" });
    });
};

const Activate_Health_Unit = (req, res) => {
    const { hashed_id } = req.body;
    pool.query("SELECT * FROM change_health_unit_status(NULL, $1, 1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Unidade de Saúde Ativada Com Sucesso!" });
    });
};

const Get_Health_Units_Types = (req, res) => {
    pool.query("SELECT * FROM get_health_unit_types_enum()", (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(200).json(results.rows);
    });
};


module.exports = {
    Get_Health_Units,
    Get_Health_Units_Disabled,
    Get_Health_Units_DataTable,
    Get_Health_Units_DataTable_Disabled,
    Get_Health_UnitByHashedId,
    Add_Health_Unit,
    Deactivate_Health_Unit,
    Activate_Health_Unit,
    Get_Health_Units_Types
};