const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.post('/', controller.Get_Appointments);

router.post('/insert', controller.Add_Appoitment);

router.post('/table', controller.Get_Appointments_DataTable);

router.get('/:hashed_id', controller.Get_AppointmentByHashedId);

module.exports = router;