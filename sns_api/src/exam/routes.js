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

module.exports = router;