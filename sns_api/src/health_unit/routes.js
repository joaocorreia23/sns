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

router.get('/:hashed_id', controller.Get_Health_UnitByHashedId);

module.exports = router;