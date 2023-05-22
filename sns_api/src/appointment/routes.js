const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.post('/', controller.Get_Appointments);

router.post('/insert', controller.Add_Appoitment);

router.post('/table', controller.Get_Appointments_DataTable);

router.post('/calendar', controller.Get_Appointments_Calendar);

router.post('/change_status', controller.Update_Appointment_Status);

router.get('/:hashed_id', controller.Get_AppointmentByHashedId);


module.exports = router;