const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.get('/', controller.Get_Health_Units);

router.get('/disabled', controller.Get_Health_Units_Disabled);

router.get('/table', controller.Get_Health_Units_DataTable);

router.get('/table/disabled', controller.Get_Health_Units_DataTable_Disabled);

router.get('/types', controller.Get_Health_Units_Types);

router.post('/insert', controller.Add_Health_Unit);

router.post('/deactivate', controller.Deactivate_Health_Unit);

router.post('/activate', controller.Activate_Health_Unit);

router.post('/link_doctor', controller.Link_Doctor);

router.post('/unlink_doctor', controller.Unlink_Doctor);

router.get('/doctors/:hashed_id', controller.Get_Health_Unit_Doctors);

router.post('/link_patient', controller.Link_Patient);

router.post('/unlink_patient', controller.Unlink_Patient);

router.get('/patients/:hashed_id', controller.Get_Health_Unit_Patients);

router.post('/add_patient_doctor', controller.Add_Patient_Doctor);

router.post('/remove_patient_doctor', controller.Remove_Patient_Doctor);

router.get('/get_patient_doctor/:hashed_id_patient', controller.Get_Patient_Doctor);

router.get('/:hashed_id', controller.Get_Health_UnitByHashedId);




module.exports = router;