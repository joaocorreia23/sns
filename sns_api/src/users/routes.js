const { Router } = require('express');
const controller = require('./controller');

const router = Router();

router.get('/', controller.Get_Users);

router.get('/table', controller.Get_Users_DataTable);

router.get('/table/disabled', controller.Get_Users_DataTable_Disabled);

router.get('/role/:role', controller.Get_UsersByRole);

router.post('/insert', controller.Add_User);

router.put('/update', controller.Update_User);

router.put('/update/info', controller.Update_User_Info)

router.post('/remove', controller.Delete_User);

router.post('/activate', controller.Activate_User);

router.post('/create_role', controller.Create_User_Role);

router.post('/manage_roles', controller.Manage_User_Roles);

router.get('/roles/:hashed_id', controller.Get_User_Roles);

router.get('/:hashed_id', controller.Get_UserByHashedId);

module.exports = router;