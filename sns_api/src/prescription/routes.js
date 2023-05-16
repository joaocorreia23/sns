const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.post('/', controller.Get_Prescriptions);
router.post('/table', controller.Get_Prescriptions_DataTable);
router.post('/insert', controller.Add_Prescription);
router.post('/insert_new', controller.Add_Prescription_New);
router.post('/update', controller.Update_Prescription);
router.get('/:hashed_id', controller.Get_PrescriptionByHashedId);

router.post('/deactivate', controller.Deactivate_Prescription);
router.post('/activate', controller.Activate_Prescription);

module.exports = router;