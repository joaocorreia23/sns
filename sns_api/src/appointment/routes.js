const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.post('/insert', controller.Add_Appoitment);

module.exports = router;