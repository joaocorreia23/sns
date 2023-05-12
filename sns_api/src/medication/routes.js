const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.get('/', controller.Get_Medication);

router.get('/disabled', controller.Get_Medication_Disabled);

router.get('/table', controller.Get_Medication_DataTable);
router.get('/table/disabled', controller.Get_Medication_DataTable_Disabled);

router.post('/insert', controller.Add_Medication);
router.put('/update', controller.Update_Medication);

router.post('/deactivate', controller.Deactivate_Medication);
router.post('/activate', controller.Activate_Medication);

router.get('/:hashed_id', controller.Get_MedicationByHashedId);

module.exports = router;