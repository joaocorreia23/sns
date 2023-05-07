const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.get('/', controller.Get_Health_Units);

router.get('/:hashed_id', controller.Get_Health_UnitByHashedId);

router.post('/insert', controller.Add_Health_Unit);

router.post('/link_doctor', controller.Link_Doctor);
router.post('/unlink_doctor', controller.Unlink_Doctor);
router.get('/doctors/:hashed_id', controller.Get_Health_Unit_Doctors);

router.post('/link_patient', controller.Link_Patient);
router.post('/unlink_patient', controller.Unlink_Patient);
router.get('/patients/:hashed_id', controller.Get_Health_Unit_Patients);



module.exports = router;