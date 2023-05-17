const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.get('/', controller.Get_Exams);
router.get('/disabled', controller.Get_Exams_Disabled);

router.get('/table', controller.Get_Exams_DataTable);
router.get('/table/disabled', controller.Get_Exams_DataTable_Disabled);

router.post('/insert', controller.Add_Exam);
router.put('/update', controller.Update_Exam);

router.post('/deactivate', controller.Deactivate_Exam);
router.post('/activate', controller.Activate_Exam);

router.get('/:hashed_id', controller.Get_ExamByHashedId);

router.post('/prescribed', controller.Get_Prescribed_Exams);
router.post('/prescribed/table', controller.Get_Prescribed_Exams_DataTable);

router.get('/prescribed/:hashed_id', controller.Get_Prescribed_ExamByHashedId);

router.post('/prescribed/insert', controller.Add_Prescribed_Exam);

router.post('/prescribed/schedule', controller.ScheduleExam);

router.post('/prescribed/cancel', controller.CancelExam);
router.post('/prescribed/confirm', controller.ConfirmExam);

module.exports = router;