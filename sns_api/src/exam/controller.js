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

// PRESCTIBED EXAMS

const Get_Prescribed_Exams = (req, res) => {

    const hashed_id_prescribed_exam = req.body.hashed_id_prescribed_exam !== undefined && req.body.hashed_id_prescribed_exam !== '' ? req.body.hashed_id_prescribed_exam : null;
    const hashed_id_exam = req.body.hashed_id_exam !== undefined && req.body.hashed_id_exam !== '' ? req.body.hashed_id_exam : null;
    const hashed_id_doctor = req.body.hashed_id_doctor !== undefined && req.body.hashed_id_doctor !== '' ? req.body.hashed_id_doctor : null;
    const hashed_id_patient = req.body.hashed_id_patient !== undefined && req.body.hashed_id_patient !== '' ? req.body.hashed_id_patient : null;
    const hashed_id_appointment = req.body.hashed_id_appointment !== undefined && req.body.hashed_id_appointment !== '' ? req.body.hashed_id_appointment : null;
    const hashed_id_health_unit = req.body.hashed_id_health_unit !== undefined && req.body.hashed_id_health_unit !== '' ? req.body.hashed_id_health_unit : null;
    const requisition_date = req.body.requisition_date !== undefined && req.body.requisition_date !== '' ? req.body.requisition_date : null;
    const scheduled_date = req.body.scheduled_date !== undefined && req.body.scheduled_date !== '' ? req.body.scheduled_date : null;
    const expiration_date = req.body.expiration_date !== undefined && req.body.expiration_date !== '' ? req.body.expiration_date : null;
    const status = req.body.status !== undefined && req.body.status !== '' ? req.body.status : null;

    pool.query("SELECT * FROM get_prescribed_exam(NULL, $1, NULL, $2, NULL, $3, NULL, $4, NULL, $5, NULL, $6, $7, $8, $9, $10)", [hashed_id_prescribed_exam, hashed_id_exam, hashed_id_doctor, hashed_id_patient, hashed_id_appointment, hashed_id_health_unit, requisition_date, scheduled_date, expiration_date, status], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows });
    });
};

const Get_Prescribed_Exams_DataTable = (req, res) => {
    const hashed_id_prescribed_exam = req.body.hashed_id_prescribed_exam !== undefined && req.body.hashed_id_prescribed_exam !== '' ? req.body.hashed_id_prescribed_exam : null;
    const hashed_id_exam = req.body.hashed_id_exam !== undefined && req.body.hashed_id_exam !== '' ? req.body.hashed_id_exam : null;
    const hashed_id_doctor = req.body.hashed_id_doctor !== undefined && req.body.hashed_id_doctor !== '' ? req.body.hashed_id_doctor : null;
    const hashed_id_patient = req.body.hashed_id_patient !== undefined && req.body.hashed_id_patient !== '' ? req.body.hashed_id_patient : null;
    const hashed_id_appointment = req.body.hashed_id_appointment !== undefined && req.body.hashed_id_appointment !== '' ? req.body.hashed_id_appointment : null;
    const hashed_id_health_unit = req.body.hashed_id_health_unit !== undefined && req.body.hashed_id_health_unit !== '' ? req.body.hashed_id_health_unit : null;
    const requisition_date = req.body.requisition_date !== undefined && req.body.requisition_date !== '' ? req.body.requisition_date : null;
    const scheduled_date = req.body.scheduled_date !== undefined && req.body.scheduled_date !== '' ? req.body.scheduled_date : null;
    const expiration_date = req.body.expiration_date !== undefined && req.body.expiration_date !== '' ? req.body.expiration_date : null;
    const status = req.body.status !== undefined && req.body.status !== '' ? req.body.status : null;

    pool.query("SELECT * FROM get_prescribed_exam(NULL, $1, NULL, $2, NULL, $3, NULL, $4, NULL, $5, NULL, $6, $7, $8, $9, $10)", [hashed_id_prescribed_exam, hashed_id_exam, hashed_id_doctor, hashed_id_patient, hashed_id_appointment, hashed_id_health_unit, requisition_date, scheduled_date, expiration_date, status], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ 'recordsFiltered': results.rows.length, 'recordsTotal': results.rows.length, 'data': results.rows });
    });
};

const Get_Prescribed_ExamByHashedId = (req, res) => {
    const hashed_id_prescribed_exam = req.params.hashed_id_prescribed_exam;
    pool.query("SELECT * FROM get_prescribed_exam(NULL, $1)", [hashed_id_prescribed_exam], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0] });
    });
};

const Add_Prescribed_Exam = (req, res) => {
    const { hashed_id_appointment, hashed_id_exam } = req.body;
    const scheduled_date = req.body.scheduled_date != "" ? req.body.scheduled_date : null;
    pool.query("SELECT * FROM create_prescribed_exam(NULL, $1, NULL, $2, NULL, NULL, $3)", [hashed_id_appointment, hashed_id_exam, scheduled_date], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message, "message": "Erro ao criar Prescrição de Exame!" });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Prescrição de Exame criada com sucesso!" });
    });
};

const ScheduleExam = (req, res) => {
    const { hashed_id_prescribed_exam, scheduled_date } = req.body;
    pool.query("SELECT * FROM schedule_exam(NULL, $1, $2)", [hashed_id_prescribed_exam, scheduled_date], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message, "message": "Erro ao agendar Exame!" });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Exame agendado com sucesso!" });
    });
};

const CancelExam = (req, res) => {
    const { hashed_id_prescribed_exam } = req.body;
    pool.query("SELECT * FROM change_prescribed_exam_status(NULL, $1, 2)", [hashed_id_prescribed_exam], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message, "message": "Erro ao cancelar Exame!" });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Exame cancelado com sucesso!" });
    });
};

const ConfirmExam = (req, res) => {
    const { hashed_id_prescribed_exam } = req.body;
    pool.query("SELECT * FROM change_prescribed_exam_status(NULL, $1, 1)", [hashed_id_prescribed_exam], (error, results) => {
        if (error) {
            res.status(400).json({ "status": false, "error": error.message, "message": "Erro ao confirmar Exame!" });
            return;
        }
        res.status(201).json({ "status": true, "data": results.rows[0], "message": "Exame confirmado com sucesso!" });
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
    Activate_Exam,
    Get_Prescribed_Exams,
    Get_Prescribed_ExamByHashedId,
    Get_Prescribed_Exams_DataTable,
    Add_Prescribed_Exam,
    ScheduleExam,
    CancelExam,
    ConfirmExam
};