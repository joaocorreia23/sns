const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.get('/', controller.Get_Users);

router.get('/:hashed_id', controller.Get_UserByHashedId);

router.post('/insert', controller.Add_User);

router.put('/update', controller.Update_User);

router.put('/update/info', controller.Update_User_Info)

router.delete('/remove/:hashed_id', controller.Delete_User);

router.post('/create_role', controller.Create_User_Role);

router.get('/roles/:hashed_id', controller.Get_User_Roles);


module.exports = router;