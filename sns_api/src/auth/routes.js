const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.post('/login', controller.Login_Verify);

router.post('/email', controller.Email_Verify);

module.exports = router;