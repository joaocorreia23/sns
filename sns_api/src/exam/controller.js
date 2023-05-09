const pool = require("../../db");

const Get_Exams = (req, res) => {
    pool.query("SELECT * FROM get_exams()", (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json(results.rows);
    });
};

const Get_Exams_Disabled = (req, res) => {
    pool.query("SELECT * FROM get_exams(null, null, 0)", (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json(results.rows);
    });
};

const Get_Exams_DataTable = (req, res) => {
    pool.query("SELECT * FROM get_exams()", (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Get_Exams_DataTable_Disabled = (req, res) => {
    pool.query("SELECT * FROM get_exams(null, null, 0)", (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Get_ExamByHashedId = (req, res) => {
    const hashed_id = req.params.hashed_id;
    pool.query("SELECT * FROM get_exams(NULL, $1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(200).json({ "status": true, "data": results.rows[0] });
    });
};

const Add_Exam = (req, res) => {
    const { exam_name } = req.body;
    pool.query("SELECT * FROM create_exam($1)", [exam_name], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Exame criado com sucesso!" });
    });
};

const Update_Exam = (req, res) => {
    const { hashed_id, exam_name } = req.body;
    pool.query("SELECT * FROM update_exam(NULL, $1, $2)", [hashed_id, exam_name], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Exame atualizado com sucesso!" });
    });
};

const Deactivate_Exam = (req, res) => {
    const { hashed_id } = req.body
    pool.query("SELECT * FROM change_exam_status(NULL, $1, 0)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Exame desativado com sucesso!" });
    });
};

const Activate_Exam = (req, res) => {
    const { hashed_id } = req.body
    pool.query("SELECT * FROM change_exam_status(NULL, $1, 1)", [hashed_id], (error, results) => {
        if (error) {
            res.status(400).json({ error: error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Exame ativado com sucesso!" });
    });
};


module.exports = {
    Get_Exams,
    Get_Exams_Disabled,
    Get_Exams_DataTable,
    Get_Exams_DataTable_Disabled,
    Get_ExamByHashedId,
    Add_Exam,
    Update_Exam,
    Deactivate_Exam,
    Activate_Exam
};