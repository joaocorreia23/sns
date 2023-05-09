const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.get('/', controller.Get_Vaccines);

router.get('/disabled', controller.Get_Vaccines_Disabled);

router.get('/table', controller.Get_Vaccines_DataTable);
router.get('/table/disabled', controller.Get_Vaccines_DataTable_Disabled);

router.post('/insert', controller.Add_Vaccine);
router.put('/update', controller.Update_Vaccine);

router.post('/deactivate', controller.Deactivate_Vaccine);
router.post('/activate', controller.Activate_Vaccine);

router.get('/:hashed_id', controller.Get_VaccineByHashedId);

module.exports = router;