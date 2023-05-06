const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.get('/', controller.Get_Health_Units);

router.get('/:hashed_id', controller.Get_Health_UnitByHashedId);

router.post('/insert', controller.Add_Health_Unit);

module.exports = router;