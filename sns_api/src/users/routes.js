const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.get('/', controller.getUsers);

router.get('/:hashed_id', controller.Get_UserByHashedId);


module.exports = router;