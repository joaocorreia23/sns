const pool = require("../../db");

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
    Add_Appoitment
};